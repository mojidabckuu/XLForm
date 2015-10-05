//
//  XLFormPresenterProtocol.h
//  Pods
//
//  Created by vlad gorbenko on 10/4/15.
//
//

#import <Foundation/Foundation.h>

@class XLFormRowDescriptor;
@class XLFormViewController;

@protocol XLFormPresenterProtocol <NSObject>

@required

@property (nonatomic, strong) XLFormRowDescriptor *rowDescriptor;

@property (nonatomic, strong) XLFormViewController *sourceViewController;
@property (nonatomic, strong) UIViewController *destinationViewController;

- (void)presentWithCompletionBlock:(void (^ __nullable)(void))completionBlock;

@end
