//
//  StudentStore.m
//  
//
//  Created by Henrik on 2013-09-09.
//
//

#import "StudentStore.h"
#import "EventWrapper.h"


@implementation StudentStore

- (void)eventWrappersWithinStartDate:(NSDate *)startDate
                          andEndDate:(NSDate *)endDate
                          completion:(void (^)(NSArray *eventWrappers))handler
{
    [Store.dbSessionConnection getPath:DB_TYPE_EVENTWRAPPER
                            withParams:@{@"startDate": [Helpers stringFromNSDate:startDate],
                                         @"endDate": [Helpers stringFromNSDate:endDate]}
                         andCompletion:^(id jsonObject, id response, NSError *error)
    {
        NSMutableArray *eventWrappers = NSMutableArray.array;
        
        if (error)
        {
            NSLog(@"eventWrappersWithinStartDate:andEndDate:completion: got response: %@ and error: %@", response, error.userInfo);
        }
        else
        {
            for (NSDictionary *eventWrapperDictionary in jsonObject)
            {
                [eventWrappers addObject:[[EventWrapper alloc] initWithEventWrapperDictionary:eventWrapperDictionary]];
            }
        }
        
        handler(eventWrappers);
    }];
}

@end
