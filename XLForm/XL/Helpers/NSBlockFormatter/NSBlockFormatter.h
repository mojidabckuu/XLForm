//
//  NSBlockFormatter.h
//  ALJ
//
//  Created by vlad gorbenko on 9/17/15.
//  Copyright (c) 2015 s4m. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef __nullable id (^NSBlockFormatterBlock)(id _Nullable value, BOOL * _Nonnull success, NSError * _Nullable * _Nullable error);

@interface NSBlockFormatter : NSFormatter

+ (nonnull instancetype)formatterUsingForwardBlock:(nonnull NSBlockFormatterBlock)formatting;

+ (nonnull instancetype)formatterUsingReversibleBlock:(nonnull NSBlockFormatterBlock)formatting;

+ (nonnull instancetype)formatterUsingForwardBlock:(nonnull NSBlockFormatterBlock)forwardFormatting reverseBlock:(nonnull NSBlockFormatterBlock)reverseFormatting;


@end
