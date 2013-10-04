//
//  Store.h
//  
//
//  Created by Henrik on 2013-09-09.
//
//

#import <Foundation/Foundation.h>
#import "DatabaseConnection.h"
#import "Message.h"
#import "AdminStore.h"
#import "SuperAdminStore.h"
#import "StudentStore.h"
#import "AFNetworking.h"

typedef void (^authentication)(BOOL success, id user);

@class User, AFNetworking, SuperAdminStore, StudentStore, AdminStore, Message, Location;


@interface Store : NSObject

+ (AFNetworking *)dbConnection;
+ (DatabaseConnection *)dbSessionConnection;
+ (Store *)mainStore;
+ (StudentStore *)studentStore;
+ (AdminStore *)adminStore;
+ (SuperAdminStore *)superAdminStore;

@property (nonatomic, strong) User *currentUser;

+ (void)setCurrentUserToUserWithEmail:(NSString *)email andPassword:(NSString *)password completion:(void (^)(BOOL success))completion;
+ (void)fetchLocationCompletion:(void (^)(Location *location))completion;
+ (void)sendAuthenticationRequestForEmail:(NSString *)email password:(NSString *)password completion:(authentication)completion;

@end
