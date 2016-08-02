//
//  XLFormAlertViewPresenter.m
//  Pods
//
//  Created by vlad gorbenko on 10/4/15.
//
//

#import "XLFormAlertViewPresenter.h"

#import "XLFormRowDescriptor.h"

@interface XLFormAlertViewPresenter () <UIAlertViewDelegate>

@end

@implementation XLFormAlertViewPresenter

- (void)presentWithCompletionBlock:(void (^)(void))completionBlock {
#if __IPHONE_OS_VERSION_MAX_ALLOWED < 80000
    [self presentAlertView];
#else
    if ([UIAlertController class]) {
        [self presentAlertController];
    }
    else{
        [self presentAlertView];
    }
#endif
}

- (void)presentAlertView {
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:self.rowDescriptor.selectorTitle message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
    for (id option in self.rowDescriptor.selectorOptions) {
        [alertView addButtonWithTitle:[self.rowDescriptor formatValue:option]];
    }
    alertView.cancelButtonIndex = [alertView addButtonWithTitle:NSLocalizedString(@"Cancel", nil)];
    alertView.tag = [self.rowDescriptor hash];
    [alertView show];
}

- (void)presentAlertController {
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:self.rowDescriptor.selectorTitle message:nil preferredStyle:UIAlertControllerStyleAlert];
    __weak __typeof(self)weakSelf = self;
    for (id option in self.rowDescriptor.selectorOptions) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:[self.rowDescriptor formatValue:option] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [weakSelf.rowDescriptor setValue:option];
            [weakSelf.sourceViewController.formView reloadData];
        }];
        [alertController addAction:action];
    }
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:nil]];
    [self.sourceViewController presentViewController:alertController animated:YES completion:nil];
}

#if __IPHONE_OS_VERSION_MIN_REQUIRED < 80000

#pragma mark - UIAlertView delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(alertView.cancelButtonIndex != buttonIndex) {
        NSString * title = [alertView buttonTitleAtIndex:buttonIndex];
        for (id option in self.rowDescriptor.selectorOptions){
            if ([[self.rowDescriptor formatValue:option] isEqualToString:title]){
                [self.rowDescriptor setValue:option];
                [self.sourceViewController.formView reloadData];
                break;
            }
        }
    }
}

#endif

@end
