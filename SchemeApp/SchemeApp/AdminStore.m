//
//  AdminStore.m
//  
//
//  Created by Henrik on 2013-09-09.
//
//

#warning Handle error in methods where now callback:NULL

#import "AdminStore.h"
#import "Event.h"
#import "EventWrapper.h"
#import "User.h"
#import "Message.h"


@implementation AdminStore

- (void)eventWrappersCompletion:(void (^)(NSArray *allEventWrappers))completion
{
    [Store.dbConnection readType:DB_TYPE_EVENTWRAPPER
                          withId:nil
                        callback:^(id result)
     {
         NSMutableArray *allEventWrappers = [NSMutableArray array];
         for (NSDictionary *eventWrapperDictionary in result)
         {
             EventWrapper *ew = [[EventWrapper alloc] initWithEventWrapperDictionary:eventWrapperDictionary];
             [allEventWrappers addObject:ew];
         }
         completion(allEventWrappers);
     }];
}

- (void)createEvent:(Event *)event completion:(void (^)(id result))completion
{
    [Store.dbConnection createType:DB_TYPE_EVENT
                       withContent:event.asDictionary
                          callback:^(id result)
     {
         completion(result);
     }];
}
- (void)updateEvent:(Event *)event completion:(void (^)(id result))completion
{
    [Store.dbConnection updateType:DB_TYPE_EVENT
                       withContent:event.asDictionary
                          callback:^(id result)
     {
         completion(result);
     }];
}
- (void)deleteEvent:(Event *)event completion:(void (^)(id result))completion
{
    [Store.dbConnection deleteType:DB_TYPE_EVENT
                            withId:event.docID
                          callback:^(id result)
     {
         completion(result);
     }];
}
- (void)createEventWrapper:(EventWrapper *)eventWrapper completion:(void (^)(id result))completion
{
    [Store.dbConnection createType: DB_TYPE_EVENTWRAPPER
                       withContent:eventWrapper.asDictionary
                          callback:^(id result)
     {
         completion(result);
     }];
}
- (void)updateEventWrapper:(EventWrapper *)eventWrapper completion:(void (^)(id result))completion
{
    [Store.dbConnection updateType:DB_TYPE_EVENTWRAPPER
                       withContent:eventWrapper.asDictionary
                          callback:^(id result)
     {
         completion(result);
     }];
}
- (void)deleteEventWrapper:(EventWrapper *)eventWrapper completion:(void (^)(id result))completion
{
    [Store.dbConnection deleteType: DB_TYPE_EVENTWRAPPER
                            withId:eventWrapper.docID
                          callback:^(id result)
     {
         completion(result);
     }];
}

- (void)usersCompletion:(void (^)(NSArray *allUsers))completion
{
    [Store.dbConnection readType:DB_TYPE_USER
                          withId:nil
                        callback:^(id result)
     {
         NSMutableArray *userModels = [[NSMutableArray alloc] init];
         for (NSDictionary *userDictionary in result)
         {
             [userModels addObject:[[User alloc] initWithUserDictionary:userDictionary]];
         }
         
         completion(userModels);
     }];
}
- (void)userWithDocID:(NSString *)docID completion:(void (^)(User *user))completion
{
    [Store.dbConnection readType:DB_TYPE_USER
                          withId:docID
                        callback:^(id result)
     {
         completion([[User alloc] initWithUserDictionary:(NSDictionary *)result]);
     }];
}
- (void)userWithType:(RoleType)type completion:(void (^)(NSArray *students))completion
{
    [Store.dbConnection readType:DB_TYPE_USER
                          withId:nil
                        callback:^(id result)
     {
         NSMutableArray *studentModels = [[NSMutableArray alloc] init];
         for (NSDictionary *userDictionary in result)
         {
#warning Comment
//TODO: Replace @"student" with role type
             if ([[userDictionary objectForKey:@"role"] isEqualToString:@"student"])
             {
                 [studentModels addObject:[[User alloc] initWithUserDictionary:userDictionary]];
             }
         }
         
         completion(studentModels);
     }];
}


#pragma mark - messaging methods
- (void)broadcastMessage:(Message *)message completion:(void (^)(Message *message))completion
{
    [Store.dbConnection createType:DB_TYPE_BROADCAST_MESSAGE withContent:[message asDictionary] callback:^(id result) {
        completion([[Message alloc]initWithMsgDictionary:result]);
    }];    
}
- (void)sendMessage:(Message *)message toUsers:(NSArray *)users completion:(void (^)(Message *message))completion
{
    NSMutableDictionary *jsonMessage = [NSMutableDictionary dictionaryWithDictionary:[message asDictionary]];
    NSMutableArray *receivers = [NSMutableArray new];
    for (User *user in users) {
        [receivers addObject:user.docID];
    }
    [jsonMessage setObject:receivers forKey:@"receivers"];
    
    [[Store dbConnection]createType:DB_TYPE_MESSAGE withContent:jsonMessage callback:^(id result) {
        completion([[Message alloc]initWithMsgDictionary:result]);
    }];
}

- (void)updateMessages:(NSArray*)messages forUser:(User*)user
{
    NSMutableArray *messageIds = [NSMutableArray new];
    for (Message *message in messages) {
        [messageIds addObject:message.docID];
    }
    [[Store dbConnection]updateType:DB_TYPE_USER withContent:[NSDictionary dictionaryWithObjects:@[user.docID, messageIds] forKeys:@[@"_id", @"messages"]] callback:nil];
}
@end
