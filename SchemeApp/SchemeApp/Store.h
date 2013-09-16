//
//  Store.h
//  
//
//  Created by Henrik on 2013-09-09.
//
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "AdminStore.h"
#import "SuperAdminStore.h"
#import "StudentStore.h"

@class User;


@interface Store : NSObject

+ (AFNetworking *)dbConnection;
+ (Store *)mainStore;
+ (StudentStore *)studentStore;
+ (AdminStore *)adminStore;
+ (SuperAdminStore *)superAdminStore;

@property (nonatomic, strong) User *currentUser;

- (void)setCurrentUserToUserWithEmail:(NSString *)email andPassword:(NSString *)password completion:(void (^)(BOOL success))completion;

@end
