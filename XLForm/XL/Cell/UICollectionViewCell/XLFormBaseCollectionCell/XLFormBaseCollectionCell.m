//
//  XLFormBaseCollectionCell.m
//  Pods
//
//  Created by Alex Zdorovets on 2/7/16.
//
//

#import "XLFormBaseCollectionCell.h"
#import "XLFormContent.h"

@implementation XLFormBaseCollectionCell

- (id)init
{
    self = [super init];
    if (self) {
        [self configure];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self configure];
}

-(void)setRowDescriptor:(XLFormRowDescriptor *)rowDescriptor
{
    _rowDescriptor = rowDescriptor;
    [self update];
    [rowDescriptor.cellConfig enumerateKeysAndObjectsUsingBlock:^(NSString *keyPath, id value, BOOL * __unused stop) {
        if ([self respondsToSelector:@selector(keyPath)]) {
            [self setValue:(value == [NSNull null]) ? nil : value forKeyPath:keyPath];
        }
    }];
    if (rowDescriptor.isDisabled){
        [rowDescriptor.cellConfigIfDisabled enumerateKeysAndObjectsUsingBlock:^(NSString *keyPath, id value, BOOL * __unused stop) {
            [self setValue:(value == [NSNull null]) ? nil : value forKeyPath:keyPath];
        }];
    }
}


- (void)configure
{
}

- (void)update
{

}

-(void)highlight
{
}

-(void)unhighlight
{
}

-(XLFormViewController *)formViewController
{
    id responder = self;
    while (responder){
        if ([responder isKindOfClass:[UIViewController class]]){
            return responder;
        }
        responder = [responder nextResponder];
    }
    return nil;
}

#pragma mark - Navigation Between Fields

-(UIView *)inputAccessoryView
{
    UIView * inputAccessoryView = [self.formViewController.formContent inputAccessoryViewForRowDescriptor:self.rowDescriptor];
    if (inputAccessoryView){
        return inputAccessoryView;
    }
    return [super inputAccessoryView];
}

-(BOOL)formDescriptorCellCanBecomeFirstResponder
{
    return NO;
}

#pragma mark -

-(BOOL)becomeFirstResponder
{
    BOOL result = [super becomeFirstResponder];
    if (result){
        [self.formViewController beginEditing:self.rowDescriptor];
    }
    return result;
}

-(BOOL)resignFirstResponder
{
    BOOL result = [super resignFirstResponder];
    if (result){
        [self.formViewController endEditing:self.rowDescriptor];
    }
    return result;
}


@end
