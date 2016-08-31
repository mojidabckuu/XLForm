//
//  UICollectionView+XLFormCollectionViewProtocol.m
//  Pods
//
//  Created by vlad gorbenko on 10/7/15.
//
//

#import "UICollectionView+XLFormCollectionViewProtocol.h"

#import <objc/runtime.h>

@implementation UICollectionView (XLFormCollectionViewProtocol)

#pragma mark - Insert

- (void)insertItemsAtIndexPaths:(NSArray *)indexPaths withItemAnimation:(NSInteger)animation {
    [self performBatchUpdates:^{
        [self insertItemsAtIndexPaths:indexPaths];
    } completion:nil];
}

- (void)insertSectionAtIndexSet:(NSIndexSet *)indexSet withItemAnimation:(NSInteger)animation {
    [self performBatchUpdates:^{
        [self insertSections:indexSet];
    } completion:nil];
}

#pragma mark - Delete

- (void)deleteItemsAtIndexPaths:(NSArray *)indexPaths withItemAnimation:(NSInteger)animation {
    [self performBatchUpdates:^{
        [self deleteItemsAtIndexPaths:indexPaths];
    } completion:nil];
}

- (void)deleteSectionAtIndexSet:(NSIndexSet *)indexSet withItemAnimation:(NSInteger)animation {
    [self performBatchUpdates:^{
        [self deleteSections:indexSet];
    } completion:nil];
}

#pragma mark - Reload

- (void)syncReloadData {
    [self reloadData];
    [self performBatchUpdates:nil completion:nil];
}

- (void)reloadItemAtIndexPaths:(NSArray *)indexPaths withItemAnimation:(NSInteger)animation {
    [self reloadItemAtIndexPaths:indexPaths withItemAnimation:animation];
}

- (void)updateRows {
    [self performBatchUpdates:^{
        [self reloadData];
    } completion:nil];
}

#pragma mark - Scroll

- (void)scrollToRowAtIndexPath:(NSIndexPath *)indexPath atScrollPosition:(NSInteger)scrollPosition animated:(BOOL)animated {
    [self scrollToItemAtIndexPath:indexPath atScrollPosition:scrollPosition animated:animated];
}

#pragma mark - Modifiers

- (void)setItemSize:(CGSize)itemSize {
    id value = [NSValue valueWithCGSize:itemSize];
    objc_setAssociatedObject(self, @selector(itemSize), value, OBJC_ASSOCIATION_RETAIN);
}

- (void)setEstimatedItemSize:(CGSize)estimatedItemSize {
}

#pragma mark - Accessors

- (NSIndexPath *)indexPathForSelectedRow {
    return [[self indexPathsForSelectedItems] firstObject];
}

- (CGSize)itemSize {
    NSValue *value = objc_getAssociatedObject(self, @selector(itemSize));
    return [value CGSizeValue];
}

- (CGSize)estimatedItemSize {
    return CGSizeZero;
}

@end
