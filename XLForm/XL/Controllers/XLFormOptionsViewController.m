//
//  XLFormOptionsViewController.m
//  XLForm ( https://github.com/xmartlabs/XLForm )
//
//  Copyright (c) 2015 Xmartlabs ( http://xmartlabs.com )
//
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "XLFormOptionsViewController.h"
#import "XLFormRightDetailCell.h"
#import "XLForm.h"

#define CELL_REUSE_IDENTIFIER  @"OptionCell"

@interface XLFormOptionsViewController () <UITableViewDataSource>

@property NSString * titleHeaderSection;
@property NSString * titleFooterSection;

@property (nonatomic, strong) NSMutableArray *selectedValues;

@end

@implementation XLFormOptionsViewController

@synthesize rowDescriptor = _rowDescriptor;
@synthesize popoverController = __popoverController;

#pragma mark - Lifecycle

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        _titleFooterSection = nil;
        _titleHeaderSection = nil;
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style titleHeaderSection:(NSString *)titleHeaderSection titleFooterSection:(NSString *)titleFooterSection {
    self = [self initWithStyle:style];
    if (self) {
        _titleFooterSection = titleFooterSection;
        _titleHeaderSection = titleHeaderSection;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // register option cell
    [self.tableView registerClass:[XLFormRightDetailCell class] forCellReuseIdentifier:CELL_REUSE_IDENTIFIER];
    
    id value = self.rowDescriptor.value ?: @[];
    NSArray *values = [value isKindOfClass:[NSArray class]] ? value : @[value];
    self.selectedValues = [NSMutableArray arrayWithArray:values];
}

#pragma mark - UITableView data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self selectorOptions] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XLFormRightDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:CELL_REUSE_IDENTIFIER forIndexPath:indexPath];
    id cellObject =  [[self selectorOptions] objectAtIndex:indexPath.row];
    cell.textLabel.text = [self valueDisplayTextForOption:cellObject];
    cell.accessoryType = ([[self selectedValues] containsObject:cellObject] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone);
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return self.titleFooterSection;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.titleHeaderSection;
}

#pragma mark - UITableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    id value =  [[self selectorOptions] objectAtIndex:indexPath.row];
    
    if(self.rowDescriptor.mutlipleSelection) {
        if([self.selectedValues containsObject:value]) {
            [self.selectedValues removeObject:value];
            cell.accessoryType = UITableViewCellAccessoryNone;
        } else {
            [self.selectedValues addObject:value];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    } else {
        [self.selectedValues addObject:value];
        if (self.popoverController){
            [self.popoverController dismissPopoverAnimated:YES];
            [self.popoverController.delegate popoverControllerDidDismissPopover:self.popoverController];
        }
        else if ([self.parentViewController isKindOfClass:[UINavigationController class]]){
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            // TOOD: may be reverse presenter?
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
    if(self.rowDescriptor.mutlipleSelection) {
        self.rowDescriptor.value = [self.selectedValues copy];
    } else {
        self.rowDescriptor.value = [self.selectedValues lastObject];
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(NSString *)valueDisplayTextForOption:(id)option {
    if(self.rowDescriptor.formatter) {
        return [self.rowDescriptor.formatter stringForObjectValue:option];
    }
    if (self.rowDescriptor.valueTransformer) {
        NSString * transformedValue = [self.rowDescriptor.valueTransformer transformedValue:option];
        if (transformedValue){
            return transformedValue;
        }
    }
    return option;
}

#pragma mark - Helpers

-(NSArray *)selectorOptions {
    return self.rowDescriptor.selectorOptions;
}

@end
