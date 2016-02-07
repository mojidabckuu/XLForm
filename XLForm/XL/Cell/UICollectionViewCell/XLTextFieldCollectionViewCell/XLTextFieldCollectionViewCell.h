//
//  XLTextFieldCollectionViewCell.h
//  Pods
//
//  Created by Alex Zdorovets on 2/7/16.
//
//

#import "FTXLBaseTableViewCell.h"

@interface XLTextFieldCollectionViewCell : FTXLBaseTableViewCell

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *subtitleLabel;
@property (nonatomic, weak) IBOutlet UITextField *textField;

@end
