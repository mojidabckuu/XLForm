//
//  NSValueTransformer+KeyPath.m
//  Pods
//
//  Created by Vladislav Gorbenlo on 19/08/16.
//
//

#import "NSValueTransformer+KeyPath.h"
#import "NSBlockFormatter.h"

@implementation NSValueTransformer (KeyPath)

+ (instancetype)formatterWithKeyPath:(NSString *)keyPath {
    return [NSBlockValueTransformer transformerUsingForwardBlock:^id(id value) {
        return [value valueForKeyPath:keyPath];
    } reverseBlock:^id(id value) {
        return value;
    }];
}

@end