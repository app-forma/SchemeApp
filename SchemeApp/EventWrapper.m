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
#warning Implement
    
    
    // Ska göras om till dictionary när wrappers ska skapas eller uppdateras i databasen
    return nil;
}

@end
