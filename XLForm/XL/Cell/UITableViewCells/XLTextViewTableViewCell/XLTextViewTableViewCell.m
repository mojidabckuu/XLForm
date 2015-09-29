//
//  XLTextViewTableViewCell.m
//  Pods
//
//  Created by vlad gorbenko on 9/29/15.
//
//

#import "XLTextViewTableViewCell.h"

#import "XLForm.h"

#import "UIView+XLFormAdditions.h"

#import <UITextView+Placeholder/UITextView+Placeholder.h>

@interface XLTextViewTableViewCell () <UITextViewDelegate>

@end

@implementation XLTextViewTableViewCell

#pragma mark - Lifecycle

- (void)awakeFromNib {
    [super awakeFromNib];
    self.textView.delegate = self;
}

#pragma mark - UIResponderer

- (BOOL)becomeFirstResponder {
    return [self.textView becomeFirstResponder];
}

- (BOOL)resignFirstResponder {
    return [self.textView resignFirstResponder];
}

#pragma mark - 

- (void)update {
    [super update];
    id value = self.rowDescriptor.value;
    NSString *text = self.rowDescriptor.formatter ? [self.rowDescriptor.formatter stringForObjectValue:value] : value;
    self.textView.text = text;
    self.textView.placeholder = self.rowDescriptor.placeholder;
    self.titleLabel.text = self.rowDescriptor.title;
    self.textView.editable = !self.rowDescriptor.isDisabled;
    // TODO: make colors configurable
    self.textView.textColor  = self.rowDescriptor.isDisabled ? [UIColor grayColor] : [UIColor blackColor];
}

#pragma mark -

- (BOOL)formDescriptorCellCanBecomeFirstResponder {
    return YES;
}

- (BOOL)formDescriptorCellBecomeFirstResponder {
    return [self.textView becomeFirstResponder];
}

#pragma mark - Accessors

//- (UITextView *)textView {
//    if(!_textView) {
//        _textView = [XLFormTextView autolayoutView];
//    }
//    return _textView;
//}
//
//- (UILabel *)titleLabel {
//    if(!_titleLabel) {
//        _titleLabel = [UILabel autolayoutView];
//        [_titleLabel setContentHuggingPriority:500 forAxis:UILayoutConstraintAxisHorizontal];
//    }
//    return _titleLabel;
//}

#pragma mark - UITextView delegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    // TODO: use rowDescriptor text behavior input definition
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    [self textViewDidChange];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    [self textViewDidChange];
}

#pragma mark - User interaction

- (void)textViewDidChange {
    if([self.textView.text length] > 0) { // TODO: use formatters to convert to expected value
        if ([self.rowDescriptor.rowType isEqualToString:XLFormRowDescriptorTypeNumber] || [self.rowDescriptor.rowType isEqualToString:XLFormRowDescriptorTypeDecimal]){
            self.rowDescriptor.value =  @([self.textView.text doubleValue]);
        } else if ([self.rowDescriptor.rowType isEqualToString:XLFormRowDescriptorTypeInteger]){
            self.rowDescriptor.value = @([self.textView.text integerValue]);
        } else {
            self.rowDescriptor.value = self.textView.text;
        }
    } else {
        self.rowDescriptor.value = nil;
    }
}

@end
