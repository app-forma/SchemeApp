//
//  StudentStore.m
//  
//
//  Created by Henrik on 2013-09-09.
//
//

#import "StudentStore.h"
#import "AFNetworking.h"
#import "EventWrapper.h"
#import "Helpers.h"
#import "User.h"


@implementation StudentStore
{
    NSMutableArray *listOfEventWrappers;
}

- (void)eventWrappersWithStartDate:(NSDate *)startDate
                        andEndDate:(NSDate *)endDate
                        completion:(void (^)(NSArray *eventWrappers))completion
{
    AFNetworking *networker = [[AFNetworking alloc] init];
    
    [networker readType:@"eventWrappers"
                 withId:nil
               callback:^(id result)
    {
        [self fillListOfEventWrappersByFilteringResult:result withStartDate:startDate andEndDate:endDate];
        completion(listOfEventWrappers);
    }];
}

#pragma mark - Extracted methods
- (NSArray *)fillListOfEventWrappersByFilteringResult:(id)result
                         withStartDate:(NSDate *)startDate
                            andEndDate:(NSDate *)endDate
{
    [self resetEventWrapperList];
    
    for (NSDictionary *eventWrapperDictionary in result)
    {
        BOOL eventWrapperIsOwnedByCurrentUser = [Store.mainStore.currentUser.docID isEqualToString:[eventWrapperDictionary objectForKey:@"owner"]];
        
        BOOL startDateIsEqual = [[Helpers dateFromString:[eventWrapperDictionary objectForKey:@"startDate"]] isEqualToDate:startDate];
        BOOL endDateIsEqual = [[Helpers dateFromString:[eventWrapperDictionary objectForKey:@"endDate"]] isEqualToDate:endDate];
        BOOL dateIsEqual = startDateIsEqual && endDateIsEqual;
        
        if (eventWrapperIsOwnedByCurrentUser && dateIsEqual)
        {
            [listOfEventWrappers addObject:[self createEventWrapperOfDictionary:eventWrapperDictionary]];
        }
    }
    
    return listOfEventWrappers;
}
- (void)resetEventWrapperList
{
    if (listOfEventWrappers == nil)
    {
        listOfEventWrappers = [[NSMutableArray alloc] init];
    }
    else
    {
        [listOfEventWrappers removeAllObjects];
    }
}
- (EventWrapper *)createEventWrapperOfDictionary:(NSDictionary *)eventWrapperDictionary
{
    EventWrapper *eventWrapper = [[EventWrapper alloc] init];
    
    eventWrapper.name = [eventWrapperDictionary objectForKey:@"name"];
    eventWrapper.user = Store.mainStore.currentUser;
    eventWrapper.litterature = [eventWrapperDictionary objectForKey:@"litterature"];
    eventWrapper.startDate = [Helpers dateFromString:[eventWrapperDictionary objectForKey:@"startDate"]];
    eventWrapper.endDate = [Helpers dateFromString:[eventWrapperDictionary objectForKey:@"endDate"]];
    eventWrapper.docID = [eventWrapperDictionary objectForKey:@"_id"];
    eventWrapper.events = [eventWrapperDictionary objectForKey:@"events"];
    
    return eventWrapper;
}

@end
