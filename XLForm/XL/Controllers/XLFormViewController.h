//
//  XLFormViewController.h
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

#import <UIKit/UIKit.h>
#import "XLFormOptionsViewController.h"
#import "XLFormDescriptor.h"
#import "XLFormSectionDescriptor.h"
#import "XLFormDescriptorDelegate.h"
#import "XLFormBaseCell.h"

#import "XLFormRowNavigationDirections.h"

#import "XLCollectionViewProtocol.h"

#import "XLFormContent.h"

@class XLFormViewController;
@class XLFormRowDescriptor;
@class XLFormSectionDescriptor;
@class XLFormDescriptor;
@class XLFormBaseCell;
@class XLFormContent;

@protocol XLFormViewControllerDelegate <NSObject>

@optional

-(NSDictionary *)formValues;
-(NSDictionary *)httpParameters;

-(UIStoryboard *)storyboardForRow:(XLFormRowDescriptor *)formRow;

-(void)showFormValidationError:(NSError *)error;

-(UITableViewRowAnimation)insertRowAnimationForRow:(XLFormRowDescriptor *)formRow;
-(UITableViewRowAnimation)deleteRowAnimationForRow:(XLFormRowDescriptor *)formRow;
-(UITableViewRowAnimation)insertRowAnimationForSection:(XLFormSectionDescriptor *)formSection;
-(UITableViewRowAnimation)deleteRowAnimationForSection:(XLFormSectionDescriptor *)formSection;

// highlight/unhighlight
-(void)beginEditing:(XLFormRowDescriptor *)rowDescriptor;
-(void)endEditing:(XLFormRowDescriptor *)rowDescriptor;

@end

@interface XLFormViewController : UIViewController <XLFormDescriptorDelegate, UIActionSheetDelegate, XLFormViewControllerDelegate>

@property XLFormDescriptor * form;
@property IBOutlet UIScrollView<XLCollectionViewProtocol> *formView;
@property (nonatomic, strong) XLFormContent *formContent;

-(id)initWithForm:(XLFormDescriptor *)form;
-(id)initWithForm:(XLFormDescriptor *)form style:(UITableViewStyle)style;

@end
