//
//  XLTextField.m
//  ALJ
//
//  Created by vlad gorbenko on 9/2/15.
//  Copyright (c) 2015 s4m. All rights reserved.
//

#import "XLTextFieldTableViewCell.h"

#import "XLForm.h"

@interface XLTextFieldTableViewCell () <UITextFieldDelegate>

@end

@implementation XLTextFieldTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.textField.delegate = self;
}

- (void)update {
    [super update];
    id value = self.rowDescriptor.value;
    NSString *text = self.rowDescriptor.formatter ? [self.rowDescriptor.formatter stringForObjectValue:value] : value;
    self.textField.text = text;
    self.textField.placeholder = self.rowDescriptor.placeholder;
    self.titleLabel.text = self.rowDescriptor.title;
    self.subtitleLabel.text = self.rowDescriptor.subtitle;
    self.textField.enabled = self.rowDescriptor.selectionStyle == XLFormRowSelectionStyleUndefined;
}

- (BOOL)becomeFirstResponder {
    if(self.rowDescriptor.selectionStyle == XLFormRowSelectionStyleUndefined) {
        return [self.textField becomeFirstResponder];
    }
    return [super becomeFirstResponder];
}

- (BOOL)resignFirstResponder {
    if(self.rowDescriptor.selectionStyle == XLFormRowSelectionStyleUndefined) {
        return [self.textField resignFirstResponder];
    }
    return [super resignFirstResponder];
}

#pragma mark - 

- (BOOL)formDescriptorCellCanBecomeFirstResponder {
    if(self.rowDescriptor.selectionStyle == XLFormRowSelectionStyleUndefined) {
        return !self.rowDescriptor.isDisabled;
    }
    return [super formDescriptorCellCanBecomeFirstResponder];
}

- (BOOL)formDescriptorCellBecomeFirstResponder {
    if(self.rowDescriptor.selectionStyle == XLFormRowSelectionStyleUndefined) {
        return [self.textField becomeFirstResponder];
    }
    return [super formDescriptorCellBecomeFirstResponder];
}

#pragma mark - UITextField delegate

//- (BOOL)textFieldShouldClear:(UITextField *)textField
//{
//    return [self.formViewController textFieldShouldClear:textField];
//}
//
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(textField.returnKeyType == UIReturnKeyDefault) {
        [textField resignFirstResponder];
    }
    return YES;
}
//
//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
//{
//    return [self.formViewController textFieldShouldBeginEditing:textField];
//}
//
//- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
//{
//    return [self.formViewController textFieldShouldEndEditing:textField];
//}
//
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//    return [self.formViewController textField:textField shouldChangeCharactersInRange:range replacementString:string];
//}
//
//- (void)textFieldDidBeginEditing:(UITextField *)textField
//{
//    [self.formViewController beginEditing:self.rowDescriptor];
//    [self.formViewController textFieldDidBeginEditing:textField];
//}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self textFieldDidChange:textField];
//    [self.formViewController endEditing:self.rowDescriptor];
//    [self.formViewController textFieldDidEndEditing:textField];
}

#pragma mark - Utils

- (void)textFieldDidChange:(UITextField *)textField{
    if([self.textField.text length] > 0) { // TODO: use formatters to convert to expected value
        if ([self.rowDescriptor.rowType isEqualToString:XLFormRowDescriptorTypeNumber] || [self.rowDescriptor.rowType isEqualToString:XLFormRowDescriptorTypeDecimal]){
            self.rowDescriptor.value =  @([self.textField.text doubleValue]);
        } else if ([self.rowDescriptor.rowType isEqualToString:XLFormRowDescriptorTypeInteger]){
            self.rowDescriptor.value = @([self.textField.text integerValue]);
        } else {
            self.rowDescriptor.value = self.textField.text;
        }
    } else {
        self.rowDescriptor.value = nil;
    }
}

@end
