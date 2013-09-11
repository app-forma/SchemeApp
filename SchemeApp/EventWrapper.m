//
//  EventWrapper.m
//  SchemeApp
//
//  Created by Johan Thorell on 2013-09-10.
//  Copyright (c) 2013 Team leet. All rights reserved.
//

#import "EventWrapper.h"


@implementation EventWrapper

#warning Temporary
- (id)init
{
    self = [super init];
    if (self)
    {
        // Ska bara hämtas sen från servern
        _docID = [[NSUUID UUID] UUIDString];
    }
    return self;
}

@end
