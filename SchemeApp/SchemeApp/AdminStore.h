//
//  AdminStore.h
//  
//
//  Created by Henrik on 2013-09-09.
//
//

#define DB_TYPE_EVENT @"events"
#define DB_TYPE_USER @"users"

#import "StudentStore.h"

#warning Temporary
// Should not be needed to import RoleType
#import "RoleType"

@class Event, EventWrapper, Message, User;


@interface AdminStore : StudentStore

- (void)createEvent:(Event *)event;
- (void)updateEvent:(Event *)event;
- (void)deleteEvent:(Event *)event;
- (void)createEventWrapper:(EventWrapper *)eventWrapper;
- (void)updateEventWrapper:(EventWrapper *)eventWrapper;
- (void)deleteEventWrapper:(EventWrapper *)eventWrapper;

- (void)usersCompletion:(void (^)(NSArray *allUsers))completion;
- (void)userWithDocID:(NSString *)docID completion:(void (^)(User *user))completion;
- (void)userWithType:(RoleType)type completion:(void (^)(NSArray *students))completion;

- (void)sendMessage:(Message *)message;
- (void)sendMessage:(Message *)message toUser:(User *)user;

@end
