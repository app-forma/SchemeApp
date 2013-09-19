//
//  Event.h
//  SchemeApp
//
//  Created by Johan Thorell on 2013-09-10.
//  Copyright (c) 2013 Team leet. All rights reserved.
//

#import <Foundation/Foundation.h>
@class EventWrapper, Event;
@interface Event : NSObject
@property (nonatomic, readonly) NSString *docID;
@property (nonatomic, copy) NSString *info;
@property (nonatomic, copy) NSDate *startDate;
@property (nonatomic, copy) NSDate *endDate;
@property (nonatomic, copy) NSString *room;
-(id)initWithEventDictionary:(NSDictionary *)dic;
- (NSDictionary *)asDictionary;

@end
