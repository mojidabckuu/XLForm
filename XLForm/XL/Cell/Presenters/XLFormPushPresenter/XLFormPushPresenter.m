//
//  XLFormPushPresenter.m
//  Pods
//
//  Created by vlad gorbenko on 10/4/15.
//
//

#import "XLFormPushPresenter.h"

#import "XLFormRowDescriptor.h"

#import "XLFormRowDescriptorViewController.h"

@implementation XLFormPushPresenter

- (void)presentWithCompletionBlock:(void (^)(void))completionBlock {
    NSAssert([self.destinationViewController conformsToProtocol:@protocol(XLFormRowDescriptorViewController)], @"rowDescriptor.action.viewControllerClass must conform to XLFormRowDescriptorViewController protocol");
    UIViewController<XLFormRowDescriptorViewController> *selectorViewController = (UIViewController<XLFormRowDescriptorViewController> *)self.destinationViewController;
    selectorViewController.rowDescriptor = self.rowDescriptor;
    selectorViewController.title = self.rowDescriptor.selectorTitle;
    [self.sourceViewController.navigationController pushViewController:selectorViewController animated:YES];
}

@end
