//
//  AdminStore.h
//  
//
//  Created by Henrik on 2013-09-09.
//
//

#import "StudentStore.h"

@class EventWrapper, Message, User;


@interface AdminStore : StudentStore

- (BOOL)createEventWrapper:(EventWrapper *)eventWrapper;
- (BOOL)updateEventWrapper:(EventWrapper *)eventWrapper;
- (BOOL)deleteEventWrapper:(EventWrapper *)eventWrapper;

- (BOOL)sendMessage:(Message *)message;
- (BOOL)sendMessage:(Message *)message toUser:(User *)user;

@end
