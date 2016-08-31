//
//  NSObject+Empty.m
//  Pods
//
//  Created by Vlad Gorbenko on 7/2/16.
//
//

#import "NSObject+Empty.h"

@implementation NSObject(Empty)

- (BOOL)XLisEmpty {
    return false;
}

@end

@implementation NSArray(Empty)

- (BOOL)XLisEmpty {
    return self.count == 0;
}

@end

@implementation NSDictionary(Empty)

- (BOOL)XLisEmpty {
    return self.count == 0;
}

@end

@implementation NSString(Empty)

- (BOOL)XLisEmpty {
    return self.length == 0;
}

@end