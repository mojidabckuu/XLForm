//
//  XLFormRowDescriptor.h
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


#import <Foundation/Foundation.h>
#import "XLFormBaseCell.h"
#import "XLFormValidatorProtocol.h"
#import "XLFormValidationStatus.h"

#import "XLFormAction.h"

#import "XLErrorProtocol.h"

typedef NS_ENUM(NSInteger, XLFormRowDescriptorType) {
    XLFormRowDescriptorTypeNone = 0,
    XLFormRowDescriptorTypeInt,
    XLFormRowDescriptorTypeDec,
    XLFormRowDescriptorTypeString
};

typedef NS_ENUM(NSInteger, XLFormRowSelectionStyle) {
    XLFormRowSelectionStylePush = 1,
    XLFormRowSelectionStylePresent,
    XLFormRowSelectionStyleActionSheet,
    XLFormRowSelectionStyleAlertView,
    XLFormRowSelectionStyleInline,
    XLFormRowSelectionStylePicker,
    XLFormRowSelectionStylePopover,
    
    XLFormRowSelectionStyleUndefined = 0
};

typedef NS_ENUM(NSInteger, XLFormRowSelectionType) {
    XLFormRowSelectionTypePickerView = 0,
    XLFormRowSelectionTypeDatePicker = 1,
    XLFormRowSelectionTypeAssets
};


@class XLFormViewController;
@class XLFormSectionDescriptor;
@protocol XLFormValidatorProtocol;
@class XLFormAction;
@class XLBehavior;

typedef void(^XLOnChangeBlock)(id __nullable oldValue,id __nullable newValue,XLFormRowDescriptor* __nonnull rowDescriptor);

@interface XLFormRowDescriptor : NSObject <XLErrorProtocol>

@property (weak, null_unspecified) XLFormSectionDescriptor * sectionDescriptor;

@property (readwrite, nullable) NSString * tag;
@property (nullable) NSString * title;
@property (nonatomic, strong) NSString *subtitle;

@property (nonatomic, strong) NSString *placeholder;
@property (nonatomic, strong) NSFormatter *formatter;

@property (nonatomic, assign) CGSize size;

@property (nonatomic, assign, getter=isRequired) BOOL required;

@property (readonly, nonnull) NSString * rowType;
@property (nonatomic, assign) XLFormRowDescriptorType rowtype; // TODO: use rowType instead

@property (nonatomic, nullable) id value;
@property (nonatomic, readonly, nullable) NSString *formattedValue;
@property (nullable) Class valueTransformer;

@property (nonnull, nonatomic, readonly) UIView<XLFormDescriptorCell> *cell;
@property (nullable) id cellClass;
@property UITableViewCellStyle cellStyle;
@property (nonatomic, strong, nullable) XLBehavior *behavior;

@property (nonatomic, readonly, nonnull) NSMutableDictionary * cellConfig;
@property (nonatomic, readonly, nonnull) NSMutableDictionary * cellConfigIfDisabled;
@property (nonatomic, readonly, nonnull) NSMutableDictionary * cellConfigAtConfigure;
@property (nonatomic, readonly, nonnull) NSMutableDictionary * cellConfigIfInlined;

// =========
// Selection
// =========
@property (nonnull) XLFormAction * action;
@property (copy, nullable) XLOnChangeBlock onChangeBlock;

@property (nonatomic, assign) XLFormRowSelectionStyle selectionStyle;
@property (nonatomic, assign) XLFormRowSelectionType selectionType;
@property (nonatomic, assign) BOOL mutlipleSelection;
@property (nullable) NSString * noValueDisplayText;
@property (nullable) NSString * selectorTitle;
@property (nullable) NSArray * selectorOptions;

// =====
// State
// =====
@property (nullable, nonatomic, strong) id disabled;
-(BOOL)isDisabled;
@property (nullable, nonatomic, strong) id hidden;
-(BOOL)isHidden;

// ==========
// Validation
// ==========
@property (nullable, nonatomic, strong) NSArray *conditions;
@property (nonatomic, assign) BOOL isValid;

- (nullable NSString *)formatValue:(id)value;

// =====
// Init
// =====
+(nonnull instancetype)formRowDescriptorWithTag:(nullable NSString *)tag rowType:(NSString *)rowType;

@end
