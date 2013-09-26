//
//  Store.m
//  
//
//  Created by Henrik on 2013-09-09.
//
//

#import "Store.h"
#import "User.h"
#import "EventWrapper.h"
#import "Event.h"
#import "Location.h"

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
                         andCompletion:^(id responseBody, id response, NSError *error)
     {
         if (error)
         {
             NSLog(@"setCurrentUserToUserWithEmail:andPassword:completion: got response: %@ and error: %@", response, error.userInfo);
             completion(NO);
         }
         else
         {
             Store.mainStore.currentUser = [[User alloc] initWithUserDictionary:responseBody];
             completion(YES);
         }
     }];
}

#warning EXPERIMENTAL
+ (void)sendAuthenticationRequestForEmail:(NSString *)email password:(NSString *)password completion:(void (^)(BOOL success))completion
{
    [Store.dbSessionConnection postContent:@{@"email":email, @"password":password} toPath:@"users/login" withCompletion:^(id responseBody, id response, NSError *error) {
        NSLog(@"RESPONSE BODY: %@", responseBody);
        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
        NSInteger statusCode = [httpResponse statusCode];
        NSLog(@"RESPONSE: %d", statusCode);
        NSLog(@"ERROR: %@", error);
        if (statusCode == 200) {
            completion(YES);
        } else {
            completion(NO);            
        }
    }];
}

+ (void)fetchLocation
{
    [Store.dbSessionConnection getPath:DB_TYPE_LOCATION
                            withParams:nil
                         andCompletion:^(id responseBody, id response, NSError *error)
     {
         if (error)
         {
             NSLog(@"setCurrentLocation got response: %@ and error: %@", response, error.userInfo);
         }
         else
         {
             if ([responseBody count])
             {
                 Store.mainStore.currentLocation = [[Location alloc] initWithLocationDictionary:responseBody[0]];
             }
         }
     }];
}

@end
