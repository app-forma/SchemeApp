//
//  Store.h
//  
//
//  Created by Henrik on 2013-09-09.
//
//

#import <Foundation/Foundation.h>
#import "AdminStore.h"
#import "SuperAdminStore.h"
#import "StudentStore.h"

@class User;


@interface Store : NSObject

@property (nonatomic, weak) User *currentUser;
@property (nonatomic, weak) NSMutableSet *users;

@property (nonatomic, weak) NSMutableSet *events;
@property (nonatomic, weak) NSMutableSet *eventWrappers;

+ (Store *)mainStore;
+ (StudentStore *)studentStore;
+ (AdminStore *)adminStore;
+ (SuperAdminStore *)superAdminStore;

- (User *)userWithEmail:(NSString *)email andPassword:(NSString *)password;

#warning Comment
// Testkommentar

@end
