//
//  EventWrapper.h
//  SchemeApp
//
//  Created by Johan Thorell on 2013-09-10.
//  Copyright (c) 2013 Team leet. All rights reserved.
//

#import <Foundation/Foundation.h>
@class User, EventWrapper;
@interface EventWrapper : NSObject
@property (nonatomic, readonly) NSString *docID;
@property (nonatomic, copy) NSMutableArray *events;
@property (nonatomic, strong) User *user;
@property (nonatomic, copy) NSString *litterature;
@property (nonatomic, copy) NSDate *startDate;
@property (nonatomic, copy) NSDate *endDate;
@property (nonatomic, copy) NSString *name;
- (id)initWithEventWrapperDictionary:(NSDictionary *)eventWrapperDictionary;
- (NSDictionary *)asDictionary;
@end
