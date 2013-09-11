//
//  Student.m
//  SchemeApp
//
//  Created by Johan Thorell on 2013-09-10.
//  Copyright (c) 2013 Team leet. All rights reserved.
//

#import "User.h"

@implementation User
-(id)initWithRole:(RoleType)role firstname:(NSString *)firstname lastname:(NSString *)lastname email:(NSString *)email password:(NSString *)password
{
    self = [super init];
    if (self) {
#warning Temp
        // Ska bara hämtas sen från servern, docID
        _docID = [[NSUUID UUID] UUIDString];
        _role = [self stringFromRoleType:role];
        self.firstname = firstname;
        self.lastname = lastname;
        self.email = email;
        self.password = password;
        self.messages = [NSMutableArray new];
        self.eventWrappers = [NSMutableArray new];
    }
    return  self;
}
-(NSString *)stringFromRoleType:(RoleType)role
{
    switch (role) {
        case StudentRole:
            return @"Student";
            break;
        case AdminRole:
            return @"Admin";
        case SuperAdminRole:
            return @"SuperAdmin"
            ;
        default:
            break;
    }
}
@end
