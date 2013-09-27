//
//  NSDate+StringMethods.h
//  SchemeAppAdmin
//
//  Created by Erik Österberg on 2013-09-28.
//  Copyright (c) 2013 Marcus Norling. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Helpers)

-(NSString *)asString;
-(NSString *)asDateString;


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
