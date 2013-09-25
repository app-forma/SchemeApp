//
//  StudentStore.m
//  
//
//  Created by Henrik on 2013-09-09.
//
//

#import "StudentStore.h"
#import "EventWrapper.h"
#import "Message.h"


@implementation StudentStore

- (void)eventWrappersWithinStartDate:(NSDate *)startDate
                          andEndDate:(NSDate *)endDate
                          completion:(void (^)(NSArray *eventWrappers))handler
{
    [Store.dbSessionConnection getPath:DB_TYPE_EVENTWRAPPER
                            withParams:@{@"startDate": [Helpers stringFromNSDate:startDate],
                                         @"endDate": [Helpers stringFromNSDate:endDate]}
                         andCompletion:^(id responseBody, id response, NSError *error)
    {
        NSMutableArray *eventWrappers = NSMutableArray.array;
        
        if (error)
        {
            NSLog(@"eventWrappersWithinStartDate:andEndDate:completion: got response: %@ and error: %@", response, error.userInfo);
        }
        else
        {
            for (NSDictionary *eventWrapperDictionary in responseBody)
            {
                [eventWrappers addObject:[[EventWrapper alloc] initWithEventWrapperDictionary:eventWrapperDictionary]];
            }
        }
        
        handler(eventWrappers);
    }];
}

- (void)messageWithDocID:(NSString *)docID completion:(void (^)(Message *message))handler
{
    [Store.dbSessionConnection getPath:[NSString stringWithFormat:@"%@/%@", DB_TYPE_MESSAGE, docID]
                            withParams:nil
                         andCompletion:^(id responseBody, id response, NSError *error)
     {
         if (error)
         {
             NSLog(@"messageWithDocID:completion: got response: %@ and error: %@", response, error.userInfo);
             handler(nil);
         }
         else
         {
             handler([[Message alloc] initWithMsgDictionary:responseBody]);
         }
     }];
}

@end
