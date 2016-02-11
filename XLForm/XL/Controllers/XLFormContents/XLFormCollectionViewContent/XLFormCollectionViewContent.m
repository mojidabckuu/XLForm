//
//  XLFormCollectionViewContent.m
//  Pods
//
//  Created by vlad gorbenko on 10/7/15.
//
//

#import "XLFormCollectionViewContent.h"

#import "XLFormDescriptor.h"

#import "XLFormInlineRowDescriptorCell.h"

#import "UICollectionView+XLFormCollectionViewProtocol.h"

#import "UIView+XLFormAdditions.h"

#import "UIDevice+System.h"

#import "UIView+XLFormAdditions.h"

#import "XLRowTypesStorage.h"

@implementation XLFormCollectionViewContent

#pragma mark - Accessors

- (UICollectionView *)collectionView {
    return (UITableView *)self.formView;
}

#pragma mark - Modifiers

- (void)setFormView:(UIScrollView<XLCollectionViewProtocol> *)formView {
    [super setFormView:formView];
}

- (void)setFormDescriptor:(XLFormDescriptor *)formDescriptor {
    [super setFormDescriptor:formDescriptor];
    
    NSMutableArray *listOfClasses = [NSMutableArray array];
    for (XLFormSectionDescriptor *section in self.formDescriptor.formSections) {
        for (XLFormRowDescriptor *row in section.formRows) {
            [listOfClasses addObject:@{@"cellClass" : row.cellClass, @"identifier" : row.tag}];
        }
    }
    listOfClasses = [NSSet setWithArray:listOfClasses].allObjects;
    for (NSDictionary *info in listOfClasses) {
        NSBundle *bundle = [NSBundle bundleForClass:NSClassFromString(info[@"cellClass"])];
        [self.collectionView registerNib:[UINib nibWithNibName:info[@"cellClass"] bundle: bundle] forCellWithReuseIdentifier:info[@"identifier"]];
    }
}

#pragma mark - Proxy

- (NSIndexPath *)indexPathWithProxy:(NSIndexPath *)indexPath {
    NSInteger index = 0;
    NSInteger section = 0;
    NSInteger counter = 0;
    for(XLFormSectionDescriptor *sectionDescriptor in self.formDescriptor.formSections) {
        counter += sectionDescriptor.formRows.count;
        if(indexPath.row < counter) {
            index = sectionDescriptor.formRows.count - (counter - indexPath.row);
            section = [self.formDescriptor.formSections indexOfObject:sectionDescriptor];
            break;
        }
    }
    return [NSIndexPath indexPathForItem:index inSection:section];
}

#pragma mark - User interaction

-(void)multivaluedInsertButtonTapped:(XLFormRowDescriptor *)formRow {
    [self deselectFormRow:formRow];
    XLFormSectionDescriptor * multivaluedFormSection = formRow.sectionDescriptor;
    XLFormRowDescriptor * formRowDescriptor = [self formRowFormMultivaluedFormSection:multivaluedFormSection];
    [multivaluedFormSection addFormRow:formRowDescriptor];
    id<XLFormDescriptorCell> cell = [formRowDescriptor cell];
    if ([cell formDescriptorCellCanBecomeFirstResponder]) {
        [cell formDescriptorCellBecomeFirstResponder];
    }
}

-(XLFormRowDescriptor *)formRowFormMultivaluedFormSection:(XLFormSectionDescriptor *)formSection {
    if (formSection.multivaluedRowTemplate){
        return [formSection.multivaluedRowTemplate copy];
    }
    XLFormRowDescriptor * formRowDescriptor = [[formSection.formRows objectAtIndex:0] copy];
    formRowDescriptor.tag = nil;
    return formRowDescriptor;
}

#pragma maek - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if([self.formDescriptor.userInfo[XLFormTranslateSectionsIntoColumns] boolValue]) {
        return 1;
    }
    return self.formDescriptor.formSections.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if([self.formDescriptor.userInfo[XLFormTranslateSectionsIntoColumns] boolValue]) {
        return [[self.formDescriptor.formSections valueForKeyPath:@"@sum.formRows.@count"] integerValue];
    }
    if (section >= self.formDescriptor.formSections.count){
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"" userInfo:nil];
    }
    return [[[self.formDescriptor.formSections objectAtIndex:section] formRows] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XLFormRowDescriptor * rowDescriptor = [self.formDescriptor formRowAtIndex:indexPath];
    UICollectionViewCell *cell = [rowDescriptor cellWithIndexPath:indexPath];
    [self updateFormRow:rowDescriptor];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    XLFormRowDescriptor * rowDescriptor = [self.formDescriptor formRowAtIndex:indexPath];
    [self updateFormRow:rowDescriptor];
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    XLFormRowDescriptor *rowDescriptor = [self.formDescriptor formRowAtIndex:indexPath];
    XLFormSectionDescriptor * section = rowDescriptor.sectionDescriptor;
    if (section.sectionOptions & XLFormSectionOptionCanReorder && section.formRows.count > 1) {
        if (section.sectionInsertMode == XLFormSectionInsertModeButton && section.sectionOptions & XLFormSectionOptionCanInsert){
            if (section.formRows.count <= 2 || rowDescriptor == section.multivaluedAddButton){
                return NO;
            }
        }
        XLFormBaseCell * baseCell = [rowDescriptor cell];
        return !([baseCell conformsToProtocol:@protocol(XLFormInlineRowDescriptorCell)] && ((id<XLFormInlineRowDescriptorCell>)baseCell).inlineRowDescriptor);
    }
    return NO;
}

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    XLFormRowDescriptor * row = [self.formDescriptor formRowAtIndex:sourceIndexPath];
    XLFormSectionDescriptor * section = row.sectionDescriptor;
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Warc-performSelector-leaks"
    [section performSelector:NSSelectorFromString(@"moveRowAtIndexPath:toIndexPath:") withObject:sourceIndexPath withObject:destinationIndexPath];
#pragma GCC diagnostic pop
    // update the accessory view
    [self inputAccessoryViewForRowDescriptor:row];
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    XLFormRowDescriptor *rowDescriptor = [self.formDescriptor formRowAtIndex:indexPath];
    Class cellClass = NSClassFromString(rowDescriptor.cellClass);
    CGSize size = rowDescriptor.size;
    if ([cellClass respondsToSelector:@selector(formDescriptorCellSizeForRowDescriptor:)]){
        size = [cellClass formDescriptorCellSizeForRowDescriptor:rowDescriptor];
    }
    CGSize itemSize = CGSizeEqualToSize(size, CGSizeZero) ? self.formView.itemSize : size;
    if([self.formDescriptor.userInfo[XLFormTranslateSectionsIntoColumns] boolValue]) {
        UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)collectionViewLayout;
        NSInteger itemsCount = self.formDescriptor.formSections.count;
        itemSize.width = collectionView.frame.size.width / itemsCount - (itemsCount - 1) * flowLayout.minimumInteritemSpacing;
    }
    return itemSize;
}

#pragma mark - UICollectionViewDelegate

//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
//
//}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    XLFormRowDescriptor * row = [self.formDescriptor formRowAtIndex:indexPath];
    if (row.isDisabled) {
        return;
    }
    UITableViewCell <XLFormDescriptorCell> * cell = (UITableViewCell<XLFormDescriptorCell> *)[row cell];
    if (!([cell formDescriptorCellCanBecomeFirstResponder] && [cell formDescriptorCellBecomeFirstResponder])){
        [self.formView endEditing:YES];
    }
    [self didSelectFormRow:row];
}

- (NSIndexPath *)collectionView:(UICollectionView *)collectionView targetIndexPathForMoveFromItemAtIndexPath:(NSIndexPath *)originalIndexPath toProposedIndexPath:(NSIndexPath *)proposedIndexPath {
    if (originalIndexPath.section != proposedIndexPath.section) {
        return originalIndexPath;
    }
    XLFormSectionDescriptor * sectionDescriptor = [self.formDescriptor formSectionAtIndex:originalIndexPath.section];
    XLFormRowDescriptor * proposedDestination = [sectionDescriptor.formRows objectAtIndex:proposedIndexPath.row];
    XLFormBaseCell * proposedDestinationCell = [proposedDestination cell];
    if (([proposedDestinationCell conformsToProtocol:@protocol(XLFormInlineRowDescriptorCell)] && ((id<XLFormInlineRowDescriptorCell>)proposedDestinationCell).inlineRowDescriptor) || ([[XLRowTypesStorage inlineRowDescriptorTypesForRowDescriptorTypes].allKeys containsObject:proposedDestinationCell.rowDescriptor.rowType] && [[proposedDestinationCell findFirstResponder] formDescriptorCell] == proposedDestinationCell)) {
        if (originalIndexPath.item < proposedIndexPath.item){
            return [NSIndexPath indexPathForRow:proposedIndexPath.item + 1 inSection:originalIndexPath.section];
        }
        else{
            return [NSIndexPath indexPathForRow:proposedIndexPath.item - 1 inSection:originalIndexPath.section];
        }
    }
    
    if ((sectionDescriptor.sectionInsertMode == XLFormSectionInsertModeButton && sectionDescriptor.sectionOptions & XLFormSectionOptionCanInsert)){
        if (proposedIndexPath.item == sectionDescriptor.formRows.count - 1){
            return [NSIndexPath indexPathForRow:(sectionDescriptor.formRows.count - 2) inSection:originalIndexPath.section];
        }
    }
    return proposedIndexPath;
}

#pragma mark - Utils

- (UIView *)dequeueItemWithCellClass:(NSString *)cellClass identifier:(NSString *)identifier indexPath:(NSIndexPath *)indexPath style:(NSInteger)style {
    return [[self collectionView] dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
}

- (CGFloat)estimatedHeight {
    float height = 0;
    if([self.formDescriptor.userInfo[XLFormTranslateSectionsIntoColumns] boolValue]) {
        float maxHeight = 0;
        for (XLFormSectionDescriptor *section in self.formDescriptor.formSections) {
            height = 0;
            for (XLFormRowDescriptor *row in section.formRows) {
                CGSize size = CGSizeEqualToSize(row.size, CGSizeZero) ? self.formView.itemSize : row.size;
                height += size.height;
            }
            maxHeight = MAX(height, maxHeight);
        }
        height = maxHeight;
    } else {
        for (XLFormSectionDescriptor *section in self.formDescriptor.formSections) {
            for (XLFormRowDescriptor *row in section.formRows) {
                CGSize size = CGSizeEqualToSize(row.size, CGSizeZero) ? self.formView.itemSize : row.size;
                height += size.height;
            }
        }
    }
    return height;
}


@end
