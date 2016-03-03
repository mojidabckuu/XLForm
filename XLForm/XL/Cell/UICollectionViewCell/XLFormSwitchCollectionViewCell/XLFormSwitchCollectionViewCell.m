//
//  XLFormSwitchCollectionViewCell.m
//  Pods
//
//  Created by Alex Zdorovets on 3/3/16.
//
//

#import "XLFormSwitchCollectionViewCell.h"

@implementation XLFormSwitchCollectionViewCell

#pragma mark - Setup

- (void)configure {
    [super configure];
    [self.switchControl addTarget:self action:@selector(valueChanged) forControlEvents:UIControlEventValueChanged];
}

#pragma mark - Update

- (void)update {
    [super update];
    self.titleLabel.text = self.rowDescriptor.title;
    self.switchControl.on = [self.rowDescriptor.value boolValue];
    self.switchControl.enabled = !self.rowDescriptor.isDisabled;
}

#pragma mark - Accessors

- (UISwitch *)switchControl {
    if (!_switchControl) {
        UISwitch *switchControl = [[UISwitch alloc] init];
        [self addSubview:switchControl];
        _switchControl = switchControl;
    }
    return _switchControl;
}

#pragma mark - User interaction

- (void)valueChanged {
    self.rowDescriptor.value = @(self.switchControl.on);
}

@end
