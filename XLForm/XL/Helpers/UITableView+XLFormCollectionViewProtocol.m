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

#pragma mark - Reload

- (void)reloadItemAtIndexPaths:(NSArray *)indexPaths withItemAnimation:(NSInteger)animation {
    [self reloadRowsAtIndexPaths:indexPaths withRowAnimation:animation];
}

- (void)updateRows {
    [self beginUpdates];
    [self endUpdates];
}

@end
