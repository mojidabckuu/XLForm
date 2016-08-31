//
//  VGConditionConfirm.h
//  Pods
//
//  Created by Vlad Gorbenko on 7/2/16.
//
//

#import <VGCondition/VGCondition.h>

@interface VGConditionConfirm : VGCondition

@property (nonatomic, nonnull, strong, readonly) NSString *tag;

+ (nonnull instancetype)conditionWithTag:(nonnull NSString *)tag;
+ (nonnull instancetype)conditionWithTag:(nonnull NSString *)tag description:(nonnull NSString *)description;

- (nonnull instancetype)initWithTag:(nonnull NSString *)tag;
- (nonnull instancetype)initWithTag:(nonnull NSString *)tag description:(nonnull NSString *)description;

@end
