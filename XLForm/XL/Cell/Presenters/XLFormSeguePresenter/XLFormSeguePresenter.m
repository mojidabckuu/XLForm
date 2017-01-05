//
//  XLFormSeguePresenter.m
//  Pods
//
//  Created by vlad gorbenko on 10/5/15.
//
//

#import "XLFormSeguePresenter.h"

#import "XLFormRowDescriptor.h"

#import "XLFormRowDescriptorViewController.h"

@implementation XLFormSeguePresenter

- (void)presentWithCompletionBlock:(void (^)(void))completionBlock {
    if (self.rowDescriptor.action.formSegueIdenfifier) {
        [self.sourceViewController performSegueWithIdentifier:self.rowDescriptor.action.formSegueIdenfifier sender:self.rowDescriptor];
    }
    else if (self.rowDescriptor.action.formSegueClass){
        NSAssert(self.sourceViewController, @"either rowDescriptor.action.viewControllerClass or rowDescriptor.action.viewControllerStoryboardId or rowDescriptor.action.viewControllerNibName must be assigned");
        NSAssert([self.sourceViewController conformsToProtocol:@protocol(XLFormRowDescriptorViewController)], @"selector view controller must conform to XLFormRowDescriptorViewController protocol");
        UIStoryboardSegue * segue = [[self.rowDescriptor.action.formSegueClass alloc] initWithIdentifier:self.rowDescriptor.tag source:self.sourceViewController destination:self.sourceViewController];
        [self.sourceViewController prepareForSegue:segue sender:self.rowDescriptor];
        [segue perform];
    }
}

@end
