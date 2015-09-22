//
//  XLButtonTableViewCell.m
//  ALJ
//
//  Created by vlad gorbenko on 9/2/15.
//  Copyright (c) 2015 s4m. All rights reserved.
//

#import "XLButtonTableViewCell.h"

@implementation XLButtonTableViewCell

- (void)update {
    [super update];
    [self.button setTitle:self.rowDescriptor.title forState:UIControlStateNormal];
}

#pragma mark - User interaction

- (IBAction)touchUpInside:(id)sender {
    if(self.rowDescriptor.action.formBlock) {
        self.rowDescriptor.action.formBlock(self.rowDescriptor);
    }
}

@end
