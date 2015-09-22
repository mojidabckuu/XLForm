//
//  XLFormOptionsObject+Init.h
//  ALJ
//
//  Created by vlad gorbenko on 9/3/15.
//  Copyright (c) 2015 s4m. All rights reserved.
//

#import "XLFormOptionsObject.h"

@interface XLFormOptionsObject (Init)

+ (NSArray *)optionsWithItems:(id<NSFastEnumeration>)items keyPath:(NSString *)keyPath formatter:(NSFormatter *)formatter;

@end
