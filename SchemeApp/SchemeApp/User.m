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

@implementation User

-(id)initWithRole:(RoleType)role firstname:(NSString *)firstname lastname:(NSString *)lastname email:(NSString *)email password:(NSString *)password
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
- (id)initWithUserDictionary:(NSDictionary *)userDictionary
{
    return  [self initWithRole:[self roleTypeFromString:[userDictionary objectForKey:@"role"]]
                     firstname:[userDictionary objectForKey:@"firstname"]
                      lastname:[userDictionary objectForKey:@"lastname"]
                         email:[userDictionary objectForKey:@"email"]
                      password:[userDictionary objectForKey:@"password"]];
}

- (NSDictionary *)asDictionary
{
    NSMutableDictionary *jsonUser = [[NSMutableDictionary alloc]init];
    
    NSMutableArray *userMessages = [[NSMutableArray alloc]init];
    for (Message *message in self.messages) {
        [userMessages addObject:message.docID];
    }
    NSMutableArray *userEventWrappers = [[NSMutableArray alloc]init];
    for (EventWrapper *eventWrapper in userEventWrappers) {
        [userEventWrappers addObject:eventWrapper.docID];
    }
    [jsonUser setObject:userMessages forKey:@"messages"];
    [jsonUser setObject:userEventWrappers forKey:@"eventWrappers"];
    [jsonUser setObject:[self stringFromRoleType:self.role] forKey:@"role"];
    [jsonUser setObject:self.firstname forKey:@"firstname"];
    [jsonUser setObject:self.lastname forKey:@"lastname"];
    [jsonUser setObject:self.email forKey:@"email"];
    
    return jsonUser;
}

#warning Comment
// We should use enum on backend as well for Role (Henrik)
- (RoleType)roleTypeFromString:(NSString *)roleString
{
    if ([roleString isEqualToString:@"superadmin"])
    {
        return SuperAdminRole;
    }
    else if ([roleString isEqualToString:@"admin"])
    {
        return AdminRole;
    }
    else
    {
        return StudentRole;
    }
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
