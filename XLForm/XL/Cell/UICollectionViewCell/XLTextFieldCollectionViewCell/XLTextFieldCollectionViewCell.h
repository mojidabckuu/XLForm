//
//  XLTextFieldCollectionViewCell.h
//  Pods
//
//  Created by Alex Zdorovets on 2/7/16.
//
//

#import "XLBaseCollectionViewCell.h"

@interface XLTextFieldCollectionViewCell : XLBaseCollectionViewCell

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *subtitleLabel;
@property (nonatomic, weak) IBOutlet UITextField *textField;

@end
