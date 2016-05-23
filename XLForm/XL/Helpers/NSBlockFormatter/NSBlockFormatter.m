//
//  NSBlockFormatter.m
//  ALJ
//
//  Created by vlad gorbenko on 9/17/15.
//  Copyright (c) 2015 s4m. All rights reserved.
//

#import "NSBlockFormatter.h"

@interface NSBlockFormatter ()

@property (nonatomic, copy, readonly) NSBlockFormatterBlock forwardBlock;
@property (nonatomic, copy, readonly) NSBlockFormatterBlock reverseBlock;

@end

@implementation NSBlockFormatter

#pragma mark Lifecycle

+ (instancetype)formatterUsingForwardBlock:(NSBlockFormatterBlock)forwardBlock {
    return [[self alloc] initWithForwardBlock:forwardBlock reverseBlock:nil];
}

+ (instancetype)formatterUsingReversibleBlock:(NSBlockFormatterBlock)reversibleBlock {
    return [[self alloc] initWithForwardBlock:nil reverseBlock:reversibleBlock];
}

+ (instancetype)formatterUsingForwardBlock:(NSBlockFormatterBlock)forwardBlock reverseBlock:(NSBlockFormatterBlock)reverseBlock {
    return [[self alloc] initWithForwardBlock:forwardBlock reverseBlock:reverseBlock];
}

- (id)initWithForwardBlock:(NSBlockFormatterBlock)forwardBlock reverseBlock:(NSBlockFormatterBlock)reverseBlock {   
    self = [super init];
    if (self == nil) return nil;
    
    _forwardBlock = [forwardBlock copy];
    _reverseBlock = [reverseBlock copy];
    
    return self;
}

#pragma mark NSValueTransformer

+ (Class)transformedValueClass {
    return NSObject.class;
}

- (id)transformedValue:(id)value {
    NSError *error = nil;
    BOOL success = YES;
    
    return self.forwardBlock(value, &success, &error);
}

- (id)transformedValue:(id)value success:(BOOL *)outerSuccess error:(NSError **)outerError {
    NSError *error = nil;
    BOOL success = YES;
    
    id transformedValue = self.forwardBlock(value, &success, &error);
    
    if (outerSuccess != NULL) *outerSuccess = success;
    if (outerError != NULL) *outerError = error;
    
    return transformedValue;
}

- (NSString *)stringForObjectValue:(id)obj {
    return [self transformedValue:obj];
}

#pragma mark - 

- (BOOL)getObjectValue:(out id __nullable * __nullable)obj forString:(NSString *)string errorDescription:(out NSString * __nullable * __nullable)error {
    if(self.reverseBlock) {
        BOOL success = YES;
        NSError *outerError = nil;
        *obj = self.reverseBlock(string, &success, &outerError);
        if (error != NULL) *error = [outerError localizedDescription];
        return success;
    }
    return false;
}

@end
