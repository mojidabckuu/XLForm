//
//  XLTextViewCollectionViewCell.h
//  Pods
//
//  Created by Alex Zdorovets on 2/7/16.
//
//

#import "XLBaseCollectionViewCell.h"

@interface XLTextViewCollectionViewCell : XLBaseCollectionViewCell

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *subtitleLabel;
@property (nonatomic, weak) IBOutlet UITextView *textView;

@end
