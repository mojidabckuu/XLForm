//
//  XLTextViewTableViewCell.h
//  Pods
//
//  Created by vlad gorbenko on 9/29/15.
//
//

#import "FTXLBaseTableViewCell.h"

@interface XLTextViewTableViewCell : FTXLBaseTableViewCell

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UITextView *textView;

@end
