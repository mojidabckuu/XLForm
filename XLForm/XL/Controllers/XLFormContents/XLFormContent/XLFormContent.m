//
//  XLFormContent.m
//  Pods
//
//  Created by vlad gorbenko on 10/7/15.
//
//

#import "XLFormContent.h"

#import "XLCollectionViewProtocol.h"

#import "XLFormDescriptor.h"

#import "UIView+XLFormAdditions.h"

#import "XLFormRowNavigationAccessoryView.h"

@implementation XLFormContent

#pragma mark - Lifecycle

- (instancetype)initWithView:(UIView *)view {
    self = [super init];
    if(self) {
        NSAssert([view conformsToProtocol:@protocol(XLCollectionViewProtocol)], @"View should conform to XLFormCollectionViewProtocol");
        NSAssert([view isKindOfClass:[UIScrollView class]], @"View should be kind of UIScrollView class");
        self.formView = (UIScrollView<XLCollectionViewProtocol> *)view;
    }
    return self;
}

#pragma mark - Navigation

- (void)navigateToDirection:(XLFormRowNavigationDirection)direction {
    UIView * firstResponder = [self.formView findFirstResponder];
    id<XLFormDescriptorCell> currentCell = [firstResponder formDescriptorCell];
    NSIndexPath *currentIndexPath = [self.formView indexPathForCell:currentCell];
    XLFormRowDescriptor *currentRow = [self.formDescriptor formRowAtIndex:currentIndexPath];
    XLFormRowDescriptor *nextRow = [self.formDescriptor nextRowDescriptorForRow:currentRow withDirection:direction];
    if (nextRow) {
        id<XLFormDescriptorCell> cell = [nextRow cell];
        if ([cell formDescriptorCellCanBecomeFirstResponder]){
            NSIndexPath * indexPath = [self.formDescriptor indexPathOfFormRow:nextRow];
            [self.formView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:NO];
            [cell formDescriptorCellBecomeFirstResponder];
        }
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    //dismiss keyboard
    UIView * firstResponder = [self.formView findFirstResponder];
    if ([firstResponder conformsToProtocol:@protocol(XLFormDescriptorCell)]){
        id<XLFormDescriptorCell> cell = (id<XLFormDescriptorCell>)firstResponder;
        if ([[XLFormViewController inlineRowDescriptorTypesForRowDescriptorTypes].allKeys containsObject:cell.rowDescriptor.rowType]){
            return;
        }
    }
    [self.formView endEditing:YES];
}

#pragma mark - CRUD

-(void)deselectFormRow:(XLFormRowDescriptor *)formRow {
    NSIndexPath * indexPath = [self.formDescriptor indexPathOfFormRow:formRow];
    if (indexPath){
        [self.formView deselectItemAtIndexPath:indexPath animated:YES];
    }
}

-(void)reloadFormRow:(XLFormRowDescriptor *)formRow {
    NSIndexPath * indexPath = [self.formDescriptor indexPathOfFormRow:formRow];
    if (indexPath){
        [self.formView reloadItemAtIndexPaths:@[indexPath] withItemAnimation:UITableViewRowAnimationNone];
    }
}

-(XLFormBaseCell *)updateFormRow:(XLFormRowDescriptor *)formRow {
    XLFormBaseCell * cell = [formRow cell];
    cell.rowDescriptor = formRow;
    [cell setNeedsUpdateConstraints];
    [cell setNeedsLayout];
    return cell;
}

#pragma mark - 

-(UIView *)inputAccessoryViewForRowDescriptor:(XLFormRowDescriptor *)rowDescriptor
{
    if ((self.formDescriptor.rowNavigationOptions & XLFormRowNavigationOptionEnabled) != XLFormRowNavigationOptionEnabled){
        return nil;
    }
    if ([[[[self class] inlineRowDescriptorTypesForRowDescriptorTypes] allKeys] containsObject:rowDescriptor.rowType]) {
        return nil;
    }
    id<XLFormDescriptorCell> cell = [rowDescriptor cell];
    if (![cell formDescriptorCellCanBecomeFirstResponder]){
        return nil;
    }
    XLFormRowDescriptor * previousRow = [self.formDescriptor nextRowDescriptorForRow:rowDescriptor withDirection:XLFormRowNavigationDirectionPrevious];
    XLFormRowDescriptor * nextRow     = [self.formDescriptor nextRowDescriptorForRow:rowDescriptor withDirection:XLFormRowNavigationDirectionNext];
    [self.navigationAccessoryView.previousButton setEnabled:(previousRow != nil)];
    [self.navigationAccessoryView.nextButton setEnabled:(nextRow != nil)];
    return self.navigationAccessoryView;
}

-(void)ensureRowIsVisible:(XLFormRowDescriptor *)inlineRowDescriptor
{
    UIView<XLFormDescriptorCell> *inlineCell = [inlineRowDescriptor cell];
    NSIndexPath * indexOfOutOfWindowCell = [self.formDescriptor indexPathOfFormRow:inlineRowDescriptor];
    if(!inlineCell.window || (self.formView.contentOffset.y + self.formView.frame.size.height <= inlineCell.frame.origin.y + inlineCell.frame.size.height)){
        [self.formView scrollToRowAtIndexPath:indexOfOutOfWindowCell atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

@end
