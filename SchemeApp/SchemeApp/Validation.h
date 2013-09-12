//
//  Validation.h
//  SchemeApp
//
//  Created by Johan Thorell on 2013-09-12.
//  Copyright (c) 2013 Team leet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Validation : NSObject
+(BOOL)stringIsValidEmail:(NSString *)checkString;
+(BOOL)stringIsNotEmpty:(NSString *)checkString;
+(BOOL)stringHasValidCharacters:(NSString *)checkString;
+(BOOL)stringHasSpace:(NSString *)checkString;
@end
