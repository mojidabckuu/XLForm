//
//  XLFormRowDescriptor+Addons.m
//  ALJ
//
//  Created by vlad gorbenko on 9/1/15.
//  Copyright (c) 2015 s4m. All rights reserved.
//

#import "XLFormRowDescriptor+Addons.h"

#import <objc/runtime.h>

@implementation XLFormRowDescriptor (Addons)

#pragma mark - Accessors

- (NSNumber *)height {
    return objc_getAssociatedObject(self, @selector(height));
}

- (NSString *)subtitle {
    return objc_getAssociatedObject(self, @selector(subtitle));
}

- (NSString *)placeholder {
    return objc_getAssociatedObject(self, @selector(placeholder));
}

- (XLFormRowSelectionStyle)selectionStyle {
    return [objc_getAssociatedObject(self, @selector(selectionStyle)) integerValue];
}

- (XLFormRowSelectionType)selectionType {
    return [objc_getAssociatedObject(self, @selector(selectionType)) integerValue];
}

- (BOOL)mutlipleSelection {
    return [objc_getAssociatedObject(self, @selector(mutlipleSelection)) boolValue];
}

- (NSFormatter *)formatter {
    return objc_getAssociatedObject(self, @selector(formatter));
}

#pragma mark - Modifiers

- (void)setHeight:(NSNumber *)height {
    objc_setAssociatedObject(self, @selector(height), height, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setSubtitle:(NSString *)subtitle {
    objc_setAssociatedObject(self, @selector(subtitle), subtitle, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setPlaceholder:(NSString *)placeholder {
    objc_setAssociatedObject(self, @selector(placeholder), placeholder, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setSelectionStyle:(XLFormRowSelectionStyle)selectionStyle {
    objc_setAssociatedObject(self, @selector(selectionStyle), @(selectionStyle), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setSelectionType:(XLFormRowSelectionType)selectionType {
    objc_setAssociatedObject(self, @selector(selectionType), @(selectionType), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setMutlipleSelection:(BOOL)mutlipleSelection {
    objc_setAssociatedObject(self, @selector(mutlipleSelection), @(mutlipleSelection), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setFormatter:(NSFormatter *)formatter {
    objc_setAssociatedObject(self, @selector(formatter), formatter, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
