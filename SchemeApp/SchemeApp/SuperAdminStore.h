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

- (BOOL)createUser:(User *)user;
- (BOOL)updateUser:(User *)user;
- (BOOL)removeUser:(User *)user;

@end
