//
//  FTXLBaseTableViewCell.m
//  ALJ
//
//  Created by Alex Zdorovets on 5/21/15.
//  Copyright (c) 2015 Alex Zdorovets. All rights reserved.
//

#import "FTXLBaseTableViewCell.h"

#import "XLForm.h"

#import "XLForm+Helpers.h"

@interface FTXLBaseTableViewCell () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) XLFormRowDescriptor *inlineFormRowDescriptor;

@end

@implementation FTXLBaseTableViewCell

@synthesize errorView;

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    [self update];
}

- (void)update {
    [super update];
    [self updateError];
}

+ (void)load {
    [XLFormViewController.cellClassesForRowDescriptorTypes setObject:[[self class] identifier] forKey:[[self class] identifier]];
}

#pragma mark - XLFormDescriptorCell protocol

-(UIView *)inputView {
    if (self.rowDescriptor.selectionStyle == XLFormRowSelectionStylePicker) {
        if (self.rowDescriptor.selectionType == XLFormRowSelectionTypePickerView) {
            return self.pickerView;
        }
        if (self.rowDescriptor.selectionType == XLFormRowSelectionTypeDatePicker) {
            return self.datePicker;
        }
    }
    return [super inputView];
}

-(BOOL)formDescriptorCellCanBecomeFirstResponder {
    if(self.rowDescriptor.selectionStyle == XLFormRowSelectionStyleInline) {
        return !self.rowDescriptor.isDisabled;
    }
    return NO;
}

-(BOOL)formDescriptorCellBecomeFirstResponder {
    if(self.rowDescriptor.selectionStyle == XLFormRowSelectionStyleInline) {
        if ([self isFirstResponder]){
            [self resignFirstResponder];
            return NO;
        }
        return [self becomeFirstResponder];
    }
    return [super formDescriptorCellBecomeFirstResponder];
}

- (BOOL)canBecomeFirstResponder {
    if(self.rowDescriptor.selectionStyle == XLFormRowSelectionStyleInline) {
        if(self.rowDescriptor.selectionType == XLFormRowSelectionTypePickerView) {
            return self.rowDescriptor.selectorOptions.count && !self.rowDescriptor.isDisabled;
        } else if(self.rowDescriptor.selectionType == XLFormRowSelectionTypeDatePicker) {
            return !self.rowDescriptor.isDisabled;
        }
    }
    return [super canBecomeFirstResponder];
}

- (BOOL)becomeFirstResponder {
    if(self.rowDescriptor.selectionStyle == XLFormRowSelectionStyleInline) {
        if (self.isFirstResponder){
            return [super becomeFirstResponder];
        }
        BOOL result = [super becomeFirstResponder];
        if (result) {
            NSString *type = nil;
            switch (self.rowDescriptor.selectionType) {
                case XLFormRowSelectionTypeDatePicker:
                    type = XLFormRowDescriptorTypeDatePicker;
                    break;
                case XLFormRowSelectionTypePickerView:
                    type = XLFormRowDescriptorTypePicker;
                    break;
                default:
                    break;
            }
            XLFormRowDescriptor * inlineRowDescriptor = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:type];
            [inlineRowDescriptor.cellConfig setValuesForKeysWithDictionary:self.rowDescriptor.cellConfigIfInlined];
            UITableViewCell<XLFormDescriptorCell> * cell = [inlineRowDescriptor cellForFormController:self.formViewController];
            NSAssert([cell conformsToProtocol:@protocol(XLFormInlineRowDescriptorCell)], @"inline cell must conform to XLFormInlineRowDescriptorCell");
            UITableViewCell<XLFormInlineRowDescriptorCell> * inlineCell = (UITableViewCell<XLFormInlineRowDescriptorCell> *)cell;
            inlineCell.inlineRowDescriptor = self.rowDescriptor;
            [self.rowDescriptor.sectionDescriptor addFormRow:inlineRowDescriptor afterRow:self.rowDescriptor];
            [self.formViewController ensureRowIsVisible:inlineRowDescriptor];
        }
        return result;
    }
    return [super becomeFirstResponder];
}

-(BOOL)resignFirstResponder {
    if(self.rowDescriptor.selectionStyle == XLFormRowSelectionStyleInline) {
        NSIndexPath * selectedRowPath = [self.formViewController.form indexPathOfFormRow:self.rowDescriptor];
        NSIndexPath * nextRowPath = [NSIndexPath indexPathForRow:selectedRowPath.row + 1 inSection:selectedRowPath.section];
        XLFormRowDescriptor * nextFormRow = [self.formViewController.form formRowAtIndex:nextRowPath];
        XLFormSectionDescriptor * formSection = [self.formViewController.form.formSections objectAtIndex:nextRowPath.section];
        BOOL result = [super resignFirstResponder];
        [formSection removeFormRow:nextFormRow];
        return result;
    }
    return [super resignFirstResponder];
}

-(void)formDescriptorCellDidSelectedWithFormController:(XLFormViewController *)controller {
    if(self.rowDescriptor.selectionStyle != XLFormRowSelectionStyleUndefined) {
        [self performSelectionWithFormController:controller];
    }
}

#pragma mark - Accessors

-(UIPickerView *)pickerView {
    if (_pickerView) return _pickerView;
    _pickerView = [[UIPickerView alloc] init];
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    [_pickerView selectRow:[self selectedIndex] inComponent:0 animated:NO];
    return _pickerView;
}

// TODO: don't forget setup range, current date.

-(UIDatePicker *)datePicker {
    if (_datePicker) return _datePicker;
    _datePicker = [[UIDatePicker alloc] init];
    [_datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    return _datePicker;
}

- (void)datePickerValueChanged:(UIDatePicker *)sender {
    self.rowDescriptor.value = sender.date;
    [self update];
    [self setNeedsLayout];
}

-(NSInteger)selectedIndex
{
    if (self.rowDescriptor.value){
        for (id option in self.rowDescriptor.selectorOptions){
            if ([[option valueData] isEqual:[self.rowDescriptor.value valueData]]){
                return [self.rowDescriptor.selectorOptions indexOfObject:option];
            }
        }
    }
    return -1;
}

#pragma mark - Utils

- (void)updateError {
    [self.errorView setError:self.rowDescriptor.error];
}

- (void)performSelectionWithFormController:(XLFormViewController *)viewController {
    if(self.rowDescriptor.selectionStyle == XLFormRowSelectionStylePush || self.rowDescriptor.selectionStyle == XLFormRowSelectionStylePopover) {
        if(self.rowDescriptor.action.formSegueIdenfifier) {
            [viewController performSegueWithIdentifier:self.rowDescriptor.action.formSegueIdenfifier sender:self.rowDescriptor];
//        } else if(self.rowDescriptor.action.formSegueClass) {
//            UIViewController * controllerToPresent = [self controllerToPresent];
//            NSAssert(controllerToPresent, @"either rowDescriptor.action.viewControllerClass or rowDescriptor.action.viewControllerStoryboardId or rowDescriptor.action.viewControllerNibName must be assigned");
//            NSAssert([controllerToPresent conformsToProtocol:@protocol(XLFormRowDescriptorViewController)], @"selector view controller must conform to XLFormRowDescriptorViewController protocol");
//            UIStoryboardSegue * segue = [[self.rowDescriptor.action.formSegueClass alloc] initWithIdentifier:self.rowDescriptor.tag source:controller destination:controllerToPresent];
//            [controller prepareForSegue:segue sender:self.rowDescriptor];
//            [segue perform];
            //        } else if ((controllerToPresent = [self controllerToPresent])){
//            NSAssert([controllerToPresent conformsToProtocol:@protocol(XLFormRowDescriptorViewController)], @"rowDescriptor.action.viewControllerClass must conform to XLFormRowDescriptorViewController protocol");
//            UIViewController<XLFormRowDescriptorViewController> *selectorViewController = (UIViewController<XLFormRowDescriptorViewController> *)controllerToPresent;
//            selectorViewController.rowDescriptor = self.rowDescriptor;
//            selectorViewController.title = self.rowDescriptor.selectorTitle;
//            
//            if ([self.rowDescriptor.rowType isEqualToString:XLFormRowDescriptorTypeSelectorPopover]) {
//                if (self.popoverController && self.popoverController.popoverVisible) {
//                    [self.popoverController dismissPopoverAnimated:NO];
//                }
//                self.popoverController = [[UIPopoverController alloc] initWithContentViewController:selectorViewController];
//                self.popoverController.delegate = self;
//                if ([selectorViewController conformsToProtocol:@protocol(XLFormRowDescriptorPopoverViewController)]){
//                    ((id<XLFormRowDescriptorPopoverViewController>)selectorViewController).popoverController = self.popoverController;
//                }
//                if (self.detailTextLabel.window){
//                    [self.popoverController presentPopoverFromRect:CGRectMake(0, 0, self.detailTextLabel.frame.size.width, self.detailTextLabel.frame.size.height) inView:self.detailTextLabel permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
//                }
//                else{
//                    [self.popoverController presentPopoverFromRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) inView:self permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
//                }
//                [controller.tableView deselectRowAtIndexPath:[controller.tableView indexPathForCell:self] animated:YES];
//            }
//            else {
//                [controller.navigationController pushViewController:selectorViewController animated:YES];
//            }
        }
    }
    
    if(self.rowDescriptor.selectionStyle == XLFormRowSelectionStyleActionSheet) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED < 80000
        UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:self.rowDescriptor.selectorTitle
                                                                  delegate:self
                                                         cancelButtonTitle:nil
                                                    destructiveButtonTitle:nil
                                                         otherButtonTitles:nil];
        for (id option in self.rowDescriptor.selectorOptions) {
            [actionSheet addButtonWithTitle:[option displayText]];
        }
        actionSheet.cancelButtonIndex = [actionSheet addButtonWithTitle:NSLocalizedString(@"Cancel", nil)];
        actionSheet.tag = [self.rowDescriptor hash];
        [actionSheet showInView:controller.view];
#else
        if ([UIAlertController class]) {
            UIAlertController * alertController = [UIAlertController alertControllerWithTitle:self.rowDescriptor.selectorTitle
                                                                                      message:nil
                                                                               preferredStyle:UIAlertControllerStyleActionSheet];
            [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                                                style:UIAlertActionStyleCancel
                                                              handler:nil]];
            __weak __typeof(self)weakSelf = self;
            for (id option in self.rowDescriptor.selectorOptions) {
                [alertController addAction:[UIAlertAction actionWithTitle:[option displayText]
                                                                    style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction *action) {
                                                                      [weakSelf.rowDescriptor setValue:option];
                                                                      [weakSelf.formViewController.tableView reloadData];
                                                                  }]];
            }
            [self.formViewController presentViewController:alertController animated:YES completion:nil];
        }
        else{
            UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:self.rowDescriptor.selectorTitle
                                                                      delegate:self
                                                             cancelButtonTitle:nil
                                                        destructiveButtonTitle:nil
                                                             otherButtonTitles:nil];
            for (id option in self.rowDescriptor.selectorOptions) {
                [actionSheet addButtonWithTitle:[option displayText]];
            }
            actionSheet.cancelButtonIndex = [actionSheet addButtonWithTitle:NSLocalizedString(@"Cancel", nil)];
            actionSheet.tag = [self.rowDescriptor hash];
            [actionSheet showInView:viewController.view];
        }
#endif
        [viewController.tableView deselectRowAtIndexPath:[viewController.form indexPathOfFormRow:self.rowDescriptor] animated:YES];
    }
    
    if(self.rowDescriptor.selectionStyle == XLFormRowSelectionStyleAlertView) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED < 80000
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:self.rowDescriptor.selectorTitle
                                                             message:nil
                                                            delegate:self
                                                   cancelButtonTitle:nil
                                                   otherButtonTitles:nil];
        for (id option in self.rowDescriptor.selectorOptions) {
            [alertView addButtonWithTitle:[option displayText]];
        }
        alertView.cancelButtonIndex = [alertView addButtonWithTitle:NSLocalizedString(@"Cancel", nil)];
        alertView.tag = [self.rowDescriptor hash];
        [alertView show];
#else
        if ([UIAlertController class]) {
            UIAlertController * alertController = [UIAlertController alertControllerWithTitle:self.rowDescriptor.selectorTitle
                                                                                      message:nil
                                                                               preferredStyle:UIAlertControllerStyleAlert];
            __weak __typeof(self)weakSelf = self;
            for (id option in self.rowDescriptor.selectorOptions) {
                [alertController addAction:[UIAlertAction actionWithTitle:[option displayText]
                                                                    style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction *action) {
                                                                      [weakSelf.rowDescriptor setValue:option];
                                                                      [weakSelf.formViewController.tableView reloadData];
                                                                  }]];
            }
            [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil)
                                                                style:UIAlertActionStyleCancel
                                                              handler:nil]];
            [viewController presentViewController:alertController animated:YES completion:nil];
            
        }
        else{
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:self.rowDescriptor.selectorTitle
                                                                 message:nil
                                                                delegate:self
                                                       cancelButtonTitle:nil
                                                       otherButtonTitles:nil];
            for (id option in self.rowDescriptor.selectorOptions) {
                [alertView addButtonWithTitle:[option displayText]];
            }
            alertView.cancelButtonIndex = [alertView addButtonWithTitle:NSLocalizedString(@"Cancel", nil)];
            alertView.tag = [self.rowDescriptor hash];
            [alertView show];
        }
#endif
        [viewController.tableView deselectRowAtIndexPath:[viewController.form indexPathOfFormRow:self.rowDescriptor] animated:YES];
    }
    
    if(self.rowDescriptor.selectionStyle == XLFormRowSelectionStylePicker) {
        [viewController.tableView selectRowAtIndexPath:nil animated:YES scrollPosition:UITableViewScrollPositionNone];
    }
    
    if(self.rowDescriptor.selectionStyle == XLFormRowSelectionStyleInline) {
        [viewController.tableView deselectRowAtIndexPath:[viewController.form indexPathOfFormRow:self.rowDescriptor] animated:YES];
    }
   
//        else if (self.rowDescriptor.selectorOptions){
//            XLFormOptionsViewController * optionsViewController = [[XLFormOptionsViewController alloc] initWithStyle:UITableViewStyleGrouped titleHeaderSection:nil titleFooterSection:nil];
//            optionsViewController.rowDescriptor = self.rowDescriptor;
//            optionsViewController.title = self.rowDescriptor.selectorTitle;
//            
//            if ([self.rowDescriptor.rowType isEqualToString:XLFormRowDescriptorTypeSelectorPopover]) {
//                self.popoverController = [[UIPopoverController alloc] initWithContentViewController:optionsViewController];
//                self.popoverController.delegate = self;
//                optionsViewController.popoverController = self.popoverController;
//                if (self.detailTextLabel.window){
//                    [self.popoverController presentPopoverFromRect:CGRectMake(0, 0, self.detailTextLabel.frame.size.width, self.detailTextLabel.frame.size.height) inView:self.detailTextLabel permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
//                }
//                else{
//                    [self.popoverController presentPopoverFromRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) inView:self permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
//                }
//                [controller.tableView deselectRowAtIndexPath:[controller.tableView indexPathForCell:self] animated:YES];
//            } else {
//                [controller.navigationController pushViewController:optionsViewController animated:YES];
//            }
//        }
//    }
//    else if ([self.rowDescriptor.rowType isEqualToString:XLFormRowDescriptorTypeMultipleSelector] || [self.rowDescriptor.rowType isEqualToString:XLFormRowDescriptorTypeMultipleSelectorPopover])
//    {
//        NSAssert(self.rowDescriptor.selectorOptions, @"selectorOptions property shopuld not be nil");
//        XLFormOptionsViewController * optionsViewController = [[XLFormOptionsViewController alloc] initWithStyle:UITableViewStyleGrouped titleHeaderSection:nil titleFooterSection:nil];
//        optionsViewController.rowDescriptor = self.rowDescriptor;
//        optionsViewController.title = self.rowDescriptor.selectorTitle;
//        
//        if ([self.rowDescriptor.rowType isEqualToString:XLFormRowDescriptorTypeMultipleSelectorPopover]) {
//            self.popoverController = [[UIPopoverController alloc] initWithContentViewController:optionsViewController];
//            self.popoverController.delegate = self;
//            optionsViewController.popoverController = self.popoverController;
//            if (self.detailTextLabel.window){
//                [self.popoverController presentPopoverFromRect:CGRectMake(0, 0, self.detailTextLabel.frame.size.width, self.detailTextLabel.frame.size.height) inView:self.detailTextLabel permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
//            }
//            else{
//                [self.popoverController presentPopoverFromRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) inView:self permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
//            }
//            [controller.tableView deselectRowAtIndexPath:[controller.tableView indexPathForCell:self] animated:YES];
//        } else {
//            [controller.navigationController pushViewController:optionsViewController animated:YES];
//        }
//    }
}

-(NSString *)valueDisplayText {
    
    if(self.rowDescriptor.mutlipleSelection) {
        if (!self.rowDescriptor.value || [self.rowDescriptor.value count] == 0){
            return self.rowDescriptor.noValueDisplayText;
        }
        
        if (self.rowDescriptor.valueTransformer){
            NSAssert([self.rowDescriptor.valueTransformer isSubclassOfClass:[NSValueTransformer class]], @"valueTransformer is not a subclass of NSValueTransformer");
            NSValueTransformer * valueTransformer = [self.rowDescriptor.valueTransformer new];
            NSString * tranformedValue = [valueTransformer transformedValue:self.rowDescriptor.value];
            if (tranformedValue){
                return tranformedValue;
            }
        }
    }
    
//    if ([self.rowDescriptor.rowType isEqualToString:XLFormRowDescriptorTypeMultipleSelector] || [self.rowDescriptor.rowType isEqualToString:XLFormRowDescriptorTypeMultipleSelectorPopover]){
//        NSMutableArray * descriptionArray = [NSMutableArray arrayWithCapacity:[self.rowDescriptor.value count]];
//        for (id option in self.rowDescriptor.selectorOptions) {
//            NSArray * selectedValues = self.rowDescriptor.value;
//            if ([selectedValues formIndexForItem:option] != NSNotFound){
//                if (self.rowDescriptor.valueTransformer){
//                    NSAssert([self.rowDescriptor.valueTransformer isSubclassOfClass:[NSValueTransformer class]], @"valueTransformer is not a subclass of NSValueTransformer");
//                    NSValueTransformer * valueTransformer = [self.rowDescriptor.valueTransformer new];
//                    NSString * tranformedValue = [valueTransformer transformedValue:option];
//                    if (tranformedValue){
//                        [descriptionArray addObject:tranformedValue];
//                    }
//                }
//                else{
//                    [descriptionArray addObject:[option displayText]];
//                }
//            }
//        }
//        return [descriptionArray componentsJoinedByString:@", "];
//    }
    if (!self.rowDescriptor.value){
        return self.rowDescriptor.noValueDisplayText;
    }
    if (self.rowDescriptor.valueTransformer){
        NSAssert([self.rowDescriptor.valueTransformer isSubclassOfClass:[NSValueTransformer class]], @"valueTransformer is not a subclass of NSValueTransformer");
        NSValueTransformer * valueTransformer = [self.rowDescriptor.valueTransformer new];
        NSString * tranformedValue = [valueTransformer transformedValue:self.rowDescriptor.value];
        if (tranformedValue){
            return tranformedValue;
        }
    }
    return [self.rowDescriptor.value displayText];
}

@end
