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
#define DB_TYPE_LOCATION @"locations"

#import "StudentStore.h"

@class Event, EventWrapper, Message, User, Location;


@interface AdminStore : StudentStore

- (void)eventWrappersCompletion:(void (^)(NSArray *allEventWrappers))handler;
- (void)eventsCompletion:(void (^)(NSArray *allEventWrappers))handler;
- (void)eventWithDocID:(NSString *)docID completion:(void (^)(Event *event))handler;

- (void)deleteAttendanceDate:(NSDate *)date forStudent:(User *)student completion:(void (^)(BOOL success))handler;

#pragma mark - Event and EventWrappers CRUD
- (void)createEvent:(Event *)event completion:(completion)handler;
- (void)updateEvent:(Event *)event completion:(completion)handler;
- (void)deleteEvent:(Event *)event completion:(completion)handler;
- (void)createEventWrapper:(EventWrapper *)eventWrapper completion:(completion)handler;
- (void)updateEventWrapper:(EventWrapper *)eventWrapper completion:(completion)handler;
- (void)deleteEventWrapper:(EventWrapper *)eventWrapper completion:(completion)handler;

#pragma mark - Users
- (void)usersCompletion:(void (^)(NSArray *allUsers))handler;
- (void)userWithDocID:(NSString *)docID completion:(void (^)(User *user))handler;
- (void)userWithType:(RoleType)type completion:(void (^)(NSArray *users))handler;

#pragma mark - Messages
- (void)broadcastMessage:(Message *)message completion:(void (^)(Message *message))handler;
- (void)sendMessage:(Message *)message completion:(void (^)(Message *message))handler;

#pragma mark - Location
- (void)createLocation:(Location *)location completion:(void (^)(Location *location))handler;
- (void)updateLocation:(Location *)location completion:(void (^)(Location *location))handler;
- (void)deleteLocation:(Location *)location completion:(void (^)(BOOL success))handler;

@end
