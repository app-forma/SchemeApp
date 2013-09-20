//
//  AdminStore.m
//  
//
//  Created by Henrik on 2013-09-09.
//
//

#import "AdminStore.h"
#import "Event.h"
#import "EventWrapper.h"
#import "User.h"
#import "Message.h"


@implementation AdminStore

#pragma mark - Event and EventWrappers
- (void)createEvent:(Event *)event completion:(completion)handler
{
    [Store.dbSessionConnection postContent:event.asDictionary
                                    toPath:DB_TYPE_EVENT
                            withCompletion:^(id jsonObject, id response, NSError *error)
     {
         handler(jsonObject, response, error);
     }];
}
- (void)updateEvent:(Event *)event completion:(completion)handler
{
    [Store.dbSessionConnection putContent:event.asDictionary
                                   toPath:DB_TYPE_EVENT
                           withCompletion:^(id jsonObject, id response, NSError *error)
     {
         handler(jsonObject, response, error);
     }];
}
- (void)deleteEvent:(Event *)event completion:(completion)handler
{
    [Store.dbSessionConnection deletePath:[NSString stringWithFormat:@"%@/%@", DB_TYPE_EVENT, event.docID]
                           withCompletion:^(id jsonObject, id response, NSError *error)
     {
         handler(jsonObject, response, error);
     }];
}
- (void)eventWrappersCompletion:(void (^)(NSArray *allEventWrappers))handler
{
    [Store.dbSessionConnection getPath:DB_TYPE_EVENTWRAPPER
                            withParams:nil
                         andCompletion:^(id jsonObject, id response, NSError *error)
     {
         NSMutableArray *collectedEventWrappers = NSMutableArray.array;
         
         if (error)
         {
             NSLog(@"eventWrappersCompletion: got response: %@ and error: %@", response, error.userInfo);
             collectedEventWrappers = nil;
         }
         else
         {
             for (NSDictionary *eventWrapperDictionary in jsonObject)
             {
                 [collectedEventWrappers addObject:[[EventWrapper alloc] initWithEventWrapperDictionary:eventWrapperDictionary]];
             }
             
         }
         
         handler(collectedEventWrappers);
     }];
}
- (void)createEventWrapper:(EventWrapper *)eventWrapper completion:(completion)handler
{
    [Store.dbSessionConnection postContent:eventWrapper.asDictionary
                                    toPath:DB_TYPE_EVENTWRAPPER
                            withCompletion:^(id jsonObject, id response, NSError *error)
     {
         handler(jsonObject, response, error);
     }];
}
- (void)updateEventWrapper:(EventWrapper *)eventWrapper completion:(completion)handler
{
    [Store.dbSessionConnection putContent:eventWrapper.asDictionary
                                   toPath:[NSString stringWithFormat:@"%@/%@", DB_TYPE_EVENTWRAPPER, eventWrapper.docID]
                           withCompletion:^(id jsonObject, id response, NSError *error)
     {
         handler(jsonObject, response, error);
     }];
}
- (void)deleteEventWrapper:(EventWrapper *)eventWrapper completion:(completion)handler
{
    [Store.dbSessionConnection deletePath:[NSString stringWithFormat:@"%@/%@", DB_TYPE_EVENTWRAPPER, eventWrapper.docID]
                           withCompletion:^(id jsonObject, id response, NSError *error)
     {
         handler(jsonObject, response, error);
     }];
}

#pragma mark - Users
- (void)usersCompletion:(void (^)(NSArray *allUsers))handler
{
    [Store.dbSessionConnection getPath:DB_TYPE_USER
                            withParams:nil
                         andCompletion:^(id jsonObject, id response, NSError *error)
    {
        NSMutableArray *collectedUsers = NSMutableArray.array;

        if (error)
        {
            NSLog(@"usersCompletion: got response: %@ and error: %@", response, error.userInfo);
        }
        else
        {
            for (NSDictionary *userDictionary in jsonObject)
            {
                [collectedUsers addObject:[[User alloc] initWithUserDictionary:userDictionary]];
            }
        }
        
        handler(collectedUsers);
    }];
}
- (void)userWithDocID:(NSString *)docID completion:(void (^)(User *user))handler
{
    [Store.dbSessionConnection getPath:[NSString stringWithFormat:@"%@/%@", DB_TYPE_USER, docID]
                            withParams:nil
                         andCompletion:^(id jsonObject, id response, NSError *error)
     {
         if (error)
         {
             NSLog(@"userWithDocID:completion: got response: %@ and error: %@", response, error.userInfo);
             handler(nil);
         }
         else
         {
             handler([[User alloc] initWithUserDictionary:jsonObject]);
         }
     }];
}
- (void)userWithType:(RoleType)type completion:(void (^)(NSArray *users))handler
{
    [Store.dbSessionConnection getPath:DB_TYPE_USER
                            withParams:nil
                         andCompletion:^(id jsonObject, id response, NSError *error)
     {
         NSMutableArray *collectedUsers = NSMutableArray.array;
         
         if (error)
         {
             NSLog(@"userWithType:completion: got response: %@ and error: %@", response, error.userInfo);
         }
         else
         {
             for (NSDictionary *userDictionary in jsonObject)
             {
#warning Should implement filtering function on backend instead
                 if ([[userDictionary objectForKey:@"role"] isEqualToString:[User stringFromRoleType:type]])
                 {
                     [collectedUsers addObject:[[User alloc] initWithUserDictionary:userDictionary]];
                 }
             }
         }
         
         handler(collectedUsers);
     }];
}


#pragma mark - Messages
- (void)messagesCompletion:(void (^)(NSArray *allMessages))handler
{
    [Store.dbSessionConnection getPath:DB_TYPE_MESSAGE
                            withParams:nil
                         andCompletion:^(id jsonObject, id response, NSError *error)
    {
        NSMutableArray *collectedMessages = NSMutableArray.array;
        
        if (error)
        {
            NSLog(@"messagesCompletion: got response: %@ and error: %@", response, error.userInfo);
        }
        else
        {
            for (NSDictionary *messageDictionary in jsonObject)
            {
                [collectedMessages addObject:[[Message alloc] initWithMsgDictionary:messageDictionary]];
            }
        }
        
        handler(collectedMessages);
    }];
}
- (void)broadcastMessage:(Message *)message completion:(void (^)(Message *message))handler
{
    [Store.dbSessionConnection postContent:message.asDictionary
                                    toPath:[NSString stringWithFormat:@"%@/broadcast", DB_TYPE_MESSAGE]
                            withCompletion:^(id jsonObject, id response, NSError *error)
     {
         if (error)
         {
             NSLog(@"broadCastMessage got response: %@ and error: %@", jsonObject, error.userInfo);
             handler(nil);
         }
         else
         {
             handler([[Message alloc] initWithMsgDictionary:jsonObject]);
         }
     }];
}
- (void)sendMessage:(Message *)message toUsers:(NSArray *)users completion:(void (^)(Message *message))handler
{
    NSMutableDictionary *jsonMessage = [NSMutableDictionary dictionaryWithDictionary:message.asDictionary];
    
    NSMutableArray *receivers = [NSMutableArray new];
    for (User *user in users) {
        [receivers addObject:user.docID];
    }
    [jsonMessage setObject:receivers forKey:@"receivers"];
    
    [Store.dbSessionConnection postContent:jsonMessage
                                    toPath:DB_TYPE_MESSAGE
                            withCompletion:^(id jsonObject, id response, NSError *error)
     {
         if (error)
         {
             NSLog(@"sendMessage:toUsers:completion: got response: %@ and error: %@", jsonObject, error.userInfo);
             handler(nil);
         }
         else
         {
             NSLog(@"%@", jsonObject);
             handler([[Message alloc]initWithMsgDictionary:jsonObject]);
         }
     }];
}
- (void)updateMessages:(NSArray*)messages forUser:(User*)user
{
    NSMutableArray *messageIds = [NSMutableArray new];
    for (Message *message in messages) {
        [messageIds addObject:message.docID];
    }
    NSDictionary *json = [NSDictionary dictionaryWithObject:messageIds forKey:@"messages"];
    
    [Store.dbSessionConnection putContent:json
                                   toPath:[NSString stringWithFormat:@"%@/%@", DB_TYPE_USER, user.docID]
                           withCompletion:^(id jsonObject, id response, NSError *error)
    {
        if (error)
        {
            NSLog(@"sendMessage:toUsers:completion: got response: %@ and error: %@", jsonObject, error.userInfo);
        }
    }];
}

@end
