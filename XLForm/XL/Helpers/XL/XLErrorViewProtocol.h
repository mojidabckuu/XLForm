//
//  XLErrorViewProtocol.h
//  ALJ
//
//  Created by vlad gorbenko on 8/31/15.
//  Copyright (c) 2015 s4m. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "XLErrorProtocol.h"

@protocol XLErrorViewProtocol <NSObject>

@property (nonatomic, weak) IBOutlet UIView<XLErrorProtocol> *errorView;

@end
