//
//  AdminStore.h
//  
//
//  Created by Henrik on 2013-09-09.
//
//

#import "Store.h"

@class EventWrapper, Message, User;


@interface AdminStore : NSObject

- (BOOL)createEventWrapper:(EventWrapper *)eventWrapper;
- (BOOL)updateEventWrapper:(EventWrapper *)eventWrapper;
- (BOOL)deleteEventWrapper:(EventWrapper *)eventWrapper;

- (BOOL)sendMessage:(Message *)message;
- (BOOL)sendMessage:(Message *)message toUser:(User *)user;

@end
