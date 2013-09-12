//
//  Validation.m
//  SchemeApp
//
//  Created by Johan Thorell on 2013-09-12.
//  Copyright (c) 2013 Team leet. All rights reserved.
//

#import "Validation.h"

@implementation Validation
+(BOOL)stringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}
+(BOOL)stringIsNotEmpty:(NSString *)checkString
{
    return [checkString length] >= 1;
}
+(BOOL)stringHasValidCharacters:(NSString *)checkString
{
    NSCharacterSet * set = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzåäöABCDEFGHIJKLKMNOPQRSTUVWXYZÅÄÖ0123456789"] invertedSet];
    return [checkString rangeOfCharacterFromSet:set].location == NSNotFound;
}
+(BOOL)stringHasSpace:(NSString *)checkString
{
    if ([checkString rangeOfString:@" "].location == NSNotFound) {
        return NO;
    }
    return YES;
}
@end
