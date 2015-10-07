//
//  XLFormContentFactory.h
//  Pods
//
//  Created by vlad gorbenko on 10/7/15.
//
//

#import <Foundation/Foundation.h>

@class XLFormContent;

@interface XLFormContentFactory : NSObject

+ (XLFormContent *)formContentWithView:(UIView *)view;

+ (BOOL)registerContentClass:(Class)class forViewClass:(Class)viewClass;

@end
