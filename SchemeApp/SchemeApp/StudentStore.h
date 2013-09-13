//
//  StudentStore.h
//  
//
//  Created by Henrik on 2013-09-09.
//
//

#import "Store.h"

@class EventWrapper;


@interface StudentStore : NSObject

- (void)eventWrapperWithStartDate:(NSDate *)startDate andEndDate:(NSDate *)endDate completion:(void (^)(NSArray *))completion;

@end
