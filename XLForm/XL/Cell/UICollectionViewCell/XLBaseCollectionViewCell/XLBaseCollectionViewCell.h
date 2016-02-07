//
//  XLBaseCollectionViewCell.h
//  Pods
//
//  Created by Alex Zdorovets on 2/7/16.
//
//

#import "XLFormBaseCell.h"

#import "XLFormBaseCell+Error.h"

@interface XLBaseCollectionViewCell : XLFormBaseCell <XLErrorViewProtocol>

@property (weak, nonatomic) IBOutlet UILabel *labelError;

@property (nonatomic, weak) IBOutlet UIView<XLErrorProtocol> *errorView;

@end
