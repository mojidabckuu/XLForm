//
//  XLFormViewController.m
//  XLForm ( https://github.com/xmartlabs/XLForm )
//
//  Copyright (c) 2015 Xmartlabs ( http://xmartlabs.com )
//
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "UIView+XLFormAdditions.h"
#import "NSObject+XLFormAdditions.h"
#import "XLFormViewController.h"
#import "UIView+XLFormAdditions.h"
#import "XLForm.h"
#import "NSString+XLFormAdditions.h"

#import "XLFormContentFactory.h"
#import "XLFormContent.h"

#import "XLFormRowNavigationAccessoryView.h"

@interface XLFormRowDescriptor(_XLFormViewController)

@property (readonly) NSArray * observers;
-(BOOL)evaluateIsDisabled;
-(BOOL)evaluateIsHidden;

@end

@interface XLFormSectionDescriptor(_XLFormViewController)

-(BOOL)evaluateIsHidden;

@end

@interface XLFormDescriptor (_XLFormViewController)

@property NSMutableDictionary* rowObservers;

@end


@interface XLFormViewController() {
    NSNumber *_oldBottomTableContentInset;
    CGRect _keyboardFrame;
}
@property UITableViewStyle tableViewStyle;

@end

@implementation XLFormViewController

@synthesize form = _form;

#pragma mark - Lifecycle

-(id)initWithForm:(XLFormDescriptor *)form
{
    return [self initWithForm:form style:UITableViewStyleGrouped];
}

-(id)initWithForm:(XLFormDescriptor *)form style:(UITableViewStyle)style
{
    self = [self initWithNibName:nil bundle:nil];
    if (self){
        _tableViewStyle = style;
        _form = form;
    }
    return self;
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self){
        [self defaultInitialize];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self){
        [self defaultInitialize];
    }
    return self;
}

-(void)defaultInitialize
{
    _form = nil;
    _tableViewStyle = UITableViewStyleGrouped;
}

- (void)dealloc
{
    self.formView.delegate = nil;
    self.formView.dataSource = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (!self.formView){
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:self.tableViewStyle];
        self.formView = (UIScrollView<XLCollectionViewProtocol> *)tableView;
        self.formView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    if (!self.formView.superview){
        [self.view addSubview:self.formView];
    }
    
    id content = [XLFormContentFactory formContentWithView:self.formView];
    
    if (!self.formView.delegate) {
        self.formView.delegate = content;
    }
    if (!self.formView.dataSource){
        self.formView.dataSource = content;
    }
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")){
//        self.formView.rowHeight = UITableViewAutomaticDimension;
//        self.formView.estimatedRowHeight = 44.0;
    }
    if (self.form.title){
        self.title = self.form.title;
    }
//    [self.formView setEditing:YES animated:NO];
//    self.formView.allowsSelectionDuringEditing = YES;
    self.form.delegate = self;
    _oldBottomTableContentInset = nil;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSIndexPath *selected = [self.formView indexPathForSelectedRow];
    if (selected){
        // Trigger a cell refresh
        XLFormRowDescriptor * rowDescriptor = [self.form formRowAtIndex:selected];
        [self.formContent updateFormRow:rowDescriptor];
        [self.formView selectItemAtIndexPath:selected animated:NO scrollPosition:UITableViewScrollPositionNone];
        [self.formView deselectItemAtIndexPath:selected animated:YES];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(contentSizeCategoryChanged:)
                                                 name:UIContentSizeCategoryDidChangeNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];

}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIContentSizeCategoryDidChangeNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.form.assignFirstResponderOnShow) {
        self.form.assignFirstResponderOnShow = NO;
        [self.form setFirstResponder:self];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - CellClasses

+(NSMutableDictionary *)cellClassesForRowDescriptorTypes
{
    static NSMutableDictionary * _cellClassesForRowDescriptorTypes;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _cellClassesForRowDescriptorTypes = [@{
//                                               XLFormRowDescriptorTypeText:[XLFormTextFieldCell class],
//                                               XLFormRowDescriptorTypeName: [XLFormTextFieldCell class],
//                                               XLFormRowDescriptorTypePhone:[XLFormTextFieldCell class],
//                                               XLFormRowDescriptorTypeURL:[XLFormTextFieldCell class],
//                                               XLFormRowDescriptorTypeEmail: [XLFormTextFieldCell class],
//                                               XLFormRowDescriptorTypeTwitter: [XLFormTextFieldCell class],
//                                               XLFormRowDescriptorTypeAccount: [XLFormTextFieldCell class],
//                                               XLFormRowDescriptorTypePassword: [XLFormTextFieldCell class],
//                                               XLFormRowDescriptorTypeNumber: [XLFormTextFieldCell class],
//                                               XLFormRowDescriptorTypeInteger: [XLFormTextFieldCell class],
//                                               XLFormRowDescriptorTypeDecimal: [XLFormTextFieldCell class],
//                                               XLFormRowDescriptorTypeZipCode: [XLFormTextFieldCell class],
//                                               XLFormRowDescriptorTypeSelectorPush: [XLFormSelectorCell class],
//                                               XLFormRowDescriptorTypeSelectorPopover: [XLFormSelectorCell class],
//                                               XLFormRowDescriptorTypeSelectorActionSheet: [XLFormSelectorCell class],
//                                               XLFormRowDescriptorTypeSelectorAlertView: [XLFormSelectorCell class],
//                                               XLFormRowDescriptorTypeSelectorPickerView: [XLFormSelectorCell class],
//                                               XLFormRowDescriptorTypeSelectorPickerViewInline: [XLFormInlineSelectorCell class],
//                                               XLFormRowDescriptorTypeSelectorSegmentedControl: [XLFormSegmentedCell class],
//                                               XLFormRowDescriptorTypeMultipleSelector: [XLFormSelectorCell class],
//                                               XLFormRowDescriptorTypeMultipleSelectorPopover: [XLFormSelectorCell class],
//                                               XLFormRowDescriptorTypeTextView: [XLFormTextViewCell class],
//                                               XLFormRowDescriptorTypeButton: [XLFormButtonCell class],
//                                               XLFormRowDescriptorTypeInfo: [XLFormSelectorCell class],
                                               XLFormRowDescriptorTypeBooleanSwitch : [XLFormSwitchCell class],
                                               XLFormRowDescriptorTypeBooleanCheck : [XLFormCheckCell class],
                                               XLFormRowDescriptorTypeDate: [XLFormDateCell class],
                                               XLFormRowDescriptorTypeTime: [XLFormDateCell class],
                                               XLFormRowDescriptorTypeDateTime : [XLFormDateCell class],
                                               XLFormRowDescriptorTypeCountDownTimer : [XLFormDateCell class],
                                               XLFormRowDescriptorTypeDateInline: [XLFormDateCell class],
                                               XLFormRowDescriptorTypeTimeInline: [XLFormDateCell class],
                                               XLFormRowDescriptorTypeDateTimeInline: [XLFormDateCell class],
                                               XLFormRowDescriptorTypeCountDownTimerInline : [XLFormDateCell class],
                                               XLFormRowDescriptorTypeDatePicker : [XLFormDatePickerCell class],
                                               XLFormRowDescriptorTypePicker : [XLFormPickerCell class],
                                               XLFormRowDescriptorTypeSlider : [XLFormSliderCell class],
                                               XLFormRowDescriptorTypeSelectorLeftRight : [XLFormLeftRightSelectorCell class],
                                               XLFormRowDescriptorTypeStepCounter: [XLFormStepCounterCell class]
                                               } mutableCopy];
    });
    return _cellClassesForRowDescriptorTypes;
}

#pragma mark - inlineRowDescriptorTypes

+(NSMutableDictionary *)inlineRowDescriptorTypesForRowDescriptorTypes
{
    static NSMutableDictionary * _inlineRowDescriptorTypesForRowDescriptorTypes;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _inlineRowDescriptorTypesForRowDescriptorTypes = [
                                                          @{XLFormRowDescriptorTypeSelectorPickerViewInline: XLFormRowDescriptorTypePicker,
                                                            XLFormRowDescriptorTypeDateInline: XLFormRowDescriptorTypeDatePicker,
                                                            XLFormRowDescriptorTypeDateTimeInline: XLFormRowDescriptorTypeDatePicker,
                                                            XLFormRowDescriptorTypeTimeInline: XLFormRowDescriptorTypeDatePicker,
                                                            XLFormRowDescriptorTypeCountDownTimerInline: XLFormRowDescriptorTypeDatePicker
                                                            } mutableCopy];
    });
    return _inlineRowDescriptorTypesForRowDescriptorTypes;
}

#pragma mark - XLFormDescriptorDelegate

-(void)formRowHasBeenAdded:(XLFormRowDescriptor *)formRow atIndexPath:(NSIndexPath *)indexPath {
    [self.formView insertItemsAtIndexPaths:@[indexPath] withItemAnimation:[self insertRowAnimationForRow:formRow]];
}

-(void)formRowHasBeenRemoved:(XLFormRowDescriptor *)formRow atIndexPath:(NSIndexPath *)indexPath {
    [self.formView deleteItemsAtIndexPaths:@[indexPath] withItemAnimation:[self deleteRowAnimationForRow:formRow]];
}

-(void)formSectionHasBeenRemoved:(XLFormSectionDescriptor *)formSection atIndex:(NSUInteger)index {
    [self.formView deleteSectionAtIndexSet:[NSIndexSet indexSetWithIndex:index] withItemAnimation:[self deleteRowAnimationForSection:formSection]];
}

-(void)formSectionHasBeenAdded:(XLFormSectionDescriptor *)formSection atIndex:(NSUInteger)index {
    [self.formView insertSectionAtIndexSet:[NSIndexSet indexSetWithIndex:0] withItemAnimation:[self insertRowAnimationForSection:formSection]];
}

-(void)formRowDescriptorValueHasChanged:(XLFormRowDescriptor *)formRow oldValue:(id)oldValue newValue:(id)newValue {
    [self updateAfterDependentRowChanged:formRow];
}

- (BOOL)formRowDescriptorShouldBecomeResponderer:(XLFormRowDescriptor *)formRow {
    return YES;
}

- (BOOL)formRowDescriptorShouldResignResponderer:(XLFormRowDescriptor *)formRow {
    return YES;
}

-(void)formRowDescriptorHasChangeHidhlight:(XLFormRowDescriptor *)formRow hightlight:(BOOL)hightlight {
}

-(void)formRowDescriptorPredicateHasChanged:(XLFormRowDescriptor *)formRow oldValue:(id)oldValue newValue:(id)newValue predicateType:(XLPredicateType)predicateType
{
    if (oldValue != newValue) {
        [self updateAfterDependentRowChanged:formRow];
    }
}

-(void)updateAfterDependentRowChanged:(XLFormRowDescriptor *)formRow
{
    [self.formContent updateFormRow:formRow];
    NSMutableArray* revaluateHidden   = self.form.rowObservers[[formRow.tag formKeyForPredicateType:XLPredicateTypeHidden]];
    NSMutableArray* revaluateDisabled = self.form.rowObservers[[formRow.tag formKeyForPredicateType:XLPredicateTypeDisabled]];
    for (id object in revaluateDisabled) {
        if ([object isKindOfClass:[NSString class]]) {
            XLFormRowDescriptor* row = [self.form formRowWithTag:object];
            if (row){
                [row evaluateIsDisabled];
                [self.formContent updateFormRow:row];
            }
        }
    }
    for (id object in revaluateHidden) {
        if ([object isKindOfClass:[NSString class]]) {
            XLFormRowDescriptor* row = [self.form formRowWithTag:object];
            if (row){
                [row evaluateIsHidden];
            }
        }
        else if ([object isKindOfClass:[XLFormSectionDescriptor class]]) {
            XLFormSectionDescriptor* section = (XLFormSectionDescriptor*) object;
            [section evaluateIsHidden];
        }
    }
}

#pragma mark - XLFormViewControllerDelegate

-(NSDictionary *)formValues
{
    return [self.form formValues];
}

-(NSDictionary *)httpParameters
{
    return [self.form httpParameters:self];
}

-(UITableViewRowAnimation)insertRowAnimationForRow:(XLFormRowDescriptor *)formRow
{
    if (formRow.sectionDescriptor.sectionOptions & XLFormSectionOptionCanInsert){
        if (formRow.sectionDescriptor.sectionInsertMode == XLFormSectionInsertModeButton){
            return UITableViewRowAnimationAutomatic;
        }
        else if (formRow.sectionDescriptor.sectionInsertMode == XLFormSectionInsertModeLastRow){
            return YES;
        }
    }
    return UITableViewRowAnimationFade;
}

-(UITableViewRowAnimation)deleteRowAnimationForRow:(XLFormRowDescriptor *)formRow
{
    return UITableViewRowAnimationFade;
}

-(UITableViewRowAnimation)insertRowAnimationForSection:(XLFormSectionDescriptor *)formSection
{
    return UITableViewRowAnimationAutomatic;
}

-(UITableViewRowAnimation)deleteRowAnimationForSection:(XLFormSectionDescriptor *)formSection
{
    return UITableViewRowAnimationAutomatic;
}

-(void)beginEditing:(XLFormRowDescriptor *)rowDescriptor
{
    [[rowDescriptor cellForFormController:self] highlight];
}

-(void)endEditing:(XLFormRowDescriptor *)rowDescriptor
{
    [[rowDescriptor cellForFormController:self] unhighlight];
}

#pragma mark - User interaction

-(void)rowNavigationAction:(UIBarButtonItem *)sender {
    XLFormRowNavigationDirection direction = sender == self.formContent.navigationAccessoryView.nextButton ? XLFormRowNavigationDirectionNext : XLFormRowNavigationDirectionPrevious;
    [self.formContent navigateToDirection:direction];
}

-(void)rowNavigationDone:(UIBarButtonItem *)sender {
    [self.formView endEditing:YES];
}

#pragma mark - Methods

-(NSArray *)formValidationErrors
{
    return [self.form localValidationErrors:self];
}

-(void)showFormValidationError:(NSError *)error
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED < 80000
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"XLFormViewController_ValidationErrorTitle", nil)
                                                         message:error.localizedDescription
                                                        delegate:self
                                               cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                               otherButtonTitles:nil];
    [alertView show];
#else
    if ([UIAlertController class]){
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"XLFormViewController_ValidationErrorTitle", nil)
                                                                                  message:error.localizedDescription
                                                                           preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK"
                                                            style:UIAlertActionStyleDefault
                                                          handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else{
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"XLFormViewController_ValidationErrorTitle", nil)
                                                             message:error.localizedDescription
                                                            delegate:self
                                                   cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                   otherButtonTitles:nil];
        [alertView show];
    }
#endif
}

#pragma mark - Private

- (void)contentSizeCategoryChanged:(NSNotification *)notification
{
    [self.formView reloadData];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    UIView * firstResponderView = [self.formView findFirstResponder];
    UITableViewCell<XLFormDescriptorCell> * cell = [firstResponderView formDescriptorCell];
    if (cell){
        NSDictionary *keyboardInfo = [notification userInfo];
        _keyboardFrame = [self.formView.window convertRect:[keyboardInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue] toView:self.formView.superview];
        CGFloat newBottomInset = self.formView.frame.origin.y + self.formView.frame.size.height - _keyboardFrame.origin.y;
        UIEdgeInsets tableContentInset = self.formView.contentInset;
        UIEdgeInsets tableScrollIndicatorInsets = self.formView.scrollIndicatorInsets;
        _oldBottomTableContentInset = _oldBottomTableContentInset ?: @(tableContentInset.bottom);
        if (newBottomInset > [_oldBottomTableContentInset floatValue]){
            tableContentInset.bottom = newBottomInset;
            tableScrollIndicatorInsets.bottom = tableContentInset.bottom;
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:[keyboardInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
            [UIView setAnimationCurve:[keyboardInfo[UIKeyboardAnimationCurveUserInfoKey] intValue]];
            self.formView.contentInset = tableContentInset;
            self.formView.scrollIndicatorInsets = tableScrollIndicatorInsets;
            NSIndexPath *selectedRow = [self.formView indexPathForCell:cell];
            [self.formView scrollToRowAtIndexPath:selectedRow atScrollPosition:UITableViewScrollPositionNone animated:NO];
            [UIView commitAnimations];
        }
    }
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    UIView * firstResponderView = [self.formView findFirstResponder];
    UITableViewCell<XLFormDescriptorCell> * cell = [firstResponderView formDescriptorCell];
    if (cell){
        _keyboardFrame = CGRectZero;
        NSDictionary *keyboardInfo = [notification userInfo];
        UIEdgeInsets tableContentInset = self.formView.contentInset;
        UIEdgeInsets tableScrollIndicatorInsets = self.formView.scrollIndicatorInsets;
        tableContentInset.bottom = [_oldBottomTableContentInset floatValue];
        tableScrollIndicatorInsets.bottom = tableContentInset.bottom;
        _oldBottomTableContentInset = nil;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:[keyboardInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
        [UIView setAnimationCurve:[keyboardInfo[UIKeyboardAnimationCurveUserInfoKey] intValue]];
        self.formView.contentInset = tableContentInset;
        self.formView.scrollIndicatorInsets = tableScrollIndicatorInsets;
        [UIView commitAnimations];
    }
}

#pragma mark - Segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[XLFormRowDescriptor class]]){
        UIViewController * destinationViewController = segue.destinationViewController;
        XLFormRowDescriptor * rowDescriptor = (XLFormRowDescriptor *)sender;
        if (rowDescriptor.rowType == XLFormRowDescriptorTypeSelectorPush || rowDescriptor.rowType == XLFormRowDescriptorTypeSelectorPopover){
            NSAssert([destinationViewController conformsToProtocol:@protocol(XLFormRowDescriptorViewController)], @"Segue destinationViewController must conform to XLFormRowDescriptorViewController protocol");
            UIViewController<XLFormRowDescriptorViewController> * rowDescriptorViewController = (UIViewController<XLFormRowDescriptorViewController> *)destinationViewController;
            rowDescriptorViewController.rowDescriptor = rowDescriptor;
        }
        else if ([destinationViewController conformsToProtocol:@protocol(XLFormRowDescriptorViewController)]){
            UIViewController<XLFormRowDescriptorViewController> * rowDescriptorViewController = (UIViewController<XLFormRowDescriptorViewController> *)destinationViewController;
            rowDescriptorViewController.rowDescriptor = rowDescriptor;
        }
    }
}

#pragma mark - properties

-(void)setForm:(XLFormDescriptor *)form {
    _form.delegate = nil;
    [self.formView endEditing:YES];
    _form = form;
    _form.delegate = self;
    [_form forceEvaluate];
    if ([self isViewLoaded]){
        [self.formView reloadData];
    }
}

@end
