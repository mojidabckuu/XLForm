//
//  XLFormContentFactory.m
//  Pods
//
//  Created by vlad gorbenko on 10/7/15.
//
//

#import "XLFormContentFactory.h"

#import "XLFormTableViewContent.h"
#import "XLFormCollectionViewContent.h"

@implementation XLFormContentFactory

#pragma mark - Lifecycle

+ (void)load {
    [self registerContentClass:[XLFormTableViewContent class] forViewClass:[UITableView class]];
    [self registerContentClass:[XLFormCollectionViewContent class] forViewClass:[UICollectionView class]];
}

#pragma mark - Accessors

+ (NSMutableDictionary *)viewClasses {
    static dispatch_once_t onceToken;
    static NSMutableDictionary *mutableDictionary = nil;
    dispatch_once(&onceToken, ^{
        mutableDictionary = [[NSMutableDictionary alloc] init];
    });
    return mutableDictionary;
}

#pragma mark - Factory methods

+ (XLFormContent *)formContentWithView:(UIView *)view {
    XLFormContent * content = [[[[self viewClasses] objectForKey:NSStringFromClass([view class])] alloc] init];
    content.formView = view;
    return content;
}

#pragma mark - Utils

+ (BOOL)registerContentClass:(Class)class forViewClass:(Class)viewClass {
    [[self viewClasses] setObject:class forKey:NSStringFromClass(viewClass)];
    return TRUE;
}

@end
