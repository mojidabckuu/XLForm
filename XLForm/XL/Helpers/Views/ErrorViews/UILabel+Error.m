//
//  UILabel+Error.m
//  ALJ
//
//  Created by vlad gorbenko on 8/31/15.
//  Copyright (c) 2015 s4m. All rights reserved.
//

#import "UILabel+Error.h"

@implementation UILabel (Error)

- (void)setError:(NSError *)error {
    self.text = error.localizedDescription;
}

- (NSError *)error {
    return nil;
}

@end
