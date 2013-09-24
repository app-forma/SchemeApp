//
//  Store.m
//  
//
//  Created by Henrik on 2013-09-09.
//
//

#import "Store.h"
#import "User.h"
#import "Message.h"
#import "EventWrapper.h"
#import "Event.h"


@implementation Store

+ (id)allocWithZone:(NSZone *)zone
{
    return self.mainStore;
}
+ (AFNetworking *)dbConnection
{
    static AFNetworking *dbConnection = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
                  {
                      dbConnection = [[AFNetworking alloc] init];
                  });
    
    return dbConnection;
}
+ (DatabaseConnection *)dbSessionConnection
{
    static DatabaseConnection *dbConnection = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
                  {
                      dbConnection = [[DatabaseConnection alloc] init];
                  });
    
    return dbConnection;
}
+ (Store *)mainStore
{
    static Store *mainStore = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
                  {
                      mainStore = [[super allocWithZone:nil] init];
                  });
    
    return mainStore;
}
+ (AdminStore *)adminStore
{
    static AdminStore *adminStore = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
                  {
                      adminStore = [[AdminStore alloc] init];
                  });
    
    return adminStore;
}
+ (SuperAdminStore *)superAdminStore
{
    static SuperAdminStore *superAdminStore = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
                  {
                      superAdminStore = [[SuperAdminStore alloc] init];
                  });
    
    return superAdminStore;
}
+ (StudentStore *)studentStore
{
    static StudentStore *studentStore = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
                  {
                      studentStore = [[StudentStore alloc] init];
                  });
    
    return studentStore;
}

+ (void)setCurrentUserToUserWithEmail:(NSString *)email andPassword:(NSString *)password completion:(void (^)(BOOL success))completion
{
#warning Implement password
    [Store.dbSessionConnection getPath:[NSString stringWithFormat:@"%@/email/%@", DB_TYPE_USER, email]
                            withParams:nil
                         andCompletion:^(id jsonObject, id response, NSError *error)
     {
         if (error)
         {
             NSLog(@"setCurrentUserToUserWithEmail:andPassword:completion: got response: %@ and error: %@", response, error.userInfo);
             completion(NO);
         }
         else
         {
             Store.mainStore.currentUser = [[User alloc] initWithUserDictionary:jsonObject];
             completion(YES);
         }
     }];
  
#warning Testing
//    [Store.dbConnection readByEmail:email callback:^(id result) {
//
//        if (result[@"error"]) {
//            NSLog(@"%@", result);
//            completion(NO);
//            return;
//        }
//        NSDictionary *currentUser = result;
//        if ([currentUser[@"email"] isEqualToString:email]) {
//            User *user = [[User alloc]initWithUserDictionary:currentUser];
//            if ([currentUser[@"messages"] count] > 0) {
//                for (NSDictionary *message in currentUser[@"messages"]){
//                    Message *msg = [[Message alloc]initWithMsgDictionary:message];
//                    [user.messages addObject:msg];
//                }
//            }
//                if (currentUser[@"eventWrappers"] > 0) {
//                    for (NSDictionary *eventWrapper in currentUser[@"eventWrappers"]){
//                        EventWrapper *eW = [[EventWrapper alloc] initWithEventWrapperDictionary:eventWrapper];
//                        for (NSDictionary *event in eventWrapper[@"events"]){
//                            Event *e = [[Event alloc]initWithEventDictionary:event];
//                            [eW.events addObject:e];
//                        }
//                        [user.eventWrappers addObject:eW];
//                    }
//                }
//                Store.mainStore.currentUser = user;
//                
//                completion(YES);
//                return;
//
//            
//        }
//        
//    }];
}

@end
