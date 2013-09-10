//
//  AdminStore.h
//  
//
//  Created by Henrik on 2013-09-09.
//
//

#import "Store.h"

@class Admin, Student, Course, Lesson;


@interface AdminStore : NSObject

- (Admin *)adminWithID:(NSString *)adminID andPassword:(NSString *)password;
- (BOOL)uploadAdmin:(Admin *)admin;

#pragma mark - Student
- (NSArray *)students;
- (Student *)studentWithID:(NSString *)studentID;
- (BOOL)uploadStudent:(Student *)student;

#pragma mark - Course
- (NSArray *)courses;
- (Course *)courseWithID:(NSString *)courseID;
- (BOOL)uploadCourse:(Course *)course;

#pragma mark Lesson
- (Lesson *)lessonWithID:(NSString *)lessonID;
- (NSArray *)lessonsBetweenStartDate:(NSDate *)startDate andEndDate:(NSDate *)endDate;
- (BOOL)uploadLession:(Lesson *)lesson;

@end
