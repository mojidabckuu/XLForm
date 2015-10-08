//
//  XLTextInput.h
//  Pods
//
//  Created by vlad gorbenko on 10/8/15.
//
//

#import <Foundation/Foundation.h>

@protocol XLTextInput <UITextInput>

@optional
@property (nullable, nonatomic, copy) NSString *text;

@property (nonatomic, assign) UIReturnKeyType returnKeyType;

@end