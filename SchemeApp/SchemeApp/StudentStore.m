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

#warning Comment
// we should fetch all eventwrappers for a certain student? /Henrik
- (void)eventWrappersWithStartDate:(NSDate *)startDate
                        andEndDate:(NSDate *)endDate
                        completion:(void (^)(NSArray *eventWrappers))completion
{
    [[Store dbConnection] readByStartDate:[Helpers stringFromNSDate:startDate] toEndDate:[Helpers stringFromNSDate:endDate] callback:^(id result) {
#warning Implement
        // Create an array with eventWrapper objects of results and send with completion
        completion(result);
        
    }];
}

@end
