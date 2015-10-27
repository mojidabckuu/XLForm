//
//  UITableView+XLFormCollectionViewProtocol.m
//  Pods
//
//  Created by vlad gorbenko on 10/7/15.
//
//

#import "UITableView+XLFormCollectionViewProtocol.h"

@implementation UITableView (XLFormCollectionViewProtocol)

#pragma mark - Insert

- (void)insertItemsAtIndexPaths:(NSArray *)indexPaths withItemAnimation:(NSInteger)animation {
    [self beginUpdates];
    [self insertRowsAtIndexPaths:indexPaths withRowAnimation:animation];
    [self endUpdates];
}

- (void)insertSectionAtIndexSet:(NSIndexSet *)indexSet withItemAnimation:(NSInteger)animation {
    [self beginUpdates];
    [self insertSections:indexSet withRowAnimation:animation];
    [self endUpdates];
}

#pragma mark - Delete

- (void)deleteItemsAtIndexPaths:(NSArray *)indexPaths withItemAnimation:(NSInteger)animation {
    [self beginUpdates];
    [self deleteRowsAtIndexPaths:indexPaths withRowAnimation:animation];
    [self endUpdates];
}

- (void)deleteSectionAtIndexSet:(NSIndexSet *)indexSet withItemAnimation:(NSInteger)animation {
    [self beginUpdates];
    [self deleteSections:indexSet withRowAnimation:animation];
    [self endUpdates];
}

#pragma mark - Select

- (void)selectItemAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated scrollPosition:(NSInteger)scrollPosition {
    [self selectRowAtIndexPath:indexPath animated:animated scrollPosition:scrollPosition];
}

- (void)deselectItemAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated {
    [self deselectRowAtIndexPath:indexPath animated:animated];
}

#pragma mark - Reload

- (void)reloadItemAtIndexPaths:(NSArray *)indexPaths withItemAnimation:(NSInteger)animation {
    [self reloadRowsAtIndexPaths:indexPaths withRowAnimation:animation];
}

- (void)updateRows {
    [self beginUpdates];
    [self endUpdates];
}

#pragma mark - Modifiers

- (void)setItemSize:(CGSize)itemSize {
    self.rowHeight = itemSize.height;
}

- (void)setEstimatedItemSize:(CGSize)estimatedItemSize {
    self.estimatedRowHeight = estimatedItemSize.height;
}

#pragma mark - Accessors

- (CGSize)itemSize {
    return CGSizeMake(0, self.rowHeight);
}

- (CGSize)estimatedItemSize {
    return CGSizeMake(0, self.estimatedRowHeight);
}

@end
