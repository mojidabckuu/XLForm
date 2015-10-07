//
//  XLFormController.m
//  Pods
//
//  Created by vlad gorbenko on 10/6/15.
//
//

#import "XLFormController.h"

#import "XLFormRowDescriptor.h"
#import "XLFormDescriptor.h"

#import "XLTextBehavior.h"

#import "XLFormInlineRowDescriptorCell.h"

#import "XLFormRowNavigationAccessoryView.h"

#import "UIView+XLFormAdditions.h"

@interface XLFormController ()

@property (nonatomic, strong) XLFormRowNavigationAccessoryView * navigationAccessoryView;

@end

@implementation XLFormController

#pragma mark - Accessors

-(XLFormRowNavigationAccessoryView *)navigationAccessoryView {
    if (_navigationAccessoryView) return _navigationAccessoryView;
    _navigationAccessoryView = [XLFormRowNavigationAccessoryView new];
    _navigationAccessoryView.previousButton.target = self;
    _navigationAccessoryView.previousButton.action = @selector(rowNavigationAction:);
    _navigationAccessoryView.nextButton.target = self;
    _navigationAccessoryView.nextButton.action = @selector(rowNavigationAction:);
    _navigationAccessoryView.doneButton.target = self;
    _navigationAccessoryView.doneButton.action = @selector(rowNavigationDone:);
    _navigationAccessoryView.tintColor = self.formView.tintColor;
    return _navigationAccessoryView;
}

#pragma mark - User interaction

-(void)rowNavigationAction:(UIBarButtonItem *)sender {
    XLFormRowNavigationDirection direction = sender == self.navigationAccessoryView.nextButton ? XLFormRowNavigationDirectionNext : XLFormRowNavigationDirectionPrevious;
    [self navigateToDirection:direction];
}

-(void)rowNavigationDone:(UIBarButtonItem *)sender {
    [self.formView endEditing:YES];
}

#pragma mark - XLTextInput delegate

- (BOOL)textInputShouldClear:(id<UITextInput>)inputView formRow:(XLFormRowDescriptor *)formRow {
    return YES;
}

- (BOOL)textInputShouldBeginEditing:(id<UITextInput>)inputView formRow:(XLFormRowDescriptor *)formRow {
    XLFormRowDescriptor * nextRow = [self nextRowDescriptorForRow:formRow withDirection:XLFormRowNavigationDirectionNext];
    inputView.returnKeyType = nextRow ? UIReturnKeyNext : UIReturnKeyDefault;
    return YES;
}

- (BOOL)textInputShouldEndEditing:(id<UITextInput>)inputView formRow:(XLFormRowDescriptor *)formRow {
    return YES;
}

- (void)textInputViewDidBeginEditing:(id<UITextInput>)inputView formRow:(XLFormRowDescriptor *)formRow {
    
}

- (void)textInputViewDidEndEditing:(id<UITextInput>)inputView formRow:(XLFormRowDescriptor *)formRow {
    
}

- (BOOL)textInputViewShouldReturn:(id<UITextInput>)inputView formRow:(XLFormRowDescriptor *)formRow {
    // called when 'return' key pressed. return NO to ignore.
    XLFormRowDescriptor * nextRow = [self nextRowDescriptorForRow:formRow withDirection:XLFormRowNavigationDirectionNext];
    if (nextRow){
        id<XLFormDescriptorCell> nextCell = [nextRow cell];
        if ([nextCell formDescriptorCellCanBecomeFirstResponder]) {
            [nextCell formDescriptorCellBecomeFirstResponder];
            return YES;
        }
    }
    [self.formView endEditing:YES];
    return YES;
}

- (BOOL)textInputView:(id<UITextInput, XLTextInput>)inputView shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string formRow:(XLFormRowDescriptor *)formRow {
    NSString *text = [inputView.text stringByReplacingCharactersInRange:range withString:string];
    XLTextBehavior *behavior = (XLTextBehavior *)formRow.behavior;
    if([behavior instantMatching]) {
        if(behavior.regex) {
            NSPredicate *regex = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", behavior.regex];
            return [regex evaluateWithObject:text];
        } else {
            NSUInteger length = [inputView.text length] - range.length + [string length];
            inputView.text = [[inputView.text stringByReplacingCharactersInRange:range withString:string] substringToIndex:behavior.length];
            return length <= behavior.length;
        }
    }
    return YES;
}

#pragma mark - Form navigation

- (void)navigateToDirection:(XLFormRowNavigationDirection)direction {
    UIView * firstResponder = [self.formView findFirstResponder];
    id<XLFormDescriptorCell> currentCell = [firstResponder formDescriptorCell];
    NSIndexPath *currentIndexPath = [self.formView indexPathForCell:currentCell];
    XLFormRowDescriptor *currentRow = [self.form formRowAtIndex:currentIndexPath];
    XLFormRowDescriptor *nextRow = [self nextRowDescriptorForRow:currentRow withDirection:direction];
    if (nextRow) {
        id<XLFormDescriptorCell> cell = [nextRow cell];
        if ([cell formDescriptorCellCanBecomeFirstResponder]){
            NSIndexPath * indexPath = [self.form indexPathOfFormRow:nextRow];
            [self.formView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:NO];
            [cell formDescriptorCellBecomeFirstResponder];
        }
    }
}

#pragma mark - FormRow management

-(void)selectFormRow:(XLFormRowDescriptor *)formRow {
    
}

-(void)deselectFormRow:(XLFormRowDescriptor *)formRow {
    NSIndexPath * indexPath = [self.form indexPathOfFormRow:formRow];
    if (indexPath){
        [self.formView deselectItemAtIndexPath:indexPath animated:YES];
    }
}

-(void)reloadFormRow:(XLFormRowDescriptor *)formRow {
    
}

-(XLFormBaseCell *)updateFormRow:(XLFormRowDescriptor *)formRow {
    
}

#pragma mark - Utils

- (UIView *)inputAccessoryViewForRowDescriptor:(XLFormRowDescriptor *)formRow {
    if ((self.form.rowNavigationOptions & XLFormRowNavigationOptionEnabled) != XLFormRowNavigationOptionEnabled){
        return nil;
    }
    if ([[[[self class] inlineRowDescriptorTypesForRowDescriptorTypes] allKeys] containsObject:formRow.rowType]) {
        return nil;
    }
    id<XLFormDescriptorCell> cell = [formRow cell];
    if (![cell formDescriptorCellCanBecomeFirstResponder]){
        return nil;
    }
    XLFormRowDescriptor * previousRow = [self nextRowDescriptorForRow:formRow withDirection:XLFormRowNavigationDirectionPrevious];
    XLFormRowDescriptor * nextRow     = [self nextRowDescriptorForRow:formRow withDirection:XLFormRowNavigationDirectionNext];
    [self.navigationAccessoryView.previousButton setEnabled:(previousRow != nil)];
    [self.navigationAccessoryView.nextButton setEnabled:(nextRow != nil)];
    return self.navigationAccessoryView;
}

-(XLFormRowDescriptor *)nextRowDescriptorForRow:(XLFormRowDescriptor*)currentRow withDirection:(XLFormRowNavigationDirection)direction
{
    if (!currentRow || (self.form.rowNavigationOptions & XLFormRowNavigationOptionEnabled) != XLFormRowNavigationOptionEnabled) {
        return nil;
    }
    XLFormRowDescriptor * nextRow = (direction == XLFormRowNavigationDirectionNext) ? [self.form nextRowDescriptorForRow:currentRow] : [self.form previousRowDescriptorForRow:currentRow];
    if (!nextRow) {
        return nil;
    }
    if ([[nextRow cell] conformsToProtocol:@protocol(XLFormInlineRowDescriptorCell)]) {
        id<XLFormInlineRowDescriptorCell> inlineCell = (id<XLFormInlineRowDescriptorCell>)[nextRow cell];
        if (inlineCell.inlineRowDescriptor){
            return [self nextRowDescriptorForRow:nextRow withDirection:direction];
        }
    }
    XLFormRowNavigationOptions rowNavigationOptions = self.form.rowNavigationOptions;
    if (nextRow.isDisabled && ((rowNavigationOptions & XLFormRowNavigationOptionStopDisableRow) == XLFormRowNavigationOptionStopDisableRow)){
        return nil;
    }
    if (!nextRow.isDisabled && ((rowNavigationOptions & XLFormRowNavigationOptionStopInlineRow) == XLFormRowNavigationOptionStopInlineRow) && [[[XLFormViewController inlineRowDescriptorTypesForRowDescriptorTypes] allKeys] containsObject:nextRow.rowType]){
        return nil;
    }
    id<XLFormDescriptorCell> cell = [nextRow cell];
    if (!nextRow.isDisabled && ((rowNavigationOptions & XLFormRowNavigationOptionSkipCanNotBecomeFirstResponderRow) != XLFormRowNavigationOptionSkipCanNotBecomeFirstResponderRow) && (![cell formDescriptorCellCanBecomeFirstResponder])){
        return nil;
    }
    if (!nextRow.isDisabled && [cell formDescriptorCellCanBecomeFirstResponder]){
        return nextRow;
    }
    return [self nextRowDescriptorForRow:nextRow withDirection:direction];
}

@end
