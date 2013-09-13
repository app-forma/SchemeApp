//
//  EventWrapper.m
//  SchemeApp
//
//  Created by Johan Thorell on 2013-09-10.
//  Copyright (c) 2013 Team leet. All rights reserved.
//

#import "EventWrapper.h"
#import "Helpers.h"
#import "Event.h"

@implementation EventWrapper

- (id)initWithEventWrapperDictionary:(NSDictionary *)eventWrapperDictionary
{
    self = [super init];
    if (self)
    {
        self.name = [eventWrapperDictionary objectForKey:@"name"];
        self.user = Store.mainStore.currentUser;
        self.litterature = [eventWrapperDictionary objectForKey:@"litterature"];
        self.startDate = [Helpers dateFromString:[eventWrapperDictionary objectForKey:@"startDate"]];
        self.endDate = [Helpers dateFromString:[eventWrapperDictionary objectForKey:@"endDate"]];
        _docID = [eventWrapperDictionary objectForKey:@"_id"];
        self.events = [eventWrapperDictionary objectForKey:@"events"];
    }
    return self;
}

- (NSDictionary *)asDictionary
{
    NSMutableDictionary *eventWrapperDictionary = [[NSMutableDictionary alloc] init];
    NSMutableArray *events = [[NSMutableArray alloc] init];
    
    [eventWrapperDictionary setObject:self.name forKey:@"name"];
    [eventWrapperDictionary setObject:self.user.docID forKey:@"owner"];
    [eventWrapperDictionary setObject:self.litterature forKey:@"litterature"];
    [eventWrapperDictionary setObject:[Helpers stringFromNSDate:self.startDate] forKey:@"startDate"];
    [eventWrapperDictionary setObject:[Helpers stringFromNSDate:self.endDate] forKey:@"endDate"];
    [eventWrapperDictionary setObject:self.docID forKey:@"_id"];
    
    for (Event *event in self.events) {
        [events addObject:event.docID];
    }
    
    [eventWrapperDictionary setObject:events forKey:@"events"];
    
    return eventWrapperDictionary;
}

@end
