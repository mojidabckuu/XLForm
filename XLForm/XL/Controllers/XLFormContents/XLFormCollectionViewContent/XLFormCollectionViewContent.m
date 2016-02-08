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
            if ([row.cellClass length]) {
                [listOfClasses addObject:row.cellClass];
            }
        }
    }
    listOfClasses = [NSSet setWithArray:listOfClasses].allObjects;
    for (NSString *cellClass in listOfClasses) {
        NSBundle *bundle = [NSBundle bundleForClass:NSClassFromString(cellClass)];
        [self.collectionView registerNib:[UINib nibWithNibName:cellClass bundle: bundle] forCellWithReuseIdentifier:cellClass];
    }
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
    return self.formDescriptor.formSections.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section >= self.formDescriptor.formSections.count){
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"" userInfo:nil];
    }
    return [[[self.formDescriptor.formSections objectAtIndex:section] formRows] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XLFormRowDescriptor * rowDescriptor = [self.formDescriptor formRowAtIndex:indexPath];
    UICollectionViewCell *cell = [rowDescriptor cell];
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
//    Class cellClass = [[rowDescriptor cell] class];
    CGSize size = rowDescriptor.size;
//    if ([cellClass respondsToSelector:@selector(formDescriptorCellSizeForRowDescriptor:)]){
//        size = [cellClass formDescriptorCellSizeForRowDescriptor:rowDescriptor];
//    }
    return CGSizeEqualToSize(size, CGSizeZero) ? self.formView.itemSize : size;
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


@end
