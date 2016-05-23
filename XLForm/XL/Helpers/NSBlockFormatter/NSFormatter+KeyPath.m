//
//  NSFormatter+KeyPath.m
//  ALJ
//
//  Created by vlad gorbenko on 10/1/15.
//  Copyright © 2015 s4m. All rights reserved.
//

#import "NSFormatter+KeyPath.h"

#import "NSBlockFormatter.h"

@implementation NSFormatter (KeyPath)

+ (instancetype)formatterWithKeyPath:(NSString *)keyPath {
    return [NSBlockFormatter formatterUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        return [value valueForKeyPath:keyPath];
    } reverseBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        return value;
    }];
}

@end
