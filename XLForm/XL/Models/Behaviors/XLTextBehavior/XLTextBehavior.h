//
//  XLTextBehavior.h
//  Pods
//
//  Created by vlad gorbenko on 9/22/15.
//
//

#import "XLLabelBehavior.h"

@interface XLTextBehavior : XLLabelBehavior <UITextInputTraits>

@property (nonatomic, assign) BOOL instantMatching; // default is YES
@property (nonatomic, assign) NSUInteger length; // default is 20

@property (nonatomic, assign) BOOL instantReturn; //default is YES

@end

#import "XLTextBehavior+PredefinedBehaviors.h"
