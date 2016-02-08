//
//  XLBaseCollectionViewCell.h
//  Pods
//
//  Created by Alex Zdorovets on 2/7/16.
//
//

#import "XLFormBaseCollectionCell.h"

#import "XLFormBaseCell+Error.h"

@interface XLBaseCollectionViewCell : XLFormBaseCollectionCell <XLErrorViewProtocol>

@property (weak, nonatomic) IBOutlet UILabel *labelError;

@property (nonatomic, weak) IBOutlet UIView<XLErrorProtocol> *errorView;

@end
