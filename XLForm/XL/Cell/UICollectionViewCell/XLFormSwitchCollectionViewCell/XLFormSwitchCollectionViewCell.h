//
//  XLFormSwitchCollectionViewCell.h
//  Pods
//
//  Created by Alex Zdorovets on 3/3/16.
//
//

#import <UIKit/UIKit.h>
#import "XLFormBaseCollectionCell.h"

@interface XLFormSwitchCollectionViewCell : XLFormBaseCollectionCell

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UISwitch *switchControl;

@end
