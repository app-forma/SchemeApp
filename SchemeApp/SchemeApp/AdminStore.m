//
//  AdminStore.m
//  
//
//  Created by Henrik on 2013-09-09.
//
//

#warning Implement with dbConnection as instance of AFNetworking

#import "AdminStore.h"
#import "Event.h"
#import "EventWrapper.h"
#import "User.h"

@class EventWrapper;


@implementation AdminStore

- (void)createEvent:(Event *)event
{
    [Store.dbConnection createType:@"events"
                       withContent:event.asDictionary
                          callback:NULL];
}
- (void)updateEvent:(Event *)event
{
    
    [Store.mainStore.events removeObject:[self oldVersionOfEvent:event]];
    [Store.mainStore.events addObject:event];
}
- (void)deleteEvent:(Event *)event
{
    [Store.mainStore.events removeObject:event];
}
- (void)createEventWrapper:(EventWrapper *)eventWrapper
{
    [Store.mainStore.eventWrappers addObject:eventWrapper];
}
- (void)updateEventWrapper:(EventWrapper *)eventWrapper
{
    [Store.mainStore.eventWrappers removeObject:[self oldVersionOfEventWrapper:eventWrapper]];
    [Store.mainStore.eventWrappers addObject:eventWrapper];
}
- (void)deleteEventWrapper:(EventWrapper *)eventWrapper
{
    [Store.mainStore.eventWrappers removeObject:eventWrapper];
}

- (NSArray *)users
{
    return [Store.mainStore.users allObjects];
}
- (User *)userWithDocID:(NSString *)docID
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"docID MATCHES %@", docID];
    NSArray *filteredSet = [self filteredSet:Store.mainStore.users withPredicate:predicate];
    
    if (filteredSet)
    {
        return [filteredSet objectAtIndex:0];
    }
    else
    {
        return nil;
    }
}

- (void)sendMessage:(Message *)message
{
    for (User *user in Store.mainStore.users)
    {
        if (user.role == StudentRole)
        {
            [user.messages addObject:message];
        }
    }
}
- (void)sendMessage:(Message *)message toUser:(User *)user
{
    [user.messages addObject:message];
}

#pragma mark - Extracted methods
- (EventWrapper *)oldVersionOfEvent:(Event *)event
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"docID MATCHES %@", event.docID];
    NSArray *filteredSet = [self filteredSet:Store.mainStore.events withPredicate:predicate];
    
    if (filteredSet)
    {
        return [filteredSet objectAtIndex:0];
    }
    else
    {
        return nil;
    }
}
- (EventWrapper *)oldVersionOfEventWrapper:(EventWrapper *)eventWrapper
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"docID MATCHES %@", eventWrapper.docID];
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

#warning Comment
// Testkommentar

@end
