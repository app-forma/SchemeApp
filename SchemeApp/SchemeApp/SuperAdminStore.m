//
//  SuperAdminStore.m
//  SchemeApp
//
//  Created by Henrik on 2013-09-11.
//  Copyright (c) 2013 Team leet. All rights reserved.
//

#import "SuperAdminStore.h"
#import "User.h"


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
- (NSArray *)filteredSet:(NSSet *)set withPredicate:(NSPredicate *)predicate
{
    NSArray *filteredSet = [[set filteredSetUsingPredicate:predicate] allObjects];
    
    if (filteredSet.count == 0)
    {
        return nil;
    }
    else
    {
        return filteredSet;
    }
}

@end
