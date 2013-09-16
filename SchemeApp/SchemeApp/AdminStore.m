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

@class EventWrapper;


@implementation AdminStore

- (void)createEvent:(Event *)event
{
    [Store.dbConnection createType:DB_TYPE_EVENT
                       withContent:event.asDictionary
                          callback:NULL];
}
- (void)updateEvent:(Event *)event
{
    [Store.dbConnection updateType:DB_TYPE_EVENT
                       withContent:event.asDictionary
                          callback:NULL];
}
- (void)deleteEvent:(Event *)event
{
    [Store.dbConnection deleteType:DB_TYPE_EVENT
                            withId:event.docID
                          callback:NULL];
}
- (void)createEventWrapper:(EventWrapper *)eventWrapper
{
    [Store.dbConnection createType: DB_TYPE_EVENTWRAPPER
                       withContent:eventWrapper.asDictionary
                          callback:NULL];
}
- (void)updateEventWrapper:(EventWrapper *)eventWrapper
{
    [Store.dbConnection updateType:DB_TYPE_EVENTWRAPPER
                       withContent:eventWrapper.asDictionary
                          callback:NULL];
}
- (void)deleteEventWrapper:(EventWrapper *)eventWrapper
{
    [Store.dbConnection deleteType: DB_TYPE_EVENTWRAPPER
                            withId:eventWrapper.docID
                          callback:NULL];
}

- (void)usersCompletion:(void (^)(NSArray *users))completion;
{
    [Store.dbConnection readType:DB_TYPE_USER
                          withId:nil
                        callback:^(id result)
     {
         completion((NSArray *)result);
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

- (void)sendMessage:(Message *)message
{
#warning Implement
    
}
- (void)sendMessage:(Message *)message toUser:(User *)user
{
#warning Implement
    
}

@end
