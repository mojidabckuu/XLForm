//
//  XLFormAlertViewPresenter.m
//  Pods
//
//  Created by vlad gorbenko on 10/4/15.
//
//

#import "XLFormAlertViewPresenter.h"

#import "XLFormRowDescriptor.h"

#import "XLFormOptionsObject.h"

#import "NSObject+XLFormAdditions.h"

@interface XLFormAlertViewPresenter () <UIAlertViewDelegate>

@end

@implementation XLFormAlertViewPresenter

- (void)presentWithCompletionBlock:(void (^)(void))completionBlock {
#if __IPHONE_OS_VERSION_MAX_ALLOWED < 80000
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:self.rowDescriptor.selectorTitle message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
    for (id option in self.rowDescriptor.selectorOptions) {
        [alertView addButtonWithTitle:[option displayText]];
    }
    alertView.cancelButtonIndex = [alertView addButtonWithTitle:NSLocalizedString(@"Cancel", nil)];
    alertView.tag = [self.rowDescriptor hash];
    self.alertView = alertView;
    [alertView show];
#else
    if ([UIAlertController class]) {
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:self.rowDescriptor.selectorTitle message:nil preferredStyle:UIAlertControllerStyleAlert];
        __weak __typeof(self)weakSelf = self;
        for (id option in self.rowDescriptor.selectorOptions) {
            UIAlertAction *action = [UIAlertAction actionWithTitle:[option displayText] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [weakSelf.rowDescriptor setValue:option];
                [weakSelf.sourceViewController.tableView reloadData];
            }];
            [alertController addAction:action];
        }
        [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:nil]];
        [self.sourceViewController presentViewController:alertController animated:YES completion:nil];
    }
    else{
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:self.rowDescriptor.selectorTitle message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
        for (id option in self.rowDescriptor.selectorOptions) {
            [alertView addButtonWithTitle:[option displayText]];
        }
        alertView.cancelButtonIndex = [alertView addButtonWithTitle:NSLocalizedString(@"Cancel", nil)];
        alertView.tag = [self.rowDescriptor hash];
        [alertView show];
    }
#endif
}

#pragma mark - UIAlertView delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(alertView.cancelButtonIndex != buttonIndex) {
        NSString * title = [alertView buttonTitleAtIndex:buttonIndex];
        for (id option in self.rowDescriptor.selectorOptions){
            if ([[option displayText] isEqualToString:title]){
                [self.rowDescriptor setValue:option];
                [self.sourceViewController.tableView reloadData];
                break;
            }
        }
    }
}

@end
