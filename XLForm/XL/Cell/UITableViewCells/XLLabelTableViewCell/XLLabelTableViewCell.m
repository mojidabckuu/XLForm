//
//  XLLabelTableViewCell.m
//  ALJ
//
//  Created by vlad gorbenko on 9/2/15.
//  Copyright (c) 2015 s4m. All rights reserved.
//

#import "XLLabelTableViewCell.h"

@implementation XLLabelTableViewCell

- (void)update {
    [super update];
    UILabel *titleLabel = self.titleLabel ?: self.textLabel;
    titleLabel.text = self.rowDescriptor.title;
    UILabel *subtitleLabel = self.subtitleLabel ?: self.detailTextLabel;
    subtitleLabel.text = self.rowDescriptor.subtitle;
    UILabel *valueLabel = self.valueLabel ?: self.detailTextLabel;
    id value = [self.rowDescriptor formattedValue];
    if ([value isKindOfClass:[NSAttributedString class]]) {
        valueLabel.attributedText = value;
    } else {
        valueLabel.text = value;
    }
}

@end
