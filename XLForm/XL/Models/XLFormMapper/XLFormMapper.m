//
//  XLFormMapper.m
//  Pods
//
//  Created by vlad gorbenko on 10/27/15.
//
//

#import "XLFormMapper.h"

#import "XLFormViewController.h"

@implementation XLFormMapper

#pragma mark - Lifecycle

- (instancetype)init {
    self = [super init];
    if(self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithInstantUpdate {
    self = [super init];
    if(self) {
        _shouldUpdateValues = YES;
        [self setup];
    }
    return self;
}

+ (instancetype)mapper {
    return [[self alloc] init];
}

+ (instancetype)mapperWithInstantUpdate {
    return [[self alloc] initWithInstantUpdate];
}

#pragma mark - Setup

- (void)setup {
}

#pragma mark - Values

- (void)updateValues {
    if(self.shouldUpdateValues) {
        for(XLFormSectionDescriptor *section in self.form.formSections) {
            for(XLFormRowDescriptor *row in section.formRows) {
                if([self.formViewController.model respondsToSelector:NSSelectorFromString(row.tag)]) {
                    row.value = [self.formViewController.model valueForKey:row.tag];
                }
            }
        }
    }
}

@end
