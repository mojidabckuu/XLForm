//
//  VGCondition+Form.m
//  Pods
//
//  Created by Vlad Gorbenko on 7/2/16.
//
//

#import "VGCondition+Form.h"
#import <objc/runtime.h>

@implementation VGCondition (Form)

#pragma mark - Accessors

- (XLFormDescriptor *)form {
    return objc_getAssociatedObject(self, @selector(form));
}

#pragma mark - Modifiers

- (void)setForm:(XLFormDescriptor *)form {
    objc_setAssociatedObject(self, @selector(form), form, OBJC_ASSOCIATION_ASSIGN);
}

@end
