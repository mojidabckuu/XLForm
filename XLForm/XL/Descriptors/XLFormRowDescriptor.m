//
//  XLFormRowDescriptor.m
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

#import "XLForm.h"
#import "XLFormViewController.h"
#import "XLFormRowDescriptor.h"
#import "NSString+XLFormAdditions.h"

#import "VGValidation.h"

@interface XLFormDescriptor (_XLFormRowDescriptor)

@property (readonly) NSDictionary* allRowsByTag;

-(void)addObserversOfObject:(id)sectionOrRow predicateType:(XLPredicateType)predicateType;
-(void)removeObserversOfObject:(id)sectionOrRow predicateType:(XLPredicateType)predicateType;

@end

@interface XLFormSectionDescriptor (_XLFormRowDescriptor)

-(void)showFormRow:(XLFormRowDescriptor*)formRow;
-(void)hideFormRow:(XLFormRowDescriptor*)formRow;

@end

@interface XLFormRowDescriptor() <NSCopying>

@property (nonatomic) XLFormBaseCell *rowCell;

@property BOOL isDirtyDisablePredicateCache;
@property (nonatomic) NSNumber* disablePredicateCache;
@property BOOL isDirtyHidePredicateCache;
@property (nonatomic) NSNumber* hidePredicateCache;

@end

@implementation XLFormRowDescriptor

@synthesize error = _error;

@synthesize isDirtyDisablePredicateCache = _isDirtyDisablePredicateCache;
@synthesize disablePredicateCache = _disablePredicateCache;
@synthesize isDirtyHidePredicateCache = _isDirtyHidePredicateCache;
@synthesize hidePredicateCache = _hidePredicateCache;
@synthesize disabled = _disabled;
@synthesize hidden = _hidden;

@synthesize cellConfig = _cellConfig;
@synthesize cellConfigAtConfigure = _cellConfigAtConfigure;
@synthesize cellConfigIfDisabled = _cellConfigIfDisabled;
@synthesize cellConfigIfInlined = _cellConfigIfInlined;

#pragma mark - Lifecycle

-(instancetype)init {
    @throw [NSException exceptionWithName:NSGenericException reason:@"initWithTag:(NSString *)tag rowType:(NSString *)rowType title:(NSString *)title must be used" userInfo:nil];
}

-(instancetype)initWithTag:(NSString *)tag rowType:(NSString *)rowType title:(NSString *)title;
{
    self = [super init];
    if (self){
        NSAssert(((![rowType isEqualToString:XLFormRowDescriptorTypeSelectorPopover] && ![rowType isEqualToString:XLFormRowDescriptorTypeMultipleSelectorPopover]) || (([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) && ([rowType isEqualToString:XLFormRowDescriptorTypeSelectorPopover] || [rowType isEqualToString:XLFormRowDescriptorTypeMultipleSelectorPopover]))), @"You must be running under UIUserInterfaceIdiomPad to use either XLFormRowDescriptorTypeSelectorPopover or XLFormRowDescriptorTypeMultipleSelectorPopover rows.");
        _tag = tag;

        _disabled = @NO;
        _hidden = @NO;
        _rowType = rowType;
        _title = title;
        _cellStyle = UITableViewCellStyleValue1;
        _cellConfig = [NSMutableDictionary dictionary];
        _cellConfigIfDisabled = [NSMutableDictionary dictionary];
        _cellConfigAtConfigure = [NSMutableDictionary dictionary];
        _cellConfigIfInlined = [NSMutableDictionary dictionary];
        _isDirtyDisablePredicateCache = YES;
        _disablePredicateCache = nil;
        _isDirtyHidePredicateCache = YES;
        _hidePredicateCache = nil;
        [self addObserver:self forKeyPath:@"value" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:0];
        [self addObserver:self forKeyPath:@"disablePredicateCache" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:0];
        [self addObserver:self forKeyPath:@"hidePredicateCache" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:0];
    }
    return self;
}

+(nonnull instancetype)formRowDescriptorWithTag:(nullable NSString *)tag {
    return [[self class] formRowDescriptorWithTag:tag rowType:@"" title:nil];
}

+(instancetype)formRowDescriptorWithTag:(NSString *)tag rowType:(NSString *)rowType
{
    return [[self class] formRowDescriptorWithTag:tag rowType:rowType title:nil];
}

+(instancetype)formRowDescriptorWithTag:(NSString *)tag rowType:(NSString *)rowType title:(NSString *)title
{
    return [[[self class] alloc] initWithTag:tag rowType:rowType title:title];
}

- (UIView<XLFormDescriptorCell> *)cell {
    XLFormViewController *controller = self.sectionDescriptor.formDescriptor.delegate;
    if (!_rowCell){
        id cellClass = self.cellClass ?: [XLRowTypesStorage cellClassesForRowDescriptorTypes:controller.formView][self.rowType];
        NSAssert(cellClass, @"Not defined XLFormRowDescriptorType: %@", self.rowType ?: @"");
        NSInteger section = [self.sectionDescriptor.formDescriptor.formSections indexOfObject:self.sectionDescriptor];
        NSInteger item = [self.sectionDescriptor.formRows indexOfObject:self];
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
        id delegate = self.sectionDescriptor.formDescriptor.delegate;
        if([delegate respondsToSelector:@selector(cellWithCellClass:identifier:indexPath:style:)]) {
            _rowCell = [delegate cellWithCellClass:self.cellClass identifier:self.tag indexPath:indexPath style:self.cellStyle];
        }
//        NSAssert([_rowCell isKindOfClass:[XLFormBaseCell class]], @"UITableViewCell must extend from XLFormBaseCell");
        [self configureCellAtCreationTime];
    }
    return _rowCell;
}

- (UIView<XLFormDescriptorCell> *)cellWithIndexPath:(NSIndexPath *)indexPath {
    XLFormViewController *controller = self.sectionDescriptor.formDescriptor.delegate;
    if (!_rowCell){
        id cellClass = self.cellClass ?: [XLRowTypesStorage cellClassesForRowDescriptorTypes:controller.formView][self.rowType];
        NSAssert(cellClass, @"Not defined XLFormRowDescriptorType: %@", self.rowType ?: @"");
        id delegate = self.sectionDescriptor.formDescriptor.delegate;
        if([delegate respondsToSelector:@selector(cellWithCellClass:identifier:indexPath:style:)]) {
            _rowCell = [delegate cellWithCellClass:self.cellClass identifier:self.tag indexPath:indexPath style:self.cellStyle];
        }
        [self configureCellAtCreationTime];
    }
    return _rowCell;
}

- (void)configureCellAtCreationTime
{
    [self.cellConfigAtConfigure enumerateKeysAndObjectsUsingBlock:^(NSString *keyPath, id value, __unused BOOL *stop) {
        [_rowCell setValue:(value == [NSNull null]) ? nil : value forKeyPath:keyPath];
    }];
}

-(NSMutableDictionary *)cellConfig
{
    if (_cellConfig) return _cellConfig;
    _cellConfig = [NSMutableDictionary dictionary];
    return _cellConfig;
}

-(NSMutableDictionary *)cellConfigIfDisabled
{
    if (_cellConfigIfDisabled) return _cellConfigIfDisabled;
    _cellConfigIfDisabled = [NSMutableDictionary dictionary];
    return _cellConfigIfDisabled;
}

-(NSMutableDictionary *)cellConfigAtConfigure
{
    if (_cellConfigAtConfigure) return _cellConfigAtConfigure;
    _cellConfigAtConfigure = [NSMutableDictionary dictionary];
    return _cellConfigAtConfigure;
}

- (NSMutableDictionary *)cellConfigIfInlined {
    if(!_cellConfigIfInlined) {
        _cellConfigIfInlined = [NSMutableDictionary dictionary];
    }
    return _cellConfigIfInlined;
}

-(NSString *)description
{
    return self.tag;  // [NSString stringWithFormat:@"%@ - %@ (%@)", [super description], self.tag, self.rowType];
}

-(XLFormAction *)action
{
    if (!_action){
        _action = [[XLFormAction alloc] init];
    }
    return _action;
}

- (NSString *)formattedValue {
    return [self formatValue:self.value];
}

- (NSString *)formatValue:(id)value {
    if([value isKindOfClass:[XLFormOptionsObject class]]) {
        return [value formDisplayText];
    }
    id formattedValue = self.formatter ? [self.formatter stringForObjectValue:value] : value;
    return [formattedValue isKindOfClass:[NSString class]] ? formattedValue : nil;
}

// In the implementation
-(id)copyWithZone:(NSZone *)zone
{
    XLFormRowDescriptor * rowDescriptorCopy = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:[self.rowType copy] title:[self.title copy]];
    rowDescriptorCopy.cellClass = [self.cellClass copy];
    [rowDescriptorCopy.cellConfig addEntriesFromDictionary:self.cellConfig];
    [rowDescriptorCopy.cellConfigAtConfigure addEntriesFromDictionary:self.cellConfigAtConfigure];
    rowDescriptorCopy.valueTransformer = [self.valueTransformer copy];
    rowDescriptorCopy->_hidden = _hidden;
    rowDescriptorCopy->_disabled = _disabled;
    rowDescriptorCopy.isDirtyDisablePredicateCache = YES;
    rowDescriptorCopy.isDirtyHidePredicateCache = YES;

    // =====================
    // properties for Button
    // =====================
    rowDescriptorCopy.action = [self.action copy];

    // ===========================
    // property used for Selectors
    // ===========================

    rowDescriptorCopy.noValueDisplayText = [self.noValueDisplayText copy];
    rowDescriptorCopy.selectorTitle = [self.selectorTitle copy];
    rowDescriptorCopy.selectorOptions = [self.selectorOptions copy];

    return rowDescriptorCopy;
}

-(void)dealloc
{
    [self.sectionDescriptor.formDescriptor removeObserversOfObject:self predicateType:XLPredicateTypeDisabled];
    [self.sectionDescriptor.formDescriptor removeObserversOfObject:self predicateType:XLPredicateTypeHidden];
    @try {
        [self removeObserver:self forKeyPath:@"value"];
    }
    @catch (NSException * __unused exception) {}
    @try {
        [self removeObserver:self forKeyPath:@"disablePredicateCache"];
    }
    @catch (NSException * __unused exception) {}
    @try {
        [self removeObserver:self forKeyPath:@"hidePredicateCache"];
    }
    @catch (NSException * __unused exception) {}
}

#pragma mark - KVO

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (!self.sectionDescriptor) return;
    if (object == self && ([keyPath isEqualToString:@"value"] || [keyPath isEqualToString:@"hidePredicateCache"] || [keyPath isEqualToString:@"disablePredicateCache"])){
        if ([[change objectForKey:NSKeyValueChangeKindKey] isEqualToNumber:@(NSKeyValueChangeSetting)]){
            id newValue = [change objectForKey:NSKeyValueChangeNewKey];
            id oldValue = [change objectForKey:NSKeyValueChangeOldKey];
            if ([keyPath isEqualToString:@"value"]){
                [self.sectionDescriptor.formDescriptor.delegate formRowDescriptorValueHasChanged:object oldValue:oldValue newValue:newValue];
                if (self.onChangeBlock) {
                    self.onChangeBlock(oldValue, newValue, self);
                }
            }
            else{
                [self.sectionDescriptor.formDescriptor.delegate formRowDescriptorPredicateHasChanged:object oldValue:oldValue newValue:newValue predicateType:([keyPath isEqualToString:@"hidePredicateCache"] ? XLPredicateTypeHidden : XLPredicateTypeDisabled)];
            }
        }
    }
}

#pragma mark - Disable Predicate functions

-(BOOL)isDisabled
{
    if (self.sectionDescriptor.formDescriptor.isDisabled){
        return YES;
    }
    if (self.isDirtyDisablePredicateCache) {
        [self evaluateIsDisabled];
    }
    return [self.disablePredicateCache boolValue];
}

-(void)setDisabled:(id)disabled
{
    if ([_disabled isKindOfClass:[NSPredicate class]]){
        [self.sectionDescriptor.formDescriptor removeObserversOfObject:self predicateType:XLPredicateTypeDisabled];
    }
    _disabled = [disabled isKindOfClass:[NSString class]] ? [disabled formPredicate] : disabled;
    if ([_disabled isKindOfClass:[NSPredicate class]]){
        [self.sectionDescriptor.formDescriptor addObserversOfObject:self predicateType:XLPredicateTypeDisabled];
    }

    [self evaluateIsDisabled];
}

-(BOOL)evaluateIsDisabled
{
    if ([_disabled isKindOfClass:[NSPredicate class]]) {
        @try {
            self.disablePredicateCache = @([_disabled evaluateWithObject:self substitutionVariables:self.sectionDescriptor.formDescriptor.allRowsByTag ?: @{}]);
        }
        @catch (NSException *exception) {
            // predicate syntax error.
            self.isDirtyDisablePredicateCache = YES;
        };
    }
    else{
        self.disablePredicateCache = _disabled;
    }
    if ([self.disablePredicateCache boolValue]){
        [self.cell resignFirstResponder];
    }
    return [self.disablePredicateCache boolValue];
}

-(id)disabled
{
    return _disabled;
}

-(void)setDisablePredicateCache:(NSNumber*)disablePredicateCache
{
    NSParameterAssert(disablePredicateCache);
    self.isDirtyDisablePredicateCache = NO;
    if (!_disablePredicateCache || ![_disablePredicateCache isEqualToNumber:disablePredicateCache]){
        _disablePredicateCache = disablePredicateCache;
    }
}

-(NSNumber*)disablePredicateCache
{
    return _disablePredicateCache;
}

#pragma mark - Hide Predicate functions

-(NSNumber *)hidePredicateCache
{
    return _hidePredicateCache;
}

-(void)setHidePredicateCache:(NSNumber *)hidePredicateCache
{
    NSParameterAssert(hidePredicateCache);
    self.isDirtyHidePredicateCache = NO;
    if (!_hidePredicateCache || ![_hidePredicateCache isEqualToNumber:hidePredicateCache]){
        _hidePredicateCache = hidePredicateCache;
    }
}

-(BOOL)isHidden
{
    if (self.isDirtyHidePredicateCache) {
        return [self evaluateIsHidden];
    }
    return [self.hidePredicateCache boolValue];
}

-(BOOL)evaluateIsHidden
{
    if ([_hidden isKindOfClass:[NSPredicate class]]) {
        @try {
            self.hidePredicateCache = @([_hidden evaluateWithObject:self substitutionVariables:self.sectionDescriptor.formDescriptor.allRowsByTag ?: @{}]);
        }
        @catch (NSException *exception) {
            // predicate syntax error.
            self.isDirtyHidePredicateCache = YES;
        };
    }
    else{
        self.hidePredicateCache = _hidden;
    }
    if ([self.hidePredicateCache boolValue]){
        [self.cell resignFirstResponder];
        [self.sectionDescriptor hideFormRow:self];
    }
    else{
        [self.sectionDescriptor showFormRow:self];
    }
    return [self.hidePredicateCache boolValue];
}


-(void)setHidden:(id)hidden {
    if ([_hidden isKindOfClass:[NSPredicate class]]){
        [self.sectionDescriptor.formDescriptor removeObserversOfObject:self predicateType:XLPredicateTypeHidden];
    }
    _hidden = [hidden isKindOfClass:[NSString class]] ? [hidden formPredicate] : hidden;
    if ([_hidden isKindOfClass:[NSPredicate class]]){
        [self.sectionDescriptor.formDescriptor addObserversOfObject:self predicateType:XLPredicateTypeHidden];
    }
    [self evaluateIsHidden]; // check and update if this row should be hidden.
}

-(id)hidden {
    return _hidden;
}

#pragma mark - Validation

- (BOOL)isValid {
    NSError *error = nil;
    NSMutableArray *conditions = [NSMutableArray arrayWithArray:self.conditions];
    if(self.isRequired) {
        if(![conditions  filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self isKindOfClass: %@", [VGConditionPresent class]]].count) {
            [conditions insertObject:[VGConditionPresent condition] atIndex:0];
        }
    }
    BOOL valid = [VGValidator validateValue:self.value conditions:^NSArray *{
        return conditions;
    } error:&error];
    self.error = error;
    return valid;
}

@end
