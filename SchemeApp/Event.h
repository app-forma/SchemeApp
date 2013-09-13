//
//  Event.h
//  SchemeApp
//
//  Created by Johan Thorell on 2013-09-10.
//  Copyright (c) 2013 Team leet. All rights reserved.
//

#import <Foundation/Foundation.h>
@class EventWrapper;
@interface Event : NSObject
@property (nonatomic, readonly) NSString *docID;
@property (nonatomic, strong) EventWrapper *_eventWrapperId;
@property (nonatomic, copy) NSString *info;
@property (nonatomic, copy) NSDate *startDate;
@property (nonatomic, copy) NSDate *endDate;
@property (nonatomic, copy) NSString *room;
- (NSDictionary *)asDictionary;
@end
