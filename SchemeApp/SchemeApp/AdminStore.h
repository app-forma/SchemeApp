//
//  AdminStore.h
//  
//
//  Created by Henrik on 2013-09-09.
//
//

#import "StudentStore.h"

@class Event, EventWrapper, Message, User;


@interface AdminStore : StudentStore

- (void)createEvent:(Event *)event;
- (void)updateEvent:(Event *)event;
- (void)deleteEvent:(Event *)event;
- (void)createEventWrapper:(EventWrapper *)eventWrapper;
- (void)updateEventWrapper:(EventWrapper *)eventWrapper;
- (void)deleteEventWrapper:(EventWrapper *)eventWrapper;

- (NSArray *)users;
- (User *)userWithDocID:(NSString *)docID;

- (void)sendMessage:(Message *)message;
- (void)sendMessage:(Message *)message toUser:(User *)user;

@end
