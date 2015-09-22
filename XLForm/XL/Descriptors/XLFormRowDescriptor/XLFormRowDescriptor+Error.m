//
//  XLFormRowDescriptor+Error.m
//  ALJ
//
//  Created by vlad gorbenko on 8/31/15.
//  Copyright (c) 2015 s4m. All rights reserved.
//

#import "XLFormRowDescriptor+Error.h"

#import <objc/runtime.h>

@implementation XLFormRowDescriptor (Error)

#pragma mark - Accessors

- (NSError *)error {
    return objc_getAssociatedObject(self, @selector(error));
}

#pragma mark - Modifiers

- (void)setError:(NSError *)error {
    objc_setAssociatedObject(self, @selector(error), error, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
