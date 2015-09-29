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
    if(self.titleLabel) {
        self.titleLabel.text = self.rowDescriptor.title;
    } else if(self.rowDescriptor.title) {
        self.textLabel.text = self.rowDescriptor.title;
    }
    if(self.subtitleLabel) {
        self.subtitleLabel.text = self.rowDescriptor.subtitle;
    } else if(self.rowDescriptor.subtitle) {
        self.detailTextLabel.text = self.rowDescriptor.subtitle;
    }
    id value = self.rowDescriptor.value;
    NSString *text = self.rowDescriptor.formatter ? [self.rowDescriptor.formatter stringForObjectValue:value] : value;
    if(self.valueLabel) {
        self.valueLabel.text = text;
    } else {
        self.detailTextLabel.text = text;
    }
}

@end
