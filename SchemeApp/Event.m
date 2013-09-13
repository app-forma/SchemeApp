//
//  Event.m
//  SchemeApp
//
//  Created by Johan Thorell on 2013-09-10.
//  Copyright (c) 2013 Team leet. All rights reserved.
//

#import "Event.h"

@implementation Event

- (NSDictionary *)asDictionary
{
    NSMutableDictionary *eventDictionary = [[NSMutableDictionary alloc] init];
    
    [eventDictionary setObject:self.info forKey:@"info"];
    [eventDictionary setObject:[Helpers stringFromNSDate:self.startDate] forKey:@"startDate"];
    [eventDictionary setObject:[Helpers stringFromNSDate:self.endDate] forKey:@"endDate"];
    [eventDictionary setObject:self.room forKey:@"room"];
    [eventDictionary setObject:self.docID forKey:@"_id"];
    
    return eventDictionary;
}

@end
