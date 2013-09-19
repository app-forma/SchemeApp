//
//  StudentStore.h
//  
//
//  Created by Henrik on 2013-09-09.
//
//

#define DB_TYPE_EVENTWRAPPER @"eventWrappers"

#import "Store.h"

@class EventWrapper;


@interface StudentStore : NSObject

- (void)eventWrappersWithinStartDate:(NSDate *)startDate
                          andEndDate:(NSDate *)endDate
                          completion:(void (^)(NSArray *eventWrappers))handler;

@end
