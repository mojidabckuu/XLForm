//
//  XLForm+Validation.h
//  ALJ
//
//  Created by vlad gorbenko on 8/31/15.
//  Copyright (c) 2015 s4m. All rights reserved.
//


#import "XLFormDescriptor.h"

@interface XLFormDescriptor (Validation)

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign, getter=isValidationEnabled) BOOL validationEnabled;

- (BOOL)isValid;

@end
