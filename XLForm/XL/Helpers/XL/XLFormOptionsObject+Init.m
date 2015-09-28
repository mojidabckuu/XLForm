//
//  XLFormOptionsObject+Init.m
//  ALJ
//
//  Created by vlad gorbenko on 9/3/15.
//  Copyright (c) 2015 s4m. All rights reserved.
//

#import "XLFormOptionsObject+Init.h"

@implementation XLFormOptionsObject (Init)

+ (NSArray *)optionsWithItems:(id<NSFastEnumeration>)items keyPath:(NSString *)keyPath formatter:(NSFormatter *)formatter {
    id sourceItems = items;
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:keyPath ascending:YES];
    NSArray *source = [sourceItems isKindOfClass:NSArray.class] ? sourceItems : [sourceItems allObjects];
    if(keyPath) {
        source = [source sortedArrayUsingDescriptors:@[sortDescriptor]];
    }
    NSMutableArray *options = [NSMutableArray array];
    for(id item in source) {
        id value = keyPath ? [item valueForKeyPath:keyPath] : item;
        id dispayText = formatter ? [formatter stringForObjectValue:value] : value;
        XLFormOptionsObject *option = [XLFormOptionsObject formOptionsObjectWithValue:item displayText:dispayText];
        [options addObject:option];
    }
    return options;
}

+ (NSArray *)optionsWithItems:(id<NSFastEnumeration>)items formatter:(NSFormatter *)formatter sortedBy:(NSString *)sortedBy {
    id sourceItems = items;
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:sortedBy ascending:YES];
    NSArray *source = [sourceItems isKindOfClass:NSArray.class] ? sourceItems : [sourceItems allObjects];
    if(sortedBy) {
        source = [source sortedArrayUsingDescriptors:@[sortDescriptor]];
    }
    NSMutableArray *options = [NSMutableArray array];
    for(id item in source) {
        id value = item;
        id dispayText = formatter ? [formatter stringForObjectValue:value] : value;
        XLFormOptionsObject *option = [XLFormOptionsObject formOptionsObjectWithValue:item displayText:dispayText];
        [options addObject:option];
    }
    return options;
}

@end
