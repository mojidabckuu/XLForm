//
//  XLFormAction.m
//  Pods
//
//  Created by vlad gorbenko on 10/8/15.
//
//

#import "XLFormAction.h"

@implementation XLFormAction

- (instancetype)init
{
    self = [super init];
    if (self) {
        _viewControllerPresentationMode = XLFormPresentationModeDefault;
    }
    return self;
}

// In the implementation
-(id)copyWithZone:(NSZone *)zone
{
    XLFormAction * actionCopy = [[XLFormAction alloc] init];
    actionCopy.viewControllerPresentationMode = self.viewControllerPresentationMode;
    if (self.viewControllerClass){
        actionCopy.viewControllerClass = [self.viewControllerClass copy];
    }
    else if ([self.viewControllerStoryboardId length]  != 0){
        actionCopy.viewControllerStoryboardId = [self.viewControllerStoryboardId copy];
    }
    else if ([self.viewControllerNibName length] != 0){
        actionCopy.viewControllerNibName = [self.viewControllerNibName copy];
    }
    if (self.formBlock){
        actionCopy.formBlock = [self.formBlock copy];
    }
    else if (self.formSelector){
        actionCopy.formSelector = self.formSelector;
    }
    else if (self.formSegueIdenfifier){
        actionCopy.formSegueIdenfifier = [self.formSegueIdenfifier copy];
    }
    else if (self.formSegueClass){
        actionCopy.formSegueClass = [self.formSegueClass copy];
    }
    return actionCopy;
}

-(void)setViewControllerClass:(Class)viewControllerClass
{
    _viewControllerClass = viewControllerClass;
    _viewControllerNibName = nil;
    _viewControllerStoryboardId = nil;
}

-(void)setViewControllerNibName:(NSString *)viewControllerNibName
{
    _viewControllerClass = nil;
    _viewControllerNibName = viewControllerNibName;
    _viewControllerStoryboardId = nil;
}

-(void)setViewControllerStoryboardId:(NSString *)viewControllerStoryboardId
{
    _viewControllerClass = nil;
    _viewControllerNibName = nil;
    _viewControllerStoryboardId = viewControllerStoryboardId;
}


-(void)setFormSelector:(SEL)formSelector
{
    _formBlock = nil;
    _formSegueClass = nil;
    _formSegueIdenfifier = nil;
    _formSelector = formSelector;
}


-(void)setFormBlock:(void (^)(XLFormRowDescriptor *))formBlock
{
    _formSegueClass = nil;
    _formSegueIdenfifier = nil;
    _formSelector = nil;
    _formBlock = formBlock;
}

-(void)setFormSegueClass:(Class)formSegueClass
{
    _formSelector = nil;
    _formBlock = nil;
    _formSegueIdenfifier = nil;
    _formSegueClass = formSegueClass;
}

-(void)setFormSegueIdenfifier:(NSString *)formSegueIdenfifier
{
    _formSelector = nil;
    _formBlock = nil;
    _formSegueClass = nil;
    _formSegueIdenfifier = formSegueIdenfifier;
}

@end