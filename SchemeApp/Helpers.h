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
@end
