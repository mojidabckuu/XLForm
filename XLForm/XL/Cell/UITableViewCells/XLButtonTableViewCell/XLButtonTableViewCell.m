//
//  XLButtonTableViewCell.m
//  ALJ
//
//  Created by vlad gorbenko on 9/2/15.
//  Copyright (c) 2015 s4m. All rights reserved.
//

#import "XLButtonTableViewCell.h"

@implementation XLButtonTableViewCell

- (void)update {
    [super update];
    [self.button setTitle:self.rowDescriptor.title forState:UIControlStateNormal];
//    BOOL isDisabled = self.rowDescriptor.isDisabled;
//    self.textLabel.text = self.rowDescriptor.title;
//    BOOL leftAligmnment = self.rowDescriptor.action.viewControllerClass || [self.rowDescriptor.action.viewControllerStoryboardId length] != 0 || [self.rowDescriptor.action.viewControllerNibName length] != 0 || [self.rowDescriptor.action.formSegueIdenfifier length] != 0 || self.rowDescriptor.action.formSegueClass;
//    self.textLabel.textAlignment = leftAligmnment ? NSTextAlignmentLeft : NSTextAlignmentCenter;
//    self.accessoryType = !leftAligmnment || isDisabled ? UITableViewCellAccessoryNone : UITableViewCellAccessoryDisclosureIndicator;
//    self.editingAccessoryType = self.accessoryType;
//    self.selectionStyle = isDisabled ? UITableViewCellSelectionStyleNone : UITableViewCellSelectionStyleDefault;
//    
//    if (!leftAligmnment){
//        CGFloat red, green, blue, alpha;
//        [self.tintColor getRed:&red green:&green blue:&blue alpha:&alpha];
//        self.textLabel.textColor  = [UIColor colorWithRed:red green:green blue:blue alpha:(isDisabled ? 0.3 : 1.0)];
//    }
//    else{
//        self.textLabel.textColor = nil;
//    }
}

#pragma mark - User interaction

- (IBAction)touchUpInside:(id)sender {
    if(self.rowDescriptor.action.formBlock) {
        self.rowDescriptor.action.formBlock(self.rowDescriptor);
    }
}

-(void)formDescriptorCellDidSelectedWithFormController:(XLFormViewController *)controller
{
    if (self.rowDescriptor.action.formBlock){
        self.rowDescriptor.action.formBlock(self.rowDescriptor);
    }
    else if (self.rowDescriptor.action.formSelector) {
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Warc-performSelector-leaks"
        [controller performSelector:self.rowDescriptor.action.formSelector withObject:self.rowDescriptor];
#pragma GCC diagnostic pop
        
    }
    else if ([self.rowDescriptor.action.formSegueIdenfifier length] != 0){
        [controller performSegueWithIdentifier:self.rowDescriptor.action.formSegueIdenfifier sender:self.rowDescriptor];
    }
    else if (self.rowDescriptor.action.formSegueClass){
        UIViewController * controllerToPresent = [self controllerToPresent];
        NSAssert(controllerToPresent, @"either rowDescriptor.action.viewControllerClass or rowDescriptor.action.viewControllerStoryboardId or rowDescriptor.action.viewControllerNibName must be assigned");
        UIStoryboardSegue * segue = [[self.rowDescriptor.action.formSegueClass alloc] initWithIdentifier:self.rowDescriptor.tag source:controller destination:controllerToPresent];
        [controller prepareForSegue:segue sender:self.rowDescriptor];
        [segue perform];
    }
    else{
        UIViewController * controllerToPresent = [self controllerToPresent];
        if (controllerToPresent){
            if ([controllerToPresent conformsToProtocol:@protocol(XLFormRowDescriptorViewController)]){
                ((UIViewController<XLFormRowDescriptorViewController> *)controllerToPresent).rowDescriptor = self.rowDescriptor;
            }
            if (controller.navigationController == nil || [controllerToPresent isKindOfClass:[UINavigationController class]] || self.rowDescriptor.action.viewControllerPresentationMode == XLFormPresentationModePresent){
                [controller presentViewController:controllerToPresent animated:YES completion:nil];
            }
            else{
                [controller.navigationController pushViewController:controllerToPresent animated:YES];
            }
        }
        
    }
}


#pragma mark - Helpers

-(UIViewController *)controllerToPresent
{
    if (self.rowDescriptor.action.viewControllerClass){
        return [[self.rowDescriptor.action.viewControllerClass alloc] init];
    }
    else if ([self.rowDescriptor.action.viewControllerStoryboardId length] != 0){
        UIStoryboard * storyboard =  [self storyboardToPresent];
        NSAssert(storyboard != nil, @"You must provide a storyboard when rowDescriptor.action.viewControllerStoryboardId is used");
        return [storyboard instantiateViewControllerWithIdentifier:self.rowDescriptor.action.viewControllerStoryboardId];
    }
    else if ([self.rowDescriptor.action.viewControllerNibName length] != 0){
        Class viewControllerClass = NSClassFromString(self.rowDescriptor.action.viewControllerNibName);
        NSAssert(viewControllerClass, @"class owner of self.rowDescriptor.action.viewControllerNibName must be equal to %@", self.rowDescriptor.action.viewControllerNibName);
        return [[viewControllerClass alloc] initWithNibName:self.rowDescriptor.action.viewControllerNibName bundle:nil];
    }
    return nil;
}

-(UIStoryboard *)storyboardToPresent
{
    if ([self.formViewController respondsToSelector:@selector(storyboardForRow:)]){
        return [self.formViewController storyboardForRow:self.rowDescriptor];
    }
    if (self.formViewController.storyboard){
        return self.formViewController.storyboard;
    }
    return nil;
}

@end
