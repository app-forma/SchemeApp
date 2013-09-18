/*---------------------------------------------------------------------------------------------------------------
                      __  ____
   ____   ______ ____|  |/_   | ____    ____
  /    \ /  _ \_  __ \  | |   |/    \  / ___\
 |   |  (  <_> )  | \/  |_|   |   |  \/ /_/  |
 |___|  /\____/|__|  |____/___|___|  /\___  /
      \/  MAKING COMPUTERS SMART   \//_____/
                                    SINCE 1983
 
 Copyright (c) 2013 Marcus Norling. All rights reserved.
 Get in touch: www.frostytouch.com / marcus.norling@gmail.com
---------------------------------------------------------------------------------------------------------------- */

#import <Foundation/Foundation.h>
#import "User.h"

@interface Helpers : NSObject

+(NSString *) asJsonValueFromDictionary:(NSDictionary *)dict;
+(BOOL) stringIsValidEmail:(NSString *)checkString;

+(NSString*) stringFromNSDate:(NSDate*)date;
+(NSDate*) dateFromString:(NSString*)string;
+(NSDate*) currentDateTime;
+(NSDictionary *) startAndEndTimeForDate:(NSDate*)date;
+(BOOL) isValidNSDate:(NSDate*)date;
+(BOOL) earlierDate:(NSDate*)date1 isEarlierThenDate:(NSDate*)date2;
+(NSDictionary *) startAndEndDateOfWeekForDate:(NSDate*)date;
+(NSDate *) beginningDateOfWeek:(int)week;
+(NSDate *) stripStartDateFromTime:(NSDate *)date;
+(NSDate *) stripEndDateFromTime:(NSDate *)date;

@end
