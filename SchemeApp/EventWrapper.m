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
#import "User.h"


@implementation EventWrapper

- (id)initWithEventWrapperDictionary:(NSDictionary *)eventWrapperDictionary
{
    self = [super init];
    if (self)
    {
        self.name = [eventWrapperDictionary objectForKey:@"name"];
        self.user = [[User alloc] initWithUserDictionary:eventWrapperDictionary[@"owner"]];
        self.litterature = [eventWrapperDictionary objectForKey:@"litterature"];
        self.startDate = [Helpers dateFromString:[eventWrapperDictionary objectForKey:@"startDate"]];
        self.endDate = [Helpers dateFromString:[eventWrapperDictionary objectForKey:@"endDate"]];
        _docID = [eventWrapperDictionary objectForKey:@"_id"];
        self.events = [NSMutableArray new];
    }
    return self;
}

- (NSDictionary *)asDictionary
{
    NSMutableDictionary *jsonEventWrapper = [[NSMutableDictionary alloc]init];

#warning Testing
    NSMutableArray *jsonEvents = [[NSMutableArray alloc]init];
    [jsonEvents addObject:@"52388867469ddbc32e000002"];
//    for (Event *event in self.events) {
//        [jsonEvents addObject:event.docID];
//    }
    
    [jsonEventWrapper setObject:jsonEvents forKey:@"events"];
    [jsonEventWrapper setObject:self.user.docID forKey:@"owner"];
    [jsonEventWrapper setObject:self.litterature forKey:@"litterature"];
    [jsonEventWrapper setObject:[Helpers stringFromNSDate:self.startDate] forKey:@"startDate"];
    [jsonEventWrapper setObject:[Helpers stringFromNSDate:self.endDate] forKey:@"endDate"];
    [jsonEventWrapper setObject:self.name forKey:@"name"];
    [jsonEventWrapper setObject:self.docID forKey:@"_id"];
    
#warning Testing
    NSData *JSONData = [NSJSONSerialization dataWithJSONObject:jsonEventWrapper options:nil error:nil];
    NSLog(@"JSON: %@", [[NSString alloc] initWithData:JSONData encoding:NSUTF8StringEncoding]);
    
    return jsonEventWrapper;
}

@end
