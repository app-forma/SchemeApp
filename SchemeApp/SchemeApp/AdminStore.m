//
//  AdminStore.m
//  
//
//  Created by Henrik on 2013-09-09.
//
//

#warning Implement with dbConnection as instance of AFNetworking
#warning Handle error in methods where now callback:NULL

#import "AdminStore.h"
#import "Event.h"
#import "EventWrapper.h"
#import "User.h"

@class EventWrapper;


@implementation AdminStore

- (void)createEvent:(Event *)event
{
    [Store.dbConnection createType:@"events"
                       withContent:event.asDictionary
                          callback:NULL];
}
- (void)updateEvent:(Event *)event
{
    [Store.dbConnection updateType:@"events"
                       withContent:event.asDictionary
                          callback:NULL];
}
- (void)deleteEvent:(Event *)event
{
    [Store.dbConnection deleteType:@"event"
                            withId:event.docID
                          callback:NULL];
}
- (void)createEventWrapper:(EventWrapper *)eventWrapper
{
    [Store.dbConnection createType:@"eventWrappers"
                       withContent:eventWrapper.asDictionary
                          callback:NULL];
}
- (void)updateEventWrapper:(EventWrapper *)eventWrapper
{
    [Store.dbConnection updateType:@"eventWrappers"
                       withContent:eventWrapper.asDictionary
                          callback:NULL];
}
- (void)deleteEventWrapper:(EventWrapper *)eventWrapper
{
    [Store.dbConnection deleteType:@"eventWrappers"
                            withId:eventWrapper.docID
                          callback:NULL];
}

- (void)usersCompletion:(void (^)(NSArray *users))completion;
{
    [Store.dbConnection readType:@"users"
                          withId:nil
                        callback:^(id result)
     {
         completion((NSArray *)result);
     }];
}
- (void)userWithDocID:(NSString *)docID completion:(void (^)(User *user))completion
{
    [Store.dbConnection readType:@"users"
                          withId:docID
                        callback:^(id result)
     {
         completion([[User alloc] initWithUserDictionary:(NSDictionary *)result]);
     }];
}

- (void)sendMessage:(Message *)message
{
#warning Implement
    
}
- (void)sendMessage:(Message *)message toUser:(User *)user
{
    [user.messages addObject:message];
}

@end
