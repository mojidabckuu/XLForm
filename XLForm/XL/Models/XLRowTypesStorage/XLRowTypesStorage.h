//
//  XLRowTypesStorage.h
//  Pods
//
//  Created by vlad gorbenko on 10/26/15.
//
//

#import <Foundation/Foundation.h>

@interface XLRowTypesStorage : NSObject

+(NSMutableDictionary *)cellClassesForRowDescriptorTypes:(Class)viewClass;
+(NSMutableDictionary *)inlineRowDescriptorTypesForRowDescriptorTypes;

@end
