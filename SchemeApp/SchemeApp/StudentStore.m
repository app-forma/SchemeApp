//
//  StudentStore.m
//  
//
//  Created by Henrik on 2013-09-09.
//
//

#import "StudentStore.h"
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
    [[Store dbConnection] readByStartDate:[Helpers stringFromNSDate:startDate] toEndDate:[Helpers stringFromNSDate:endDate] callback:^(id result) {
        
        completion(result);
        
    }];
}

#pragma mark - Extracted methods
- (NSArray *)fillListOfEventWrappersByFilteringResult:(id)result
                         withStartDate:(NSDate *)startDate
                            andEndDate:(NSDate *)endDate
{
    [self resetListOfEventWrappers];
    
    for (NSDictionary *eventWrapperDictionary in result)
    {
        BOOL eventWrapperIsOwnedByCurrentUser = [Store.mainStore.currentUser.docID isEqualToString:[eventWrapperDictionary objectForKey:@"owner"]];
        
        BOOL startDateIsEqual = [[Helpers dateFromString:[eventWrapperDictionary objectForKey:@"startDate"]] isEqualToDate:startDate];
        BOOL endDateIsEqual = [[Helpers dateFromString:[eventWrapperDictionary objectForKey:@"endDate"]] isEqualToDate:endDate];
        BOOL dateIsEqual = startDateIsEqual && endDateIsEqual;
        
        if (eventWrapperIsOwnedByCurrentUser && dateIsEqual)
        {
            [listOfEventWrappers addObject:[[EventWrapper alloc] initWithEventWrapperDictionary:eventWrapperDictionary]];
        }
    }
    
    return listOfEventWrappers;
}
- (void)resetListOfEventWrappers
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

@end
