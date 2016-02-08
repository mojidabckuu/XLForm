//
//  XLRowTypesStorage.m
//  Pods
//
//  Created by vlad gorbenko on 10/26/15.
//
//

#import "XLRowTypesStorage.h"

#import "XLForm.h"

@implementation XLRowTypesStorage

#pragma mark - CellClasses

+(NSMutableDictionary *)cellClassesForRowDescriptorTypes:(Class)viewClass
{
    static NSMutableDictionary * _cellClassesForRowDescriptorTypes;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (viewClass == [UITableView class]) {
        _cellClassesForRowDescriptorTypes = [@{
                                               //                                               XLFormRowDescriptorTypeText:[XLFormTextFieldCell class],
                                               //                                               XLFormRowDescriptorTypeName: [XLFormTextFieldCell class],
                                               //                                               XLFormRowDescriptorTypePhone:[XLFormTextFieldCell class],
                                               //                                               XLFormRowDescriptorTypeURL:[XLFormTextFieldCell class],
                                               //                                               XLFormRowDescriptorTypeEmail: [XLFormTextFieldCell class],
                                               //                                               XLFormRowDescriptorTypeTwitter: [XLFormTextFieldCell class],
                                               //                                               XLFormRowDescriptorTypeAccount: [XLFormTextFieldCell class],
                                               //                                               XLFormRowDescriptorTypePassword: [XLFormTextFieldCell class],
                                               //                                               XLFormRowDescriptorTypeNumber: [XLFormTextFieldCell class],
                                               //                                               XLFormRowDescriptorTypeInteger: [XLFormTextFieldCell class],
                                               //                                               XLFormRowDescriptorTypeDecimal: [XLFormTextFieldCell class],
                                               //                                               XLFormRowDescriptorTypeZipCode: [XLFormTextFieldCell class],
                                               //                                               XLFormRowDescriptorTypeSelectorPush: [XLFormSelectorCell class],
                                               //                                               XLFormRowDescriptorTypeSelectorPopover: [XLFormSelectorCell class],
                                               //                                               XLFormRowDescriptorTypeSelectorActionSheet: [XLFormSelectorCell class],
                                               //                                               XLFormRowDescriptorTypeSelectorAlertView: [XLFormSelectorCell class],
                                               //                                               XLFormRowDescriptorTypeSelectorPickerView: [XLFormSelectorCell class],
                                               //                                               XLFormRowDescriptorTypeSelectorPickerViewInline: [XLFormInlineSelectorCell class],
                                               //                                               XLFormRowDescriptorTypeSelectorSegmentedControl: [XLFormSegmentedCell class],
                                               //                                               XLFormRowDescriptorTypeMultipleSelector: [XLFormSelectorCell class],
                                               //                                               XLFormRowDescriptorTypeMultipleSelectorPopover: [XLFormSelectorCell class],
                                               //                                               XLFormRowDescriptorTypeTextView: [XLFormTextViewCell class],
                                               //                                               XLFormRowDescriptorTypeButton: [XLFormButtonCell class],
                                               //                                               XLFormRowDescriptorTypeInfo: [XLFormSelectorCell class],
                                               XLFormRowDescriptorTypeBooleanSwitch : [XLSwitchTableViewCell class],
                                               XLFormRowDescriptorTypeBooleanCheck : [XLFormCheckCell class],
                                               XLFormRowDescriptorTypeDate: [XLFormDateCell class],
                                               XLFormRowDescriptorTypeTime: [XLFormDateCell class],
                                               XLFormRowDescriptorTypeDateTime : [XLFormDateCell class],
                                               XLFormRowDescriptorTypeCountDownTimer : [XLFormDateCell class],
                                               XLFormRowDescriptorTypeDateInline: [XLFormDateCell class],
                                               XLFormRowDescriptorTypeTimeInline: [XLFormDateCell class],
                                               XLFormRowDescriptorTypeDateTimeInline: [XLFormDateCell class],
                                               XLFormRowDescriptorTypeCountDownTimerInline : [XLFormDateCell class],
                                               XLFormRowDescriptorTypeDatePicker : [XLFormDatePickerCell class],
                                               XLFormRowDescriptorTypePicker : [XLFormPickerCell class],
                                               XLFormRowDescriptorTypeSlider : [XLFormSliderCell class],
                                               XLFormRowDescriptorTypeStepCounter: [XLFormStepCounterCell class]
                                               } mutableCopy];
        } else if (viewClass == [UICollectionView class]) {
            _cellClassesForRowDescriptorTypes = [@{
                                                   XLFormRowDescriptorTypeBooleanSwitch : [XLSwitchTableViewCell class],
                                                   XLFormRowDescriptorTypeBooleanCheck : [XLFormCheckCell class],
                                                   XLFormRowDescriptorTypeDate: [XLFormDateCell class],
                                                   XLFormRowDescriptorTypeTime: [XLFormDateCell class],
                                                   XLFormRowDescriptorTypeDateTime : [XLFormDateCell class],
                                                   XLFormRowDescriptorTypeCountDownTimer : [XLFormDateCell class],
                                                   XLFormRowDescriptorTypeDateInline: [XLFormDateCell class],
                                                   XLFormRowDescriptorTypeTimeInline: [XLFormDateCell class],
                                                   XLFormRowDescriptorTypeDateTimeInline: [XLFormDateCell class],
                                                   XLFormRowDescriptorTypeCountDownTimerInline : [XLFormDateCell class],
                                                   XLFormRowDescriptorTypeDatePicker : [XLFormDatePickerCell class],
                                                   XLFormRowDescriptorTypePicker : [XLFormPickerCell class],
                                                   XLFormRowDescriptorTypeSlider : [XLFormSliderCell class],
                                                   XLFormRowDescriptorTypeStepCounter: [XLFormStepCounterCell class]
                                                   } mutableCopy];
        }
    });
    return _cellClassesForRowDescriptorTypes;
}

#pragma mark - inlineRowDescriptorTypes

+(NSMutableDictionary *)inlineRowDescriptorTypesForRowDescriptorTypes
{
    static NSMutableDictionary * _inlineRowDescriptorTypesForRowDescriptorTypes;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _inlineRowDescriptorTypesForRowDescriptorTypes = [
                                                          @{XLFormRowDescriptorTypeSelectorPickerViewInline: XLFormRowDescriptorTypePicker,
                                                            XLFormRowDescriptorTypeDateInline: XLFormRowDescriptorTypeDatePicker,
                                                            XLFormRowDescriptorTypeDateTimeInline: XLFormRowDescriptorTypeDatePicker,
                                                            XLFormRowDescriptorTypeTimeInline: XLFormRowDescriptorTypeDatePicker,
                                                            XLFormRowDescriptorTypeCountDownTimerInline: XLFormRowDescriptorTypeDatePicker
                                                            } mutableCopy];
    });
    return _inlineRowDescriptorTypesForRowDescriptorTypes;
}

@end
