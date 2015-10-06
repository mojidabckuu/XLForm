//
//  XLTextBehavior.h
//  Pods
//
//  Created by vlad gorbenko on 9/22/15.
//
//

#import "XLLabelBehavior.h"

@interface XLTextBehavior : XLLabelBehavior <UITextInputTraits>

@property (nonatomic, assign) NSUInteger length;

@end

#import "XLTextBehavior+PredefinedBehaviors.h"
