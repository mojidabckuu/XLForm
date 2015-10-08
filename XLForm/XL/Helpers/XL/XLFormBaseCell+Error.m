//
//  XLFormBaseCell+Error.m
//  ALJ
//
//  Created by vlad gorbenko on 8/31/15.
//  Copyright (c) 2015 s4m. All rights reserved.
//

#import "XLFormBaseCell+Error.h"

#import <objc/runtime.h>

@implementation XLFormBaseCell (Error)

#pragma mark - Accessors

- (UIView<XLErrorProtocol> *)errorView {
    return objc_getAssociatedObject(self, @selector(errorView));
}

#pragma mark - Modifiers

- (void)setErrorView:(UIView<XLErrorProtocol> *)errorView {
    objc_setAssociatedObject(self, @selector(errorView), errorView, OBJC_ASSOCIATION_ASSIGN);
}

- (void)update {
    self.textLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    self.detailTextLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    self.textLabel.textColor  = self.rowDescriptor.disabled ? [UIColor grayColor] : [UIColor blackColor];
    [self updateError];
}

- (void)updateError {
    [self.errorView setError:self.rowDescriptor.error];
}

@end
