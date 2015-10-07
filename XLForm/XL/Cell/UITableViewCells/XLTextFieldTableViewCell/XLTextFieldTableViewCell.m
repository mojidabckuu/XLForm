//
//  XLTextField.m
//  ALJ
//
//  Created by vlad gorbenko on 9/2/15.
//  Copyright (c) 2015 s4m. All rights reserved.
//

#import "XLTextFieldTableViewCell.h"

#import "XLForm.h"

#import "XLTextBehavior.h"

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

#pragma mark - Responderer

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

#pragma mark - Accessors

- (XLTextBehavior *)behavior {
    return (XLTextBehavior *)self.rowDescriptor.behavior;
}

#pragma mark - UITextField delegate

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(textField.returnKeyType == UIReturnKeyDefault) {
        [textField resignFirstResponder];
    }
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *text = [self.textField.text stringByReplacingCharactersInRange:range withString:string];
    if([self.behavior instantMatching]) {
        if(self.behavior.regex) {
            NSPredicate *regex = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", self.behavior.regex];
            return [regex evaluateWithObject:text];
        } else {
            NSUInteger length = [textField.text length] - range.length + [string length];
            textField.text = [[textField.text stringByReplacingCharactersInRange:range withString:string] substringToIndex:self.behavior.length];
            return length <= self.behavior.length;
        }
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self.formViewController beginEditing:self.rowDescriptor];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self textFieldDidChange:textField];
    [self.formViewController endEditing:self.rowDescriptor];
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
