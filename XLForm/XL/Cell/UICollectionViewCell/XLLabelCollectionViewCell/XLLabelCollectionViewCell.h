//
//  XLLabelCollectionViewCell.h
//  Pods
//
//  Created by Vlad Gorbenko on 2/8/16.
//
//

#import <UIKit/UIKit.h>

#import "XLBaseCollectionViewCell.h"

@interface XLLabelCollectionViewCell : XLBaseCollectionViewCell

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *subtitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *valueLabel;

@end
