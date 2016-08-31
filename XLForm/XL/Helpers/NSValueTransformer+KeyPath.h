//
//  NSValueTransformer+KeyPath.h
//  Pods
//
//  Created by Vladislav Gorbenlo on 19/08/16.
//
//

#import <Foundation/Foundation.h>

@interface NSValueTransformer (KeyPath)

+ (instancetype)transformerWithKeyPath:(NSString *)keyPath;

@end