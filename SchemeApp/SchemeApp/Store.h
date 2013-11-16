//
//  Store.h
//  
//
//  Created by Henrik on 2013-09-09.
//
//

#import "DatabaseConnection.h"
#import "Message.h"
#import "AdminStore.h"
#import "SuperAdminStore.h"
#import "StudentStore.h"

@import Foundation;

@class User, SuperAdminStore, StudentStore, AdminStore, Message, Location;

typedef void (^authentication)(BOOL success, id user);


@interface Store : NSObject

+ (DatabaseConnection *)dbConnection;
+ (Store *)mainStore;
+ (StudentStore *)studentStore;
+ (AdminStore *)adminStore;
+ (SuperAdminStore *)superAdminStore;

@property (nonatomic, strong) User *currentUser;

+ (void)setCurrentUserToUserWithEmail:(NSString *)email andPassword:(NSString *)password completion:(void (^)(BOOL success))completion;
+ (void)fetchLocationCompletion:(void (^)(Location *location))completion;
+ (void)sendAuthenticationRequestForEmail:(NSString *)email password:(NSString *)password completion:(authentication)completion;

@end
