//
//  FTXLBaseTableViewCell.h
//  ALJ
//
//  Created by Alex Zdorovets on 5/21/15.
//  Copyright (c) 2015 Alex Zdorovets. All rights reserved.
//

#import "XLFormBaseCell.h"

#import "XLFormBaseCell+Error.h"

@interface FTXLBaseTableViewCell : XLFormBaseCell <XLErrorViewProtocol>

@property (weak, nonatomic) IBOutlet FTProjectLabel *labelError;

@property (nonatomic, weak) IBOutlet UIView<XLErrorProtocol> *errorView;

@end
