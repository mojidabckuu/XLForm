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

#import "XLFormContent.h"

@interface XLTextFieldTableViewCell () <UITextFieldDelegate>

@end

@implementation XLTextFieldTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.textField.delegate = self;
    [self.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
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
    [self updateBehavior];
}

#pragma mark - Setup

- (void)updateBehavior {
    XLTextBehavior *behavior = [self behavior];
    self.textField.autocorrectionType = behavior.autocorrectionType;
    self.textField.autocapitalizationType = behavior.autocapitalizationType;
    self.textField.secureTextEntry = behavior.isSecureTextEntry;
    self.textField.spellCheckingType = behavior.spellCheckingType;
    self.textField.returnKeyType = behavior.returnKeyType;
    self.textField.keyboardType = behavior.keyboardType;
    self.textField.keyboardAppearance = behavior.keyboardAppearance;
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
    if(!self.rowDescriptor.behavior) {
        self.rowDescriptor.behavior = [[XLTextBehavior alloc] init];
    }
    return (XLTextBehavior *)self.rowDescriptor.behavior;
}

#pragma mark - UITextField delegate

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    return [self.formViewController.formContent textInputShouldClear:textField formRow:self.rowDescriptor];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    BOOL shouldReturn = [self.formViewController.formContent textInputViewShouldReturn:textField formRow:self.rowDescriptor];
    if(shouldReturn) {
        [self resignFirstResponder];
    }
    return shouldReturn;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return [self.formViewController.formContent textInputShouldBeginEditing:textField formRow:self.rowDescriptor];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    return [self.formViewController.formContent textInputShouldEndEditing:textField formRow:self.rowDescriptor];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return [self.formViewController.formContent textInputView:textField shouldChangeCharactersInRange:range replacementString:string formRow:self.rowDescriptor];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self.formViewController beginEditing:self.rowDescriptor];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self.formViewController.formContent textInputViewDidEndEditing:textField formRow:self.rowDescriptor];
    [self textFieldDidChange:textField];
    [self.formViewController endEditing:self.rowDescriptor];
}

#pragma mark - Utils

- (void)textFieldDidChange:(UITextField *)textField{
    [self.formViewController.formContent textInputDidChange:textField formRow:self.rowDescriptor];
}

@end
