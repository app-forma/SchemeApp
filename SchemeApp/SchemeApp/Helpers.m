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

#import "Helpers.h"

@implementation Helpers

#pragma mark - asJsonValueFromDictionary
+(NSString *)asJsonValueFromDictionary:(NSDictionary *)dict
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if (!jsonData) {
        NSLog(@"ERROR SERIALIZING TO JSON: %@", error);
        return nil;
    } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}

#pragma mark - NSStringIsValidEmail
+(BOOL) stringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

#pragma mark - Date helpers
+(NSString*)stringFromNSDate:(NSDate*)date
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];
    return [NSString stringWithFormat:@"%@", [dateFormat stringFromDate:date]];
}

+(NSDate*)dateFromString:(NSString*)string
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    
    if (string.length == 10)
    {
        [dateFormat setDateFormat:@"yyyy-MM-dd"];
    }
    else
    {
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];
    }
    
    [dateFormat setTimeZone:[NSTimeZone systemTimeZone]];
    return [dateFormat dateFromString:string];
}

/**
 * @info - Given a date it will return the beginning and end of the day.
 *
 * @tip - [Helpers startAndEndTimeForDate:[Helpers currentDateTime]]
 *
 * @headsUp - start/endTime will always be YYYY-MM-dd 00:00:00/23:59:59
 *
 * @param {NSDate} date
 *
 * @return {NSDictionary} key's: startTime:{string}, endTime:{string}
 */
+(NSDictionary *) startAndEndTimeForDate:(NSDate*)date
{

    NSUInteger componentFlags =  NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit;
    NSDateComponents *components = [[NSCalendar currentCalendar] components:componentFlags fromDate:[Helpers currentDateTime]];
    [components setHour:0];
    [components setMinute:0];
    NSCalendar *gregorian = [NSCalendar currentCalendar];
    [gregorian setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    NSDate *start = [gregorian dateFromComponents:components];
    [components setHour:23];
    [components setMinute:59];
    NSDate *end = [gregorian dateFromComponents:components];
    return @{@"startTime":[Helpers stringFromNSDate:start], @"endTime":[Helpers stringFromNSDate:end]};
}

+(NSDate*)currentDateTime
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];    
    [dateFormat setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    [dateFormat setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:3600*-2]];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];
    return [dateFormat dateFromString:[Helpers stringFromNSDate:[NSDate date]]];
}

+(BOOL)isValidNSDate:(NSDate*)date
{
    NSUInteger componentFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit;
    NSDateComponents *components = [[NSCalendar currentCalendar] components:componentFlags fromDate:date];
    NSInteger year = [components year];
    NSInteger month = [components month];
    NSInteger day = [components day];
    NSInteger hour = [components hour];
    NSInteger minute = [components minute];

//    NSLog(@"%ld %ld %ld %ld %ld", (long)year, (long)month, (long)day, (long)hour, (long)minute);
    if (!date || !year || !month || !day || !hour || minute > 59 || minute < 0 ) {
        return NO;
    }
    return YES;
}

+(BOOL)earlierDate:(NSDate*)date1 isEarlierThenDate:(NSDate*)date2
{
    switch ([date1 compare:date2]) {
        case NSOrderedAscending:
            // dateOne is earlier in time than dateTwo
            return YES;
            break;
        case NSOrderedSame:
            // The dates are the same
            return NO;
            break;
        case NSOrderedDescending:
            // dateOne is later in time than dateTwo
            return NO;
            break;
    }
}

/**
 * @info - Given a date it will return the start- & end date of that week
 *
 * @tip - [Helpers startAndEndDateOfWeekForDate:[Helpers currentDateTime]]
 *
 * @headsUp - endDate will always be YYYY-MM-dd 23:59:59 <= Note the time
 *
 * @param {NSDate} date
 *
 * @return {NSDictionary} key's: startDate:{string}, endDate:{string}, week:{NSUInt}
 */
+(NSDictionary*) startAndEndDateOfWeekForDate:(NSDate*)date
{
    NSCalendar *gregorian = [NSCalendar currentCalendar];
    [gregorian setFirstWeekday:2]; // Monday
    [gregorian setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    
    // Get the weekday component of the current date
    NSDateComponents *weekdayComponents = [gregorian components:NSWeekdayCalendarUnit fromDate:date];
    NSDateComponents *comps = [gregorian components:NSWeekCalendarUnit fromDate:date];
    NSUInteger week = [comps week];
    /*
     Create a date components to represent the number of days to subtract
     from the current date.
     The weekday value for Sunday in the Gregorian calendar is 1, so
     subtract 1 from the number
     of days to subtract from the date in question.  (If today's Sunday,
     subtract 0 days.)
     */
    int daysInWeek = 0;
    NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
    /* Substract [gregorian firstWeekday] to handle first day of the week being something else than Sunday */
    if (week != 1) {
        daysInWeek = 7;
        [componentsToSubtract setDay: - ((([weekdayComponents weekday] - [gregorian firstWeekday])
                                       + 7 ) % daysInWeek)];
    /* If its the first week of the year it needs some love */        
    } else {
        // Standard: first day of first week is thursday e.g. 4
        daysInWeek = 4;
        [componentsToSubtract setDay: - ((([weekdayComponents weekday] - [gregorian firstWeekday])
                                          + 7 ) % daysInWeek)];
    }
    
    NSDate *beginningOfWeek = [gregorian dateByAddingComponents:componentsToSubtract toDate:date options:0];
    
    /*
     beginningOfWeek now has the same hour, minute, and second as the
     original date (today).
     To normalize to midnight, extract the year, month, and day components
     and create a new date from those components.
     */
    NSDateComponents *components = [gregorian components: (NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate: beginningOfWeek];
    beginningOfWeek = [gregorian dateFromComponents: components];
    NSDate *endOfWeek = [beginningOfWeek dateByAddingTimeInterval:(60*60*24*7)-1]; // NSLog(@"Last day of week %@", endOfWeek); //-1 => YYYY-MM-dd 23:59:59 or else it goes over to the next day.
    
    return @{@"startDate":[Helpers stringFromNSDate:beginningOfWeek], @"endDate":[Helpers stringFromNSDate:endOfWeek], @"week":@(week)};
}

/**
 * @info - Given a date it will return start date for that week
 *
 * @tip - Use with self startAndEndDateOfWeekForDate to get a "whole" week
 *
 * @headsUp - Return date will always be YYYY-MM-dd 00:00:01 <= Note the time
 *
 * @param {NSDate} date
 *
 * @return {NSDate}
 */
+(NSDate *) beginningDateOfWeek:(int)week
{
    NSDate *today = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [gregorian setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    
    NSDateComponents *comps = [gregorian components:NSYearCalendarUnit | NSWeekCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit fromDate:today];
    
    [comps setWeekday:2]; //Monday
    [comps setWeek: week];
    if (week == 1) {
        [comps setDay:1];
    }
    [comps setHour:0];
    [comps setMinute:1];
    return [gregorian dateFromComponents:comps];
}
@end
