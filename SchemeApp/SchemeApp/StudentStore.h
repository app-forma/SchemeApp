//
//  StudentStore.h
//  
//
//  Created by Henrik on 2013-09-09.
//
//

#import "Store.h"

@class Student, Course, Lesson;


@interface StudentStore : NSObject

- (Student *)studentWithID:(NSString *)studentID andPassword:(NSString *)password;

#pragma mark - Course
- (NSArray *)courses;
- (Course *)courseWithID:(NSString *)courseID;

#pragma mark Lesson
- (Lesson *)lessonWithID:(NSString *)lessonID;
- (NSArray *)lessonsBetweenStartDate:(NSDate *)startDate andEndDate:(NSDate *)endDate;

@end
