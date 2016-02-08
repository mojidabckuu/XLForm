//
//  XLLabelCollectionViewCell.m
//  Pods
//
//  Created by Vlad Gorbenko on 2/8/16.
//
//

#import "XLLabelCollectionViewCell.h"

@implementation XLLabelCollectionViewCell

- (void)update {
    [super update];
    self.titleLabel.text = self.rowDescriptor.title;
    self.subtitleLabel.text = self.rowDescriptor.subtitle;
    self.valueLabel.text = [self.rowDescriptor formattedValue];
}

@end
