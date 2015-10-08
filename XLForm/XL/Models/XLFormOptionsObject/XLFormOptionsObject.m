//
//  XLFormOptionsObject.m
//  Pods
//
//  Created by vlad gorbenko on 10/8/15.
//
//

#import "XLFormOptionsObject.h"

@implementation XLFormOptionsObject
{
    NSString * _formDisplaytext;
    NSString * _tag;
    id _formValue;
}

+(XLFormOptionsObject *)formOptionsObjectWithValue:(id)value displayText:(NSString *)displayText
{
    return [[XLFormOptionsObject alloc] initWithValue:value displayText:displayText tag:nil];
}

+(XLFormOptionsObject *)formOptionsObjectWithValue:(id)value displayText:(NSString *)displayText tag:(NSString *)tag {
    XLFormOptionsObject *optionObject = [[XLFormOptionsObject alloc] initWithValue:value displayText:displayText tag:tag];
    return optionObject;
}

-(id)initWithValue:(id)value displayText:(NSString *)displayText tag:(NSString *)tag
{
    self = [super init];
    if (self){
        _formValue = value;
        _formDisplaytext = displayText;
        _tag = tag;
    }
    return self;
}

+(XLFormOptionsObject *)formOptionsOptionForValue:(id)value fromOptions:(NSArray *)options
{
    for (XLFormOptionsObject * option in options) {
        if ([option.formValue isEqual:value]){
            return option;
        }
    }
    return nil;
}

+(XLFormOptionsObject *)formOptionsOptionForDisplayText:(NSString *)displayText fromOptions:(NSArray *)options
{
    for (XLFormOptionsObject * option in options) {
        if ([option.formDisplayText isEqualToString:displayText]){
            return option;
        }
    }
    return nil;
}

#pragma mark - XLFormOptionObject

-(NSString *)formDisplayText
{
    return _formDisplaytext;
}

-(id)formValue
{
    return _formValue;
}

-(NSString *)tag {
    return _tag;
}

@end