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

@class User, AFNetworking, SuperAdminStore, StudentStore, AdminStore, Message, Location;


@interface Store : NSObject

+ (AFNetworking *)dbConnection;
+ (DatabaseConnection *)dbSessionConnection;
+ (Store *)mainStore;
+ (StudentStore *)studentStore;
+ (AdminStore *)adminStore;
+ (SuperAdminStore *)superAdminStore;

@property (nonatomic, strong) User *currentUser;
@property (nonatomic, strong) Location *currentLocation;

+ (void)setCurrentUserToUserWithEmail:(NSString *)email andPassword:(NSString *)password completion:(void (^)(BOOL success))completion;
+ (void)fetchLocation;

@end
