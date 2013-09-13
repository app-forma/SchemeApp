//
//  SuperAdminStore.m
//  SchemeApp
//
//  Created by Henrik on 2013-09-11.
//  Copyright (c) 2013 Team leet. All rights reserved.
//

#warning Implement with dbConnection as instance of AFNetworking

#import "SuperAdminStore.h"
#import "User.h"


@interface SuperAdminStore (PrivateMethods)

- (NSArray *)filteredSet:(NSSet *)set withPredicate:(NSPredicate *)predicate;

@end


@implementation SuperAdminStore
    
- (void)createUser:(User *)user
{
    [Store.mainStore.users addObject:user];
}
- (void)updateUser:(User *)user
{
    [Store.mainStore.users removeObject:[self oldVersionOfUser:user]];
    [Store.mainStore.users addObject:user];
}
- (void)deleteUser:(User *)user
{
    [Store.mainStore.users removeObject:user];
}

#pragma mark - Extracted methods
- (User *)oldVersionOfUser:(User *)user
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"docID MATCHES %@", user.docID];
    NSArray *filteredSet = [self filteredSet:Store.mainStore.eventWrappers withPredicate:predicate];
    
    if (filteredSet)
    {
        return [filteredSet objectAtIndex:0];
    }
    else
    {
        return nil;
    }
}

@end
