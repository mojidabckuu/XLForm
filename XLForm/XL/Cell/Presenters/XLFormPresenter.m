//
//  XLFormPresenter.m
//  Pods
//
//  Created by vlad gorbenko on 10/4/15.
//
//

#import "XLFormPresenter.h"

#import "XLFormRowDescriptor.h"

@implementation XLFormPresenter

@synthesize rowDescriptor = _rowDescriptor;
@synthesize destinationViewController = _destinationViewController;
@synthesize sourceViewController = _sourceViewController;

#pragma mark - Present management

- (void)presentWithCompletionBlock:(void (^)(void))completionBlock {
    @throw [NSException exceptionWithName:@"XLFormPresenterNotImplementedException" reason:@"Method presentWithCompletionBlock: is not implemented" userInfo:nil];
}

#pragma mark - Accessors

- (UIViewController *)destinationViewController {
    if(!_destinationViewController) {
        _destinationViewController = [self controllerToPresent];
    }
    return _destinationViewController;
}

#pragma mark - Utils

- (UIViewController *)controllerToPresent {
    if (self.rowDescriptor.action.viewControllerClass) {
        return [[self.rowDescriptor.action.viewControllerClass alloc] init];
    }
    else if ([self.rowDescriptor.action.viewControllerStoryboardId length] != 0 ){
        UIStoryboard * storyboard = self.sourceViewController.storyboard;
        NSAssert(storyboard != nil, @"You must provide a storyboard when rowDescriptor.action.viewControllerStoryboardId is used");
        return [storyboard instantiateViewControllerWithIdentifier:self.rowDescriptor.action.viewControllerStoryboardId];
    }
    else if ([self.rowDescriptor.action.viewControllerNibName length] != 0) {
        Class viewControllerClass = NSClassFromString(self.rowDescriptor.action.viewControllerNibName);
        NSAssert(viewControllerClass, @"class owner of self.rowDescriptor.action.viewControllerNibName must be equal to %@", self.rowDescriptor.action.viewControllerNibName);
        return [[viewControllerClass alloc] initWithNibName:self.rowDescriptor.action.viewControllerNibName bundle:nil];
    }
    return nil;
}

@end
