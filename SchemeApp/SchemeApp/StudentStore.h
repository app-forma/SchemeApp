//
//  StudentStore.h
//  
//
//  Created by Henrik on 2013-09-09.
//
//

#import "Store.h"


@interface StudentStore : NSObject

- (EventWrapper *)eventWrapperWithStartDate:(NSDate *)startDate andEndDate:(NSDate *)endDate;

@end
