//
//  AdminStore.h
//  
//
//  Created by Henrik on 2013-09-09.
//
//

#define DB_TYPE_EVENT @"events"
#define DB_TYPE_USER @"users"
#define DB_TYPE_BROADCAST_MESSAGE @"messages/broadcast"
#define DB_TYPE_MESSAGE @"messages"

#import "StudentStore.h"

#warning Temporary
// Should not be needed to import RoleType
#import "RoleType"

@class Event, EventWrapper, Message, User;


@interface AdminStore : StudentStore

- (void)eventWrappersCompletion:(void (^)(NSArray *allEventWrappers))handler;

- (void)createEvent:(Event *)event completion:(completion)handler;
- (void)updateEvent:(Event *)event completion:(completion)handler;
- (void)deleteEvent:(Event *)event completion:(completion)handler;
- (void)createEventWrapper:(EventWrapper *)eventWrapper completion:(completion)handler;
- (void)updateEventWrapper:(EventWrapper *)eventWrapper completion:(completion)handler;
- (void)deleteEventWrapper:(EventWrapper *)eventWrapper completion:(completion)handler;

- (void)usersCompletion:(void (^)(NSArray *allUsers))handler;
- (void)userWithDocID:(NSString *)docID completion:(void (^)(User *user))handler;
- (void)userWithType:(RoleType)type completion:(void (^)(NSArray *users))handler;

- (void)broadcastMessage:(Message *)message completion:(void (^)(Message *message))handler;
- (void)sendMessage:(Message *)message toUsers:(NSArray *)users completion:(void (^)(Message *message))handler;
- (void)updateMessages:(NSArray*)messages forUser:(User*)user;

@end
