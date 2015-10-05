//
//  XLFormActionSheetPresenter.m
//  Pods
//
//  Created by vlad gorbenko on 10/4/15.
//
//

#import "XLFormActionSheetPresenter.h"

#import "XLFormRowDescriptor.h"

#import "XLFormOptionsObject.h"

#import "NSObject+XLFormAdditions.h"

@interface XLFormActionSheetPresenter () <UIActionSheetDelegate>

@end

@implementation XLFormActionSheetPresenter

- (void)presentWithCompletionBlock:(void (^)(void))completionBlock {
#if __IPHONE_OS_VERSION_MAX_ALLOWED < 80000
    [self presentActionSheet];
#else
    if ([UIAlertController class]) {
        [self presentActionSheetController];
    }
    else{
        [self presentActionSheet];
    }
#endif
}

- (void)presentActionSheet {
    UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:self.rowDescriptor.selectorTitle delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    for (id option in self.rowDescriptor.selectorOptions) {
        [actionSheet addButtonWithTitle:[option displayText]];
    }
    actionSheet.cancelButtonIndex = [actionSheet addButtonWithTitle:NSLocalizedString(@"Cancel", nil)];
    actionSheet.tag = [self.rowDescriptor hash];
    [actionSheet showInView:self.sourceViewController.view];
}

- (void)presentActionSheetController {
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:self.rowDescriptor.selectorTitle message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    __weak __typeof(self)weakSelf = self;
    for (id option in self.rowDescriptor.selectorOptions) {
        XLFormOptionsObject *formOption = option;
        if(![option isKindOfClass:[XLFormOptionsObject class]]) {
            formOption = [XLFormOptionsObject formOptionsObjectWithValue:option displayText:[self.rowDescriptor formattedValue]];
        }
        UIAlertAction *action = [UIAlertAction actionWithTitle:[formOption displayText] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [weakSelf.rowDescriptor setValue:option];
            [weakSelf.sourceViewController.tableView reloadData];
        }];
        [alertController addAction:action];
    }
    [self.sourceViewController presentViewController:alertController animated:YES completion:nil];
}

#if __IPHONE_OS_VERSION_MIN_REQUIRED < 80000

#pragma mark - UIActionSheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([actionSheet cancelButtonIndex] != buttonIndex){
        NSString * title = [actionSheet buttonTitleAtIndex:buttonIndex];
        for (id option in self.rowDescriptor.selectorOptions){
            if ([[option displayText] isEqualToString:title]){
                [self.rowDescriptor setValue:option];
                [self.sourceViewController.tableView reloadData];
                break;
            }
        }
    }
}

#endif
@end
