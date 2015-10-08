//
//  XLFormAction.h
//  Pods
//
//  Created by vlad gorbenko on 10/8/15.
//
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, XLFormPresentationMode) {
    XLFormPresentationModeDefault = 0,
    XLFormPresentationModePush,
    XLFormPresentationModePresent
};

@class XLFormRowDescriptor;

@interface XLFormAction : NSObject

@property (nullable, nonatomic, strong) Class viewControllerClass;
@property (nullable, nonatomic, strong) NSString * viewControllerStoryboardId;
@property (nullable, nonatomic, strong) NSString * viewControllerNibName;

@property (nonatomic) XLFormPresentationMode viewControllerPresentationMode;

@property (nullable, nonatomic, strong) void (^formBlock)(XLFormRowDescriptor * __nonnull sender);
@property (nullable, nonatomic) SEL formSelector;
@property (nullable, nonatomic, strong) NSString * formSegueIdenfifier;
@property (nullable, nonatomic, strong) Class formSegueClass;

@end