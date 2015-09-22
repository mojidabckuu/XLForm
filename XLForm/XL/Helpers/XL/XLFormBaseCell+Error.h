//
//  XLFormBaseCell+Error.h
//  ALJ
//
//  Created by vlad gorbenko on 8/31/15.
//  Copyright (c) 2015 s4m. All rights reserved.
//

#import "XLFormBaseCell.h"

#import "XLErrorViewProtocol.h"

@interface XLFormBaseCell (Error) <XLErrorViewProtocol>

// TODO: lifehack to bind IBOutlet with view in IB
// You can remove it when finish.
//@property (nonatomic, weak) IBOutlet UIView<XLErrorProtocol> *errorView;

- (void)updateError;

@end
