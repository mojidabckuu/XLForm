//
//  XLFormMapper.h
//  Pods
//
//  Created by vlad gorbenko on 10/27/15.
//
//

#import <Foundation/Foundation.h>

@class XLFormDescriptor;
@class XLFormViewController;

@interface XLFormMapper : NSObject

@property (nonatomic, assign, readonly) BOOL shouldUpdateValues;

@property (nonatomic, strong) XLFormDescriptor *form;
@property (nonatomic, weak) XLFormViewController *formViewController;

+ (instancetype)mapper;
+ (instancetype)mapperWithInstantUpdate;

- (void)setup;

- (void)updateValues;

@end
