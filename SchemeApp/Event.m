//
//  Event.m
//  SchemeApp
//
//  Created by Johan Thorell on 2013-09-10.
//  Copyright (c) 2013 Team leet. All rights reserved.
//

#import "Event.h"
#import "Helpers.h"

@implementation Event

- (NSDictionary *)asDictionary
{
    NSMutableDictionary *jsonEvent = [[NSMutableDictionary alloc]init];
    [jsonEvent setObject:self._eventWrapperId forKey:@"_id"];
    [jsonEvent setObject:self.info forKey:@"info"],
    [jsonEvent setObject:[Helpers stringFromNSDate:self.startDate] forKey:@"startDate"];
    [jsonEvent setObject:[Helpers stringFromNSDate:self.endDate] forKey:@"endDate"];
    [jsonEvent setObject:self.room forKey:@"room"];
    
    return jsonEvent;
}

@end
