//
//  XLFormTextInputDelegate.h
//  Pods
//
//  Created by vlad gorbenko on 10/6/15.
//
//

#import <Foundation/Foundation.h>

@class XLFormRowDescriptor;

@protocol XLFormTextInputDelegate <NSObject>

@required
- (BOOL)textInputShouldClear:(id<UITextInput>)inputView formRow:(XLFormRowDescriptor *)formRow;
- (BOOL)textInputShouldBeginEditing:(id<UITextInput>)inputView formRow:(XLFormRowDescriptor *)formRow;
- (BOOL)textInputShouldEndEditing:(id<UITextInput>)inputView formRow:(XLFormRowDescriptor *)formRow;

- (void)textInputViewDidBeginEditing:(id<UITextInput>)inputView formRow:(XLFormRowDescriptor *)formRow;
- (void)textInputViewDidEndEditing:(id<UITextInput>)inputView formRow:(XLFormRowDescriptor *)formRow;

- (BOOL)textInputViewShouldReturn:(id<UITextInput>)inputView formRow:(XLFormRowDescriptor *)formRow;

- (BOOL)textInputView:(id<UITextInput>)inputView shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string formRow:(XLFormRowDescriptor *)formRow;

- (void)textInputDidChange:(id<UITextInput>)inputView formRow:(XLFormRowDescriptor *)formRow;

@end