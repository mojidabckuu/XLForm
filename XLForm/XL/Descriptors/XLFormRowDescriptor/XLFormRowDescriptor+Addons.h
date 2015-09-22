//
//  XLFormRowDescriptor+Addons.h
//  ALJ
//
//  Created by vlad gorbenko on 9/1/15.
//  Copyright (c) 2015 s4m. All rights reserved.
//

#import "XLFormRowDescriptor.h"

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

@interface XLFormRowDescriptor (Addons)

@property (nonatomic, strong) NSNumber *height;
@property (nonatomic, strong) NSString *subtitle;
@property (nonatomic, strong) NSString *placeholder;
@property (nonatomic, strong) NSFormatter *formatter;

@property (nonatomic, assign) XLFormRowSelectionStyle selectionStyle;
@property (nonatomic, assign) XLFormRowSelectionType selectionType;
@property (nonatomic, assign) BOOL mutlipleSelection;

@end
