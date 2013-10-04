//
//  Student.m
//  SchemeApp
//
//  Created by Johan Thorell on 2013-09-10.
//  Copyright (c) 2013 Team leet. All rights reserved.
//

#import "User.h"
#import "Message.h"
#import "EventWrapper.h"
#import "UIImage+Base64.h"

@implementation User

+ (RoleType)roleTypeFromString:(NSString *)roleString
{
    if ([roleString isEqualToString:@"superadmin"])
    {
        return SuperAdminRole;
    }
    else if ([roleString isEqualToString:@"admin"])
    {
        return AdminRole;
    }
    return StudentRole;
}

+ (NSString *)stringFromRoleType:(RoleType)role
{
    switch (role) {
        case StudentRole:
            return @"student";
        case AdminRole:
            return @"admin";
        case SuperAdminRole:
            return @"superadmin";
    }
}

- (id)initWithDocID:(NSString *)docID
            Role:(RoleType)role
       firstname:(NSString *)firstname
        lastname:(NSString *)lastname
           email:(NSString *)email
        password:(NSString *)password
           image:(NSString *)image
{
    self = [super init];
    if (self) {
        _docID = docID;
        _role = role;
        self.firstname = firstname;
        self.lastname = lastname;
        self.email = email;
        self.password = password;
        self.eventWrappers = [NSMutableArray new];
        self.attendances = [NSMutableArray new];
        if (image) {
            self.image = [UIImage imageFromBase64:image];
        }
    }
    return  self;
}
- (id)initWithUserDictionary:(NSDictionary *)userDictionary
{
    self = [self initWithDocID:[userDictionary objectForKey:@"_id"]
                          Role:[User roleTypeFromString:[userDictionary objectForKey:@"role"]]
                     firstname:[userDictionary objectForKey:@"firstname"]
                      lastname:[userDictionary objectForKey:@"lastname"]
                         email:[userDictionary objectForKey:@"email"]
                      password:[userDictionary objectForKey:@"password"]
                         image:[userDictionary objectForKey:@"image"]];
    
    for (id eventWrapper in userDictionary[@"eventWrappers"])
    {
        if ([eventWrapper isKindOfClass:NSDictionary.class])
        {
            [self.eventWrappers addObject:[[EventWrapper alloc] initWithEventWrapperDictionary:eventWrapper]];
        }
        else if ([eventWrapper isKindOfClass:NSString.class])
        {
            [self.eventWrappers addObject:eventWrapper];
        }
    }
    for (NSString *attendanceDateString in [userDictionary objectForKey:@"attendances"]) {
        [self.attendances addObject:attendanceDateString];
    }
    return self;
}

- (NSDictionary *)asDictionary
{
    NSMutableDictionary *jsonUser = [[NSMutableDictionary alloc]init];
    
    NSMutableArray *userEventWrappers = [[NSMutableArray alloc]init];
    for (id eventWrapper in self.eventWrappers) {
        if ([eventWrapper isKindOfClass:[EventWrapper class]]) {
            EventWrapper *nativeEventWrapper = (EventWrapper*)eventWrapper;
            [userEventWrappers addObject:nativeEventWrapper.docID];
        } else if ([eventWrapper isKindOfClass:[NSString class]]) {
            [userEventWrappers addObject:eventWrapper];
        }
    }
    [jsonUser setValue:userEventWrappers forKey:@"eventWrappers"];
    NSMutableArray *userAttendances = [NSMutableArray new];
    for (NSString *attendanceDateString in self.attendances) {
        [userAttendances addObject:attendanceDateString];
    }
    [jsonUser setValue:userAttendances forKey:@"attendances"];
    [jsonUser setValue:[User stringFromRoleType:self.role] forKey:@"role"];
    [jsonUser setValue:self.firstname forKey:@"firstname"];
    [jsonUser setValue:self.lastname forKey:@"lastname"];
    [jsonUser setValue:self.email forKey:@"email"];
    [jsonUser setValue:self.password forKey:@"password"];
    [jsonUser setValue:[UIImage base64From:self.image] forKey:@"image"];
    
    if ([self.docID isEqualToString:@""] == NO)
    {
        [jsonUser setValue:self.docID forKey:@"_id"];
    }
    return jsonUser;
}

- (NSString *)fullName
{
    return [NSString stringWithFormat:@"%@ %@", self.firstname, self.lastname];
}

-(NSString *)roleAsString
{
    return [User stringFromRoleType:self.role];
}

@end
