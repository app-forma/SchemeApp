//
//  StudentStore.m
//  
//
//  Created by Henrik on 2013-09-09.
//
//

#import "StudentStore.h"
#import "EventWrapper.h"
#import "Event.h"


@implementation StudentStore
{
    EventWrapper *eventWrapper;
}

- (EventWrapper *)eventWrapperWithStartDate:(NSDate *)startDate andEndDate:(NSDate *)endDate
{
#warning Implement
    eventWrapper = [[EventWrapper alloc] init];
    
    eventWrapper.events = self.dummyEvents;
    eventWrapper.user = Store.mainStore.currentUser;
    eventWrapper.litterature = @"Dummyläsanvising nummer 1. Dummyläsanvisning nummer 2";
    eventWrapper.startDate = startDate;
    eventWrapper.endDate = endDate;
    
    return eventWrapper;
}

#pragma mark - Queries
#warning Dummy
- (NSArray *)dummyEvents
{
    return @[self.createDummyEvent, self.createDummyEvent, self.createDummyEvent, self.createDummyEvent];
}

#pragma mark - Extracted methods
#warning Dummy
- (Event *)createDummyEvent
{
    Event *event = [[Event alloc] init];
    
    event._eventWrapperId = eventWrapper;
    event.info = @"Dummyinfo 1. Dummyinfo 2."
    event.startDate = 
    
    return event;
}

@end
