//
//  XLFormTableViewContent.m
//  Pods
//
//  Created by vlad gorbenko on 10/7/15.
//
//

#import "XLFormTableViewContent.h"

#import "XLFormDescriptor.h"

#import "XLFormInlineRowDescriptorCell.h"

#import "UITableView+XLFormCollectionViewProtocol.h"

#import "UIView+XLFormAdditions.h"

#import "UIDevice+System.h"

#import "UIView+XLFormAdditions.h"

#import "XLRowTypesStorage.h"

@implementation XLFormTableViewContent

#pragma mark - Accessors

- (UITableView *)tableView {
    return (UITableView *)self.formView;
}

#pragma mark - Modifiers

- (void)setFormView:(UIScrollView<XLCollectionViewProtocol> *)formView {
    [super setFormView:formView];
    [self tableView].rowHeight = UITableViewAutomaticDimension;
    [self tableView].estimatedRowHeight = 44.0;
}

#pragma mark - User interaction

-(void)multivaluedInsertButtonTapped:(XLFormRowDescriptor *)formRow {
    [self deselectFormRow:formRow];
    XLFormSectionDescriptor * multivaluedFormSection = formRow.sectionDescriptor;
    XLFormRowDescriptor * formRowDescriptor = [self formRowFormMultivaluedFormSection:multivaluedFormSection];
    [multivaluedFormSection addFormRow:formRowDescriptor];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.02 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //        self.formView.editing = !self.formView.editing;
        //        self.formView.editing = !self.formView.editing;
    });
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

#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.formDescriptor.formSections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section >= self.formDescriptor.formSections.count){
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"" userInfo:nil];
    }
    return [[[self.formDescriptor.formSections objectAtIndex:section] formRows] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XLFormRowDescriptor * rowDescriptor = [self.formDescriptor formRowAtIndex:indexPath];
    UITableViewCell *cell = [rowDescriptor cell];
    [self updateFormRow:rowDescriptor];
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    XLFormRowDescriptor * rowDescriptor = [self.formDescriptor formRowAtIndex:indexPath];
    [self updateFormRow:rowDescriptor];
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    XLFormRowDescriptor *rowDescriptor = [self.formDescriptor formRowAtIndex:indexPath];
    if (rowDescriptor.isDisabled || !rowDescriptor.sectionDescriptor.isMultivaluedSection){
        return NO;
    }
    id<XLFormDescriptorCell> baseCell = [rowDescriptor cell];
    if ([baseCell conformsToProtocol:@protocol(XLFormInlineRowDescriptorCell)] && ((id<XLFormInlineRowDescriptorCell>)baseCell).inlineRowDescriptor){
        return NO;
    }
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
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


- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    XLFormRowDescriptor * row = [self.formDescriptor formRowAtIndex:sourceIndexPath];
    XLFormSectionDescriptor * section = row.sectionDescriptor;
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Warc-performSelector-leaks"
    [section performSelector:NSSelectorFromString(@"moveRowAtIndexPath:toIndexPath:") withObject:sourceIndexPath withObject:destinationIndexPath];
#pragma GCC diagnostic pop
    // update the accessory view
    [self inputAccessoryViewForRowDescriptor:row];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //        self.formDescriptorView.editing = !self.formDescriptorView.editing;
        //        self.formDescriptorView.editing = !self.formDescriptorView.editing;
    });
    
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete){
        XLFormRowDescriptor * multivaluedFormRow = [self.formDescriptor formRowAtIndex:indexPath];
        // end editing
        UIView * firstResponder = [[multivaluedFormRow cell] findFirstResponder];
        if (firstResponder){
            [self.formView endEditing:YES];
        }
        [multivaluedFormRow.sectionDescriptor removeFormRowAtIndex:indexPath.row];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.02 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //            self.formDescriptorView.editing = !self.formDescriptorView.editing;
            //            self.formDescriptorView.editing = !self.formDescriptorView.editing;
        });
        if (firstResponder){
            UITableViewCell<XLFormDescriptorCell> * firstResponderCell = [firstResponder formDescriptorCell];
            XLFormRowDescriptor * rowDescriptor = firstResponderCell.rowDescriptor;
            [self inputAccessoryViewForRowDescriptor:rowDescriptor];
        }
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert){
        
        XLFormSectionDescriptor * multivaluedFormSection = [self.formDescriptor formSectionAtIndex:indexPath.section];
        if (multivaluedFormSection.sectionInsertMode == XLFormSectionInsertModeButton && multivaluedFormSection.sectionOptions & XLFormSectionOptionCanInsert){
            [self multivaluedInsertButtonTapped:multivaluedFormSection.multivaluedAddButton];
        }
        else{
            XLFormRowDescriptor * formRowDescriptor = [self formRowFormMultivaluedFormSection:multivaluedFormSection];
            [multivaluedFormSection addFormRow:formRowDescriptor];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.02 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //                self.formDescriptorView.editing = !self.formDescriptorView.editing;
                //                self.formDescriptorView.editing = !self.formDescriptorView.editing;
            });
            [self.formView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            id<XLFormDescriptorCell> cell = [formRowDescriptor cell];
            if ([cell formDescriptorCellCanBecomeFirstResponder]) {
                [cell formDescriptorCellBecomeFirstResponder];
            }
        }
    }
}

#pragma mark - UITableViewDelegate

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[self.formDescriptor.formSections objectAtIndex:section] title];
}

-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return [[self.formDescriptor.formSections objectAtIndex:section] footerTitle];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    XLFormRowDescriptor *rowDescriptor = [self.formDescriptor formRowAtIndex:indexPath];
    Class cellClass = [[rowDescriptor cell] class];
    CGFloat height = rowDescriptor.size.height;
    if ([cellClass respondsToSelector:@selector(formDescriptorCellHeightForRowDescriptor:)]){
        height = [cellClass formDescriptorCellHeightForRowDescriptor:rowDescriptor];
    }
    CGFloat itemHeight = self.formView.itemSize.height;
    return height != 0 ? height : itemHeight;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    XLFormRowDescriptor *rowDescriptor = [self.formDescriptor formRowAtIndex:indexPath];
    Class cellClass = [[rowDescriptor cell] class];
    CGFloat height = rowDescriptor.size.height;
    if ([cellClass respondsToSelector:@selector(formDescriptorCellEstimatedHeightForRowDescriptor:)]){
        height = [cellClass formDescriptorCellEstimatedHeightForRowDescriptor:rowDescriptor];
    }
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")){
        return height != 0 ? height : self.formView.estimatedItemSize.height;
    }
    return height != 0 ? height: 44;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XLFormRowDescriptor * row = [self.formDescriptor formRowAtIndex:indexPath];
    XLFormSectionDescriptor * section = row.sectionDescriptor;
    if (section.sectionOptions & XLFormSectionOptionCanInsert){
        if (section.formRows.count == indexPath.row + 2){
            if ([[XLRowTypesStorage inlineRowDescriptorTypesForRowDescriptorTypes].allKeys containsObject:row.rowType]){
                UITableViewCell<XLFormDescriptorCell> * cell = [row cell];
                UIView * firstResponder = [cell findFirstResponder];
                if (firstResponder){
                    return UITableViewCellEditingStyleInsert;
                }
            }
        }
        else if (section.formRows.count == (indexPath.row + 1)){
            return UITableViewCellEditingStyleInsert;
        }
    }
    if (section.sectionOptions & XLFormSectionOptionCanDelete){
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleNone;
}


- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath
       toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    if (sourceIndexPath.section != proposedDestinationIndexPath.section) {
        return sourceIndexPath;
    }
    XLFormSectionDescriptor * sectionDescriptor = [self.formDescriptor formSectionAtIndex:sourceIndexPath.section];
    XLFormRowDescriptor * proposedDestination = [sectionDescriptor.formRows objectAtIndex:proposedDestinationIndexPath.row];
    XLFormBaseCell * proposedDestinationCell = [proposedDestination cell];
    if (([proposedDestinationCell conformsToProtocol:@protocol(XLFormInlineRowDescriptorCell)] && ((id<XLFormInlineRowDescriptorCell>)proposedDestinationCell).inlineRowDescriptor) || ([[XLRowTypesStorage inlineRowDescriptorTypesForRowDescriptorTypes].allKeys containsObject:proposedDestinationCell.rowDescriptor.rowType] && [[proposedDestinationCell findFirstResponder] formDescriptorCell] == proposedDestinationCell)) {
        if (sourceIndexPath.row < proposedDestinationIndexPath.row){
            return [NSIndexPath indexPathForRow:proposedDestinationIndexPath.row + 1 inSection:sourceIndexPath.section];
        }
        else{
            return [NSIndexPath indexPathForRow:proposedDestinationIndexPath.row - 1 inSection:sourceIndexPath.section];
        }
    }
    
    if ((sectionDescriptor.sectionInsertMode == XLFormSectionInsertModeButton && sectionDescriptor.sectionOptions & XLFormSectionOptionCanInsert)){
        if (proposedDestinationIndexPath.row == sectionDescriptor.formRows.count - 1){
            return [NSIndexPath indexPathForRow:(sectionDescriptor.formRows.count - 2) inSection:sourceIndexPath.section];
        }
    }
    return proposedDestinationIndexPath;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCellEditingStyle editingStyle = [self tableView:tableView editingStyleForRowAtIndexPath:indexPath];
    if (editingStyle == UITableViewCellEditingStyleNone){
        return NO;
    }
    return YES;
}

- (void)tableView:(UITableView *)tableView willBeginReorderingRowAtIndexPath:(NSIndexPath *)indexPath
{
    // end editing if inline cell is first responder
    UITableViewCell<XLFormDescriptorCell> * cell = [[self.formView findFirstResponder] formDescriptorCell];
    if ([[self.formDescriptor indexPathOfFormRow:cell.rowDescriptor] isEqual:indexPath]){
        if ([[XLRowTypesStorage inlineRowDescriptorTypesForRowDescriptorTypes].allKeys containsObject:cell.rowDescriptor.rowType]){
            [self.formView endEditing:YES];
        }
    }
}

@end
