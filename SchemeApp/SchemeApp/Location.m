//
//  Location.m
//  SchemeApp
//
//  Created by Henrik on 2013-09-25.
//  Copyright (c) 2013 Team leet. All rights reserved.
//

#import "Location.h"


@implementation Location

- (id)initWithLocationDictionary:(NSDictionary *)locationDictionary
{
    self = [super init];
    if (self)
    {
        _docID = locationDictionary[@"_id"];
        _name = locationDictionary[@"name"];
        _latitude = locationDictionary[@"latitude"];
        _longitude = locationDictionary[@"longitude"];
    }
    return self;
}

- (NSDictionary *)asDictionary
{
    NSMutableDictionary *jsonLocation = [[NSMutableDictionary alloc] init];
    
    [jsonLocation setObject:self.name forKey:@"name"];
    [jsonLocation setObject:self.latitude forKey:@"latitude"];
    [jsonLocation setObject:self.longitude forKey:@"longitude"];
    
    if (self.docID)
    {
        [jsonLocation setObject:self.docID forKey:@"_id"];
    }
    
    return jsonLocation;
}

@end
