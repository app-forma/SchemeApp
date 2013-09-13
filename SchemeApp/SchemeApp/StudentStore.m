//
//  StudentStore.m
//  
//
//  Created by Henrik on 2013-09-09.
//
//

#import "StudentStore.h"
#import "AFNetworking.h"
#import "Event.h"
#import "EventWrapper.h"


@implementation StudentStore

- (EventWrapper *)eventWrapperWithStartDate:(NSDate *)startDate andEndDate:(NSDate *)endDate
{
#warning Implement
    AFNetworking *networker = [[AFNetworking alloc] init];
    
    [networker readType:@"eventWrappers"
                 withId:nil
               callback:^(NSDictionary *result)
    {
#warning Comment
        // Filtrera alla eventrappers

    }];
    
    return nil;
}

@end
