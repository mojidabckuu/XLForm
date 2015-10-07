//
//  XLFormController.h
//  Pods
//
//  Created by vlad gorbenko on 10/6/15.
//
//

#import <Foundation/Foundation.h>

#import "XLFormRowNavigationDirections.h"

#import "XLFormTextInputDelegate.h"

#import "XLCollectionViewProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@protocol XLFormDescriptorCell;

@class XLFormDescriptor;
@class XLFormSectionDescriptor;
@class XLFormRowDescriptor;

@protocol XLTextInput <UITextInput>

@optional
@property (nullable, nonatomic, copy) NSString *text;

@end

@interface XLFormController : NSObject <XLFormTextInputDelegate>

@property (nonatomic, weak) UIScrollView<XLCollectionViewProtocol> *formView;

@property (nonatomic, strong) XLFormDescriptor *form;

- (UIView *)inputAccessoryViewForRowDescriptor:(XLFormRowDescriptor *)formRow;
- (XLFormRowDescriptor *)nextRowDescriptorForRow:(XLFormRowDescriptor*)currentRow withDirection:(XLFormRowNavigationDirection)direction;

#pragma mark - FormRow management
-(void)selectFormRow:(XLFormRowDescriptor *)formRow;
-(void)deselectFormRow:(XLFormRowDescriptor *)formRow;
-(void)reloadFormRow:(XLFormRowDescriptor *)formRow;
-(id<XLFormDescriptorCell>)updateFormRow:(XLFormRowDescriptor *)formRow;

- (void)navigateToDirection:(XLFormRowNavigationDirection)direction;

@end

NS_ASSUME_NONNULL_END
