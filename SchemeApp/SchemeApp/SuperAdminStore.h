//
//  SuperAdminStore.h
//  SchemeApp
//
//  Created by Henrik on 2013-09-11.
//  Copyright (c) 2013 Team leet. All rights reserved.
//

#import "AdminStore.h"

@class User;

@interface SuperAdminStore : AdminStore

- (void)createUser:(User *)user completion:(completion)handler;
- (void)updateUser:(User *)user completion:(completion)handler;
- (void)deleteUser:(User *)user completion:(completion)handler;

@end
