//
//  XLFormBaseCollectionCell.h
//  Pods
//
//  Created by Alex Zdorovets on 2/7/16.
//
//

#import "XLFormDescriptorCell.h"
#import "XLFormViewController.h"
#import <UIKit/UIKit.h>

#import "XLRowTypesStorage.h"

@class XLFormViewController;
@class XLFormRowDescriptor;

@interface XLFormBaseCollectionCell : UICollectionViewCell<XLFormDescriptorCell>

@property (nonatomic, weak) XLFormRowDescriptor * rowDescriptor;

-(XLFormViewController *)formViewController;

@end
