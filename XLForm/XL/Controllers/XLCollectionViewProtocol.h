//
//  XLCollectionViewProtocol.h
//  Pods
//
//  Created by vlad gorbenko on 10/6/15.
//
//

#import <Foundation/Foundation.h>

@protocol XLFormDescriptorCell;

@protocol XLCollectionViewProtocol <NSObject>

@property (nonatomic, weak, nullable) id delegate;
@property (nonatomic, weak, nullable) id dataSource;

@property (nonatomic, assign) CGSize itemSize;
@property (nonatomic, assign) CGSize estimatedItemSize;

@property (nonatomic, readonly, nullable) NSArray<NSIndexPath *> *indexPathsForVisibleRows;
@property (nonatomic, readonly, nullable) NSArray<NSIndexPath *> *indexPathsForVisibleItems;

@property (nonatomic, readonly, nullable) NSIndexPath *indexPathForSelectedRow;

@optional

- (nullable NSIndexPath *)indexPathForCell:(id<XLFormDescriptorCell>)cell;

- (void)scrollToRowAtIndexPath:(NSIndexPath *)indexPath atScrollPosition:(NSInteger)scrollPosition animated:(BOOL)animated;

- (void)selectItemAtIndexPath:(nullable NSIndexPath *)indexPath animated:(BOOL)animated scrollPosition:(NSInteger)scrollPosition;
- (void)deselectItemAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated;

#pragma mark - Insert
- (void)insertItemsAtIndexPaths:(NSArray *)indexPaths withItemAnimation:(NSInteger)animation;
- (void)insertSectionAtIndexSet:(NSIndexSet *)indexSet withItemAnimation:(NSInteger)animation;

#pragma mark - Delete
- (void)deleteItemsAtIndexPaths:(NSArray *)indexPaths withItemAnimation:(NSInteger)animation;
- (void)deleteSectionAtIndexSet:(NSIndexSet *)indexSet withItemAnimation:(NSInteger)animation;

#pragma mark - Reload
- (void)syncReloadData;
- (void)reloadData;
- (void)reloadItemAtIndexPaths:(NSArray *)indexPaths withItemAnimation:(NSInteger)animation;

#pragma mark - Update
- (void)updateRows;

@end