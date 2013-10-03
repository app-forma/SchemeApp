//
//  StudentStore.m
//  
//
//  Created by Henrik on 2013-09-09.
//
//

#import "StudentStore.h"
#import "EventWrapper.h"
#import "Message.h"
#import "NSDate+Helpers.h"


@implementation StudentStore

- (void)eventWrappersWithinStartDate:(NSDate *)startDate
                          andEndDate:(NSDate *)endDate
                          completion:(void (^)(NSArray *eventWrappers))handler
{
    [Store.dbSessionConnection getPath:DB_TYPE_EVENTWRAPPER
                            withParams:@{@"startDate": [Helpers stringFromNSDate:startDate],
                                         @"endDate": [Helpers stringFromNSDate:endDate]}
                         andCompletion:^(id responseBody, id response, NSError *error)
    {
        NSMutableArray *eventWrappers = NSMutableArray.array;
        
        if (error)
        {
            NSLog(@"eventWrappersWithinStartDate:andEndDate:completion: got response: %@ and error: %@", response, error.userInfo);
        }
        else
        {
            for (NSDictionary *eventWrapperDictionary in responseBody)
            {
                [eventWrappers addObject:[[EventWrapper alloc] initWithEventWrapperDictionary:eventWrapperDictionary]];
            }
        }
        
        handler(eventWrappers);
    }];
}

- (void)messagesForUser:(User*)user completion:(void (^)(NSArray *messagesForUser))handler
{
    [[Store dbSessionConnection]getPath:[NSString stringWithFormat:@"%@/%@/%@", DB_TYPE_MESSAGE, @"foruser", [Store mainStore].currentUser.docID] withParams:nil andCompletion:^(id responseBody, id response, NSError *error) {
        if (error)
        {
            NSLog(@"messagesForUser:completion: got response: %@ and error: %@", response, error.userInfo);
            handler(nil);
        }
        else
        {
            NSArray *jsonMessages = (NSArray *)responseBody;
            NSMutableArray *messages = [NSMutableArray new];
            for (NSDictionary *jsonMessage in jsonMessages) {
                [messages addObject:[[Message alloc]initWithMsgDictionary:jsonMessage]];
            }
            handler(messages);
        }
    }];
}

-(void)deleteMessage:(Message *)message forUser:(User *)user completion:(void (^)(BOOL))handler
{
    [[Store dbSessionConnection]deletePath:[NSString stringWithFormat:@"%@/%@/%@/%@", DB_TYPE_MESSAGE, message.docID, @"receivers", user.docID] withCompletion:^(id responseBody, id response, NSError *error) {
        if (error)
        {
            NSLog(@"deleteMessage forUser completion: got response: %@ and error: %@", response, error.userInfo);
        }
        BOOL isSuccess = !error ? YES : NO;
        handler(isSuccess);
    }];
}

- (void)addAttendanceCompletion:(void (^)(BOOL))handler
{
    if (Store.mainStore.currentUser)
    {
            NSString *path = [NSString stringWithFormat:@"%@/%@/attendance/%@", DB_TYPE_USER, Store.mainStore.currentUser.docID, NSDate.date.asDateString];
            
            [Store.dbSessionConnection postContent:nil
                                            toPath:path
                                    withCompletion:^(id responseBody, id response, NSError *error)
             {
                 if (error)
                 {
                     NSLog(@"[%@] addAttendanceCompletion: got response: %@ and error: %@", self.class, response, error.userInfo);
                     handler(NO);
                 }
                 else
                 {
                     handler(YES);
                 }
             }];
    }
    else
    {
        NSLog(@"[%@] Could not add attendance because current user was not set.", self.class);
        handler(NO);
    }
}

@end
