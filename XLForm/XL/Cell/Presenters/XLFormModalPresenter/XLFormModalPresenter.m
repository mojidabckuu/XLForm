//
//  XLFormModalPresenter.m
//  Pods
//
//  Created by vlad gorbenko on 10/4/15.
//
//

#import "XLFormModalPresenter.h"

#import "XLFormRowDescriptor.h"

#import "XLFormRowDescriptorViewController.h"

@implementation XLFormModalPresenter

- (void)presentWithCompletionBlock:(void (^)(void))completionBlock {
    NSAssert([self.destinationViewController conformsToProtocol:@protocol(XLFormRowDescriptorViewController)], @"rowDescriptor.action.viewControllerClass must conform to XLFormRowDescriptorViewController protocol");
    UIViewController<XLFormRowDescriptorViewController> *selectorViewController = (UIViewController<XLFormRowDescriptorViewController> *)self.destinationViewController;
    selectorViewController.rowDescriptor = self.rowDescriptor;
    selectorViewController.title = self.rowDescriptor.selectorTitle;
    
    id controller = selectorViewController;
    if(![self.destinationViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:selectorViewController];
        UIBarButtonItem *doneBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", nil) style:UIBarButtonItemStyleDone target:self action:@selector(dismiss:)];
        selectorViewController.navigationItem.rightBarButtonItem = doneBarButtonItem;
        controller = navigationController;
    }
    
    [self.sourceViewController.navigationController pushViewController:controller animated:YES];
}

#pragma mark - User interaction

- (void)dismiss:(id)sender {
    [self.destinationViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
