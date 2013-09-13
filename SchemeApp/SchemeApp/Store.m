//
//  Store.m
//  
//
//  Created by Henrik on 2013-09-09.
//
//

#import "Store.h"
#import "User.h"


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

- (void)setCurrentUserToUserWithEmail:(NSString *)email andPassword:(NSString *)password completion:(void (^)(BOOL success))completion
{
#warning Implement password
    [Store.dbConnection readType:@"users"
                          withId:nil
                        callback:^(id result)
     {
         for (NSDictionary *userDictionary in result)
         {
             if ([[userDictionary objectForKey:@"email"] isEqualToString:email])
             {
                 Store.mainStore.currentUser = [[User alloc] initWithUserDictionary:userDictionary];
                 completion(YES);
                 return;
             }
         }
         completion(NO);
     }];
}

@end
