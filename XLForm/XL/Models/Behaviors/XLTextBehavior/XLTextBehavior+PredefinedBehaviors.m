//
//  XLTextBehavior+PredefinedBehaviors.m
//  Pods
//
//  Created by vlad gorbenko on 10/6/15.
//
//

#import "XLTextBehavior+PredefinedBehaviors.h"

@implementation XLTextBehavior (PredefinedBehaviors)

+ (instancetype)emailBehavior {
    XLTextBehavior *emailBehavior = [[XLTextBehavior alloc] init];
    emailBehavior.autocapitalizationType = UITextAutocapitalizationTypeNone;
    emailBehavior.autocorrectionType = UITextAutocorrectionTypeNo;
    emailBehavior.spellCheckingType = UITextSpellCheckingTypeNo;
    emailBehavior.returnKeyType = UIReturnKeyDefault;
    emailBehavior.secureTextEntry = NO;
    emailBehavior.length = 30;
    return emailBehavior;
}

+ (instancetype)passwordBehavior {
    XLTextBehavior *passwordBehavior = [[XLTextBehavior alloc] init];
    passwordBehavior.length = 20;
    return passwordBehavior;
}

@end
