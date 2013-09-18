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

- (void)eventWrappersCompletion:(void (^)(NSArray *allEventWrappers))completion;

- (void)createEvent:(Event *)event completion:(void (^)(id result))completion;
- (void)updateEvent:(Event *)event completion:(void (^)(id result))completion;
- (void)deleteEvent:(Event *)event completion:(void (^)(id result))completion;
- (void)createEventWrapper:(EventWrapper *)eventWrapper completion:(void (^)(id result))completion;
- (void)updateEventWrapper:(EventWrapper *)eventWrapper completion:(void (^)(id result))completion;
- (void)deleteEventWrapper:(EventWrapper *)eventWrapper completion:(void (^)(id result))completion;

- (void)usersCompletion:(void (^)(NSArray *allUsers))completion;
- (void)userWithDocID:(NSString *)docID completion:(void (^)(User *user))completion;
- (void)userWithType:(RoleType)type completion:(void (^)(NSArray *students))completion;

- (void)broadcastMessage:(Message *)message completion:(void (^)(Message *message))completion;
- (void)sendMessage:(Message *)message toUsers:(NSArray *)users completion:(void (^)(Message *message))completion;


@end
