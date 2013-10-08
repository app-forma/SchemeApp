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
    [Store.dbConnection getPath:DB_TYPE_EVENTWRAPPER
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
             // Admin's should only see it's own courses
             if ([Store mainStore].currentUser.role == AdminRole) {
                 [responseBody filterUsingPredicate:[NSPredicate predicateWithFormat:@"owner._id == [cd]%@", [Store mainStore].currentUser.docID]];
             }
             
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
    [Store.dbConnection getPath:[NSString stringWithFormat:@"%@/%@", DB_TYPE_EVENT, docID]
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

#pragma mark - Event and EventWrappers CRUD
- (void)createEvent:(Event *)event completion:(completion)handler
{
    [Store.dbConnection postContent:event.asDictionary
                                    toPath:DB_TYPE_EVENT
                            withCompletion:^(id responseBody, id response, NSError *error)
     {
#warning Should return model not responseBody
         handler(responseBody, response, error);
     }];
}
- (void)updateEvent:(Event *)event completion:(completion)handler
{
    [Store.dbConnection putContent:event.asDictionary
                                   toPath:[NSString stringWithFormat:@"%@/%@", DB_TYPE_EVENT, event.docID]
                           withCompletion:^(id responseBody, id response, NSError *error)
     {
#warning Should return model not responseBody
         handler(responseBody, response, error);
     }];
}
- (void)deleteEvent:(Event *)event completion:(completion)handler
{
    [Store.dbConnection deletePath:[NSString stringWithFormat:@"%@/%@", DB_TYPE_EVENT, event.docID]
                           withCompletion:^(id responseBody, id response, NSError *error)
     {
#warning Should return model not responseBody
         handler(responseBody, response, error);
     }];
}
- (void)createEventWrapper:(EventWrapper *)eventWrapper completion:(completion)handler
{
    [Store.dbConnection postContent:eventWrapper.asDictionary
                                    toPath:DB_TYPE_EVENTWRAPPER
                            withCompletion:^(id responseBody, id response, NSError *error)
     {
#warning Should return model not responseBody
         handler(responseBody, response, error);
     }];
}
- (void)updateEventWrapper:(EventWrapper *)eventWrapper completion:(completion)handler
{
    [Store.dbConnection putContent:eventWrapper.asDictionary
                                   toPath:[NSString stringWithFormat:@"%@/%@", DB_TYPE_EVENTWRAPPER, eventWrapper.docID]
                           withCompletion:^(id responseBody, id response, NSError *error)
     {
#warning Should return model not responseBody
         handler(responseBody, response, error);
     }];
}
- (void)deleteEventWrapper:(EventWrapper *)eventWrapper completion:(completion)handler
{
    [Store.dbConnection deletePath:[NSString stringWithFormat:@"%@/%@", DB_TYPE_EVENTWRAPPER, eventWrapper.docID]
                           withCompletion:^(id responseBody, id response, NSError *error)
     {
#warning Should return model not responseBody
         handler(responseBody, response, error);
     }];
}

#pragma mark - Users
- (void)usersCompletion:(void (^)(NSArray *allUsers))handler
{
    [Store.dbConnection getPath:DB_TYPE_USER
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
    [Store.dbConnection getPath:[NSString stringWithFormat:@"%@/%@", DB_TYPE_USER, docID]
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
    [Store.dbConnection getPath:DB_TYPE_USER
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

- (void)removeAttendance:(NSString *)attendanceDateString forUser:(User *)user completion:(void (^)(BOOL success))handler
{
    [[Store dbConnection]deletePath:[NSString stringWithFormat:@"%@/%@/%@/%@", DB_TYPE_USER, user.docID, @"attendance",attendanceDateString] withCompletion:
    ^(id responseBody, id response, NSError *error) {
        if (error) {
            NSLog(@"removeAttendance got response: %@ and error: %@", response, error.userInfo);
            handler(NO);
        } else {
            handler(YES);
        }
    }];
}

-(void)addEventWrapper:(EventWrapper *)eventWrapper toUser:(User *)user completion:(void (^)(BOOL success))handler
{
    [[Store dbConnection]postContent:nil toPath:[NSString stringWithFormat:@"%@/%@/%@/%@", DB_TYPE_USER, user.docID, @"eventwrapper", eventWrapper.docID] withCompletion:^(id responseBody, id response, NSError *error) {
        if (error) {
            NSLog(@"addEventWrapper: toUser: Got error: %@", error.userInfo);
            handler(NO);
        } else {
            handler(YES);
        }
    }];
}

-(void)removeEventWrapper:(EventWrapper *)eventWrapper fromUser:(User *)user completion:(void (^)(BOOL success))handler
{
    [[Store dbConnection]deletePath:[NSString stringWithFormat:@"%@/%@/%@/%@", DB_TYPE_USER, user.docID, @"eventwrapper", eventWrapper.docID] withCompletion:^(id responseBody, id response, NSError *error) {
        if (error) {
            NSLog(@"removeEventWrapper: forUser: got error: %@", error.userInfo);
            handler(NO);
        } else {
            handler(YES);
        }
    }];
}

#pragma mark - Messages
- (void)broadcastMessage:(Message *)message completion:(void (^)(Message *message))handler
{
    [Store.dbConnection postContent:message.asDictionary
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

    [Store.dbConnection postContent:jsonMessage
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

#pragma mark - Location
- (void)createLocation:(Location *)location completion:(void (^)(Location *location))handler
{
    [Store.dbConnection postContent:location.asDictionary
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
    [Store.dbConnection putContent:location.asDictionary
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
    [Store.dbConnection deletePath:[NSString stringWithFormat:@"%@/%@", DB_TYPE_LOCATION, location.docID]
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
