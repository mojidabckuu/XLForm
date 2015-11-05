//
//  XLTextBehavior+PredefinedBehaviors.m
//  Pods
//
//  Created by vlad gorbenko on 10/6/15.
//
//

#import "XLTextBehavior+PredefinedBehaviors.h"

@implementation XLTextBehavior (PredefinedBehaviors)

+ (instancetype)defaultBehavior {
    XLTextBehavior *defaultBehavior = [[XLTextBehavior alloc] init];
    defaultBehavior.autocapitalizationType = UITextAutocapitalizationTypeWords;
    defaultBehavior.autocorrectionType = UITextAutocorrectionTypeDefault;
    defaultBehavior.spellCheckingType = UITextSpellCheckingTypeNo;
    defaultBehavior.keyboardType = UIKeyboardTypeDefault;
    defaultBehavior.keyboardAppearance = UIKeyboardAppearanceDefault;
    defaultBehavior.enablesReturnKeyAutomatically = YES;
    defaultBehavior.returnKeyType = UIReturnKeyDefault;
    defaultBehavior.secureTextEntry = NO;
    return defaultBehavior;
}

+ (instancetype)emailBehavior {
    XLTextBehavior *emailBehavior = [[XLTextBehavior alloc] init];
    emailBehavior.autocapitalizationType = UITextAutocapitalizationTypeNone;
    emailBehavior.autocorrectionType = UITextAutocorrectionTypeNo;
    emailBehavior.spellCheckingType = UITextSpellCheckingTypeNo;
    emailBehavior.returnKeyType = UIReturnKeyDefault;
    emailBehavior.keyboardType = UIKeyboardTypeEmailAddress;
    emailBehavior.secureTextEntry = NO;
    emailBehavior.length = 30;
    return emailBehavior;
}

+ (instancetype)passwordBehavior {
    XLTextBehavior *passwordBehavior = [[XLTextBehavior alloc] init];
    passwordBehavior.length = 20;
    passwordBehavior.secureTextEntry = YES;
    passwordBehavior.returnKeyType = UIReturnKeyDone;
    return passwordBehavior;
}

@end
