//
//  NSFormatter+KeyPath.h
//  ALJ
//
//  Created by vlad gorbenko on 10/1/15.
//  Copyright © 2015 s4m. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFormatter (KeyPath)

+ (instancetype)formatterWithKeyPath:(NSString *)keyPath;

@end
