//
//  StudentStore.h
//  
//
//  Created by Henrik on 2013-09-09.
//
//

#define DB_TYPE_EVENTWRAPPER @"eventWrappers"

#import "Store.h"

@class EventWrapper, Message;


@interface StudentStore : NSObject

- (void)eventWrappersWithinStartDate:(NSDate *)startDate
                          andEndDate:(NSDate *)endDate
                          completion:(void (^)(NSArray *eventWrappers))handler;

//unnecessary code
//- (void)messageWithDocID:(NSString *)docID completion:(void (^)(Message *message))completion;

- (void)messagesForUser:(User*)user completion:(void (^)(NSArray *messagesForUser))handler;
- (void)deleteMessage:(Message*)message forUser:(User*)user completion:(void (^)(BOOL success))handler;

- (void)addAttendanceCompletion:(void (^)(BOOL success))handler;

@end
