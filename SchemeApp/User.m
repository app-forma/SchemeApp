//
//  Student.m
//  SchemeApp
//
//  Created by Johan Thorell on 2013-09-10.
//  Copyright (c) 2013 Team leet. All rights reserved.
//

#import "Student.h"

@implementation Student
-(id)initWithFirstname:(NSString *)firstname lastname:(NSString *)lastname email:(NSString *)email password:(NSString *)password
{
    self = [super init];
    if (self) {
        _role = @"Student";
        self.firstname = firstname;
        self.lastname = lastname;
        self.email = email;
        self.password = password;
    }
    return  self;
}
@end
