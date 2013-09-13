//
//  SuperAdminStore.m
//  SchemeApp
//
//  Created by Henrik on 2013-09-11.
//  Copyright (c) 2013 Team leet. All rights reserved.
//

#warning Implement with dbConnection as instance of AFNetworking
#warning Handle error in methods where now callback:NULL

#import "SuperAdminStore.h"
#import "User.h"


@interface SuperAdminStore (PrivateMethods)

- (NSArray *)filteredSet:(NSSet *)set withPredicate:(NSPredicate *)predicate;

@end


@implementation SuperAdminStore
    
- (void)createUser:(User *)user
{
    [Store.dbConnection createType:DB_TYPE_USER
                       withContent:user.asDictionary
                          callback:NULL];
}
- (void)updateUser:(User *)user
{
    [Store.dbConnection updateType:DB_TYPE_USER
                       withContent:user.asDictionary
                          callback:NULL];
}
- (void)deleteUser:(User *)user
{
    [Store.dbConnection deleteType:DB_TYPE_USER
                            withId:user.docID
                          callback:NULL];
}

@end
