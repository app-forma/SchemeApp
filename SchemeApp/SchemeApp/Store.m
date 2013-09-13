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
{
    AFNetworking *dbConnection;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return self.mainStore;
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

- (AFNetworking *)dbConnection
{
    if (dbConnection == nil)
    {
        dbConnection = [[AFNetworking alloc] init];
    }
    return dbConnection;
}

- (void)setCurrentUserToUserWithEmail:(NSString *)email andPassword:(NSString *)password completion:(void (^)(BOOL success))completion
{
    #warning Implement password
    [Store.mainStore.dbConnection readType:@"users"
                                    withId:nil
                                  callback:^(id result)
     {
         for (NSDictionary *userDictionary in result)
         {
             if ([[userDictionary objectForKey:@"email"] isEqualToString:email])
             {
#warning Comment
                 // We should use enum on backend as well for Role
                 Store.mainStore.currentUser = [[User alloc] initWithRole:[self makeEnumOfRoleString:[userDictionary objectForKey:@"role"]]
                                                                firstname:[userDictionary objectForKey:@"firstname"]
                                                                 lastname:[userDictionary objectForKey:@"lastname"]
                                                                    email:email
                                                                 password:password];
                 completion(YES);
                 return;
             }
         }
         completion(NO);
     }];
}

#pragma mark - Extracted methods
- (int)makeEnumOfRoleString:(NSString *)roleString
{
    if ([roleString isEqualToString:@"superadmin"])
    {
        return SuperAdminRole;
    }
    else if ([roleString isEqualToString:@"admin"])
    {
        return AdminRole;
    }
    else
    {
        return StudentRole;
    }
}

@end
