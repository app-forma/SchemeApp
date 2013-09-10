//
//  Student.m
//  SchemeApp
//
//  Created by Johan Thorell on 2013-09-10.
//  Copyright (c) 2013 Team leet. All rights reserved.
//

#import "User.h"

@implementation User
-(id)initWithRole:(NSString *)role firstname:(NSString *)firstname lastname:(NSString *)lastname email:(NSString *)email password:(NSString *)password
{
    self = [super init];
    if (self) {
        _role = role;
        self.firstname = firstname;
        self.lastname = lastname;
        self.email = email;
        self.password = password;
        self.messages = [NSMutableArray new];
        self.eventWrappers = [NSMutableArray new];
    }
    return  self;
}
@end
