//
//  XLTextBehavior+PredefinedBehaviors.h
//  Pods
//
//  Created by vlad gorbenko on 10/6/15.
//
//

#import "XLTextBehavior.h"

@interface XLTextBehavior (PredefinedBehaviors)

+ (instancetype)defaultBehavior;

+ (instancetype)emailBehavior;
+ (instancetype)passwordBehavior;

@end
