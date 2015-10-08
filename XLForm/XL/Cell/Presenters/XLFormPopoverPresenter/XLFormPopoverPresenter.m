//
//  XLFormPopoverPresenter.m
//  Pods
//
//  Created by vlad gorbenko on 10/4/15.
//
//

#import "XLFormPopoverPresenter.h"

#import "XLFormRowDescriptor.h"

#import "XLFormRowDescriptorViewController.h"

@interface XLFormPopoverPresenter () <UIPopoverControllerDelegate>

@property (nonatomic, strong) UIPopoverController *popoverController;

@end

@implementation XLFormPopoverPresenter

- (void)presentWithCompletionBlock:(void (^)(void))completionBlock {
    NSAssert([self.destinationViewController conformsToProtocol:@protocol(XLFormRowDescriptorViewController)], @"rowDescriptor.action.viewControllerClass must conform to XLFormRowDescriptorViewController protocol");
    UIViewController<XLFormRowDescriptorViewController> *selectorViewController = (UIViewController<XLFormRowDescriptorViewController> *)self.destinationViewController;
    selectorViewController.rowDescriptor = self.rowDescriptor;
    selectorViewController.title = self.rowDescriptor.selectorTitle;
    
    if (self.popoverController && self.popoverController.popoverVisible) {
        [self.popoverController dismissPopoverAnimated:NO];
    }
    self.popoverController = [[UIPopoverController alloc] initWithContentViewController:selectorViewController];
    self.popoverController.delegate = self;
    if ([selectorViewController conformsToProtocol:@protocol(XLFormRowDescriptorPopoverViewController)]){
        ((id<XLFormRowDescriptorPopoverViewController>)selectorViewController).popoverController = self.popoverController;
    }
    UITableViewCell *cell = [self.rowDescriptor cell];
    // TODO: add realistion to attached Rect.
//        if (self.detailTextLabel.window){
//            [self.popoverController presentPopoverFromRect:CGRectMake(0, 0, self.detailTextLabel.frame.size.width, self.detailTextLabel.frame.size.height) inView:self.detailTextLabel permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
//        }
//        else{
    // TODO: add arrow direction
    [self.popoverController presentPopoverFromRect:cell.bounds inView:cell permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    //        }
    [self.sourceViewController.formView deselectItemAtIndexPath:[self.sourceViewController.formView indexPathForCell:cell] animated:YES];
}

#pragma mark - UIPopoverController delegate

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    [self.sourceViewController.formView reloadData];
}

@end
