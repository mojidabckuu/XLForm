//
//  XLFormOptionsObject.h
//  Pods
//
//  Created by vlad gorbenko on 10/8/15.
//
//

#import <Foundation/Foundation.h>

#import "XLFormOptionObjectProtocol.h"

@interface XLFormOptionsObject : NSObject <XLFormOptionObjectProtocol>

+(XLFormOptionsObject *)formOptionsObjectWithValue:(id)value displayText:(NSString *)displayText;
+(XLFormOptionsObject *)formOptionsObjectWithValue:(id)value displayText:(NSString *)displayText tag:(NSString *)tag;
+(XLFormOptionsObject *)formOptionsOptionForValue:(id)value fromOptions:(NSArray *)options;
+(XLFormOptionsObject *)formOptionsOptionForDisplayText:(NSString *)displayText fromOptions:(NSArray *)options;

@end