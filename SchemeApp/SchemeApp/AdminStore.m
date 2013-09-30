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
#import "Location.h"
#import "NSDate+Helpers.h"

@implementation AdminStore

- (void)eventWrappersCompletion:(void (^)(NSArray *allEventWrappers))handler
{
    [Store.dbSessionConnection getPath:DB_TYPE_EVENTWRAPPER
                            withParams:nil
                         andCompletion:^(id responseBody, id response, NSError *error)
     {
         NSMutableArray *collectedEventWrappers = NSMutableArray.array;
         
         if (error)
         {
             NSLog(@"eventWrappersCompletion: got response: %@ and error: %@", response, error.userInfo);
             collectedEventWrappers = nil;
         }
         else
         {
             for (NSDictionary *eventWrapperDictionary in responseBody)
             {
                 [collectedEventWrappers addObject:[[EventWrapper alloc] initWithEventWrapperDictionary:eventWrapperDictionary]];
             }
             
         }
         
         handler(collectedEventWrappers);
     }];
}
- (void)eventsCompletion:(void (^)(NSArray *allEventWrappers))handler
{
#warning Implement
    
}
- (void)eventWithDocID:(NSString *)docID completion:(void (^)(Event *event))handler
{
    [Store.dbSessionConnection getPath:[NSString stringWithFormat:@"%@/%@", DB_TYPE_EVENT, docID]
                            withParams:nil
                         andCompletion:^(id responseBody, id response, NSError *error)
     {
         if (error)
         {
             NSLog(@"eventWithDocID:completion: got response: %@ and error: %@", response, error.userInfo);
             handler(nil);
         }
         else
         {
             handler([[Event alloc] initWithEventDictionary:responseBody]);
         }
     }];
}

- (void)deleteAttendanceDate:(NSDate *)date forStudent:(User *)student completion:(void (^)(BOOL success))handler
{
    NSString *path = [NSString stringWithFormat:@"%@/%@/attendance/%@", DB_TYPE_USER, student.docID, date.asDateString];
    
    [Store.dbSessionConnection deletePath:path
                           withCompletion:^(id responseBody, id response, NSError *error)
    {
        if (error)
        {
            NSLog(@"[%@] deleteAttendanceDate:forStudent:completion: got response: %@ and error: %@", self.class, response, error.userInfo);
            handler(NO);
        }
        else
        {
            handler(YES);
        }
    }];
}

#pragma mark - Event and EventWrappers CRUD
- (void)createEvent:(Event *)event completion:(completion)handler
{
    [Store.dbSessionConnection postContent:event.asDictionary
                                    toPath:DB_TYPE_EVENT
                            withCompletion:^(id responseBody, id response, NSError *error)
     {
#warning Should return model not responseBody
         handler(responseBody, response, error);
     }];
}
- (void)updateEvent:(Event *)event completion:(completion)handler
{
    [Store.dbSessionConnection putContent:event.asDictionary
                                   toPath:[NSString stringWithFormat:@"%@/%@", DB_TYPE_EVENT, event.docID]
                           withCompletion:^(id responseBody, id response, NSError *error)
     {
#warning Should return model not responseBody
         handler(responseBody, response, error);
     }];
}
- (void)deleteEvent:(Event *)event completion:(completion)handler
{
    [Store.dbSessionConnection deletePath:[NSString stringWithFormat:@"%@/%@", DB_TYPE_EVENT, event.docID]
                           withCompletion:^(id responseBody, id response, NSError *error)
     {
#warning Should return model not responseBody
         handler(responseBody, response, error);
     }];
}
- (void)createEventWrapper:(EventWrapper *)eventWrapper completion:(completion)handler
{
    [Store.dbSessionConnection postContent:eventWrapper.asDictionary
                                    toPath:DB_TYPE_EVENTWRAPPER
                            withCompletion:^(id responseBody, id response, NSError *error)
     {
#warning Should return model not responseBody
         handler(responseBody, response, error);
     }];
}
- (void)updateEventWrapper:(EventWrapper *)eventWrapper completion:(completion)handler
{
    [Store.dbSessionConnection putContent:eventWrapper.asDictionary
                                   toPath:[NSString stringWithFormat:@"%@/%@", DB_TYPE_EVENTWRAPPER, eventWrapper.docID]
                           withCompletion:^(id responseBody, id response, NSError *error)
     {
#warning Should return model not responseBody
         handler(responseBody, response, error);
     }];
}
- (void)deleteEventWrapper:(EventWrapper *)eventWrapper completion:(completion)handler
{
    [Store.dbSessionConnection deletePath:[NSString stringWithFormat:@"%@/%@", DB_TYPE_EVENTWRAPPER, eventWrapper.docID]
                           withCompletion:^(id responseBody, id response, NSError *error)
     {
#warning Should return model not responseBody
         handler(responseBody, response, error);
     }];
}

#pragma mark - Users
- (void)usersCompletion:(void (^)(NSArray *allUsers))handler
{
    [Store.dbSessionConnection getPath:DB_TYPE_USER
                            withParams:nil
                         andCompletion:^(id responseBody, id response, NSError *error)
    {
        NSMutableArray *collectedUsers = NSMutableArray.array;

        if (error)
        {
            NSLog(@"usersCompletion: got response: %@ and error: %@", response, error.userInfo);
        }
        else
        {
            for (NSDictionary *userDictionary in responseBody)
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
                         andCompletion:^(id responseBody, id response, NSError *error)
     {
         if (error)
         {
             NSLog(@"userWithDocID:completion: got response: %@ and error: %@", response, error.userInfo);
             handler(nil);
         }
         else
         {
             handler([[User alloc] initWithUserDictionary:responseBody]);
         }
     }];
}
- (void)userWithType:(RoleType)type completion:(void (^)(NSArray *users))handler
{
    [Store.dbSessionConnection getPath:DB_TYPE_USER
                            withParams:nil
                         andCompletion:^(id responseBody, id response, NSError *error)
     {
         NSMutableArray *collectedUsers = NSMutableArray.array;
         
         if (error)
         {
             NSLog(@"userWithType:completion: got response: %@ and error: %@", response, error.userInfo);
         }
         else
         {
             for (NSDictionary *userDictionary in responseBody)
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
                         andCompletion:^(id responseBody, id response, NSError *error)
    {
        NSMutableArray *collectedMessages = NSMutableArray.array;
        
        if (error)
        {
            NSLog(@"messagesCompletion: got response: %@ and error: %@", response, error.userInfo);
        }
        else
        {
            for (NSDictionary *messageDictionary in responseBody)
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
                            withCompletion:^(id responseBody, id response, NSError *error)
     {
         if (error)
         {
             NSLog(@"broadCastMessage got response: %@ and error: %@", responseBody, error.userInfo);
             handler(nil);
         }
         else
         {
             handler([[Message alloc] initWithMsgDictionary:responseBody]);
         }
     }];
}
- (void)sendMessage:(Message *)message completion:(void (^)(Message *message))handler
{
    NSMutableDictionary *jsonMessage = [NSMutableDictionary dictionaryWithDictionary:message.asDictionary];

    [Store.dbSessionConnection postContent:jsonMessage
                                    toPath:DB_TYPE_MESSAGE
                            withCompletion:^(id responseBody, id response, NSError *error)
     {
         if (error)
         {
             NSLog(@"sendMessage:toUsers:completion: got response: %@ and error: %@", responseBody, error.userInfo);
             handler(nil);
         }
         else
         {
             NSLog(@"%@", responseBody);
             handler([[Message alloc]initWithMsgDictionary:responseBody]);
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
                           withCompletion:^(id responseBody, id response, NSError *error)
    {
        if (error)
        {
            NSLog(@"sendMessage:toUsers:completion: got response: %@ and error: %@", responseBody, error.userInfo);
        }
    }];
}




#pragma mark - Location
- (void)createLocation:(Location *)location completion:(void (^)(Location *location))handler
{
    [Store.dbSessionConnection postContent:location.asDictionary
                                    toPath:DB_TYPE_LOCATION
                            withCompletion:^(id responseBody, id response, NSError *error)
     {
         if (error)
         {
             NSLog(@"createLocation: got response: %@ and error: %@", responseBody, error.userInfo);
             handler(nil);
         }
         else
         {
             handler([[Location alloc] initWithLocationDictionary:responseBody]);
         }
     }];
}
- (void)updateLocation:(Location *)location completion:(void (^)(Location *location))handler
{
    [Store.dbSessionConnection putContent:location.asDictionary
                                   toPath:[NSString stringWithFormat:@"%@/%@", DB_TYPE_LOCATION, location.docID]
                           withCompletion:^(id responseBody, id response, NSError *error)
    {
        if (error)
        {
            NSLog(@"updateLocation: got response: %@ and error: %@", responseBody, error.userInfo);
            handler(nil);
        }
        else
        {
            handler([[Location alloc] initWithLocationDictionary:responseBody]);
        }
    }];
}
- (void)deleteLocation:(Location *)location completion:(void (^)(BOOL success))handler
{
    [Store.dbSessionConnection deletePath:[NSString stringWithFormat:@"%@/%@", DB_TYPE_LOCATION, location.docID]
                           withCompletion:^(id responseBody, id response, NSError *error)
     {
         if (error)
         {
             NSLog(@"updateLocation: got response: %@ and error: %@", responseBody, error.userInfo);
             handler(NO);
         }
         else
         {
             handler(YES);
         }
     }];
}

@end
