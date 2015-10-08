//
//  XLFormOptionObjectProtocol.h
//  Pods
//
//  Created by vlad gorbenko on 10/8/15.
//
//

#import <Foundation/Foundation.h>

@protocol XLFormOptionObjectProtocol

@required

-(nonnull NSString *)formDisplayText;
-(nonnull id)formValue;
-(nullable NSString *)tag;

@end
