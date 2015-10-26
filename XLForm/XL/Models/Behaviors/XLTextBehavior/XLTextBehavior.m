//
//  XLTextBehavior.m
//  Pods
//
//  Created by vlad gorbenko on 9/22/15.
//
//

#import "XLTextBehavior.h"

@implementation XLTextBehavior

@synthesize autocapitalizationType = _autocapitalizationType;
@synthesize autocorrectionType = _autocorrectionType;
@synthesize spellCheckingType = _spellCheckingType;
@synthesize keyboardType = _keyboardType;
@synthesize keyboardAppearance = _keyboardAppearance;
@synthesize returnKeyType = _returnKeyType;
@synthesize enablesReturnKeyAutomatically = _enablesReturnKeyAutomatically;
@synthesize secureTextEntry = _secureTextEntry;

#pragma mark - Lifecycle

- (instancetype)init {
    self = [super init];
    if(self) {
        self.instantMatching = YES;
        self.length = 20;
        self.instantReturn = YES;
    }
    return self;
}

@end
