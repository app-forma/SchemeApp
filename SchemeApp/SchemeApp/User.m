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


#warning Comment
// We should use enum on backend as well for Role (Henrik)
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
    else
    {
        return StudentRole;
    }
}
+ (NSString *)stringFromRoleType:(RoleType)role
{
    switch (role) {
        case StudentRole:
            return @"student";
            break;
        case AdminRole:
            return @"admin";
        case SuperAdminRole:
            return @"superadmin"
            ;
        default:
            break;
    }
}

- (id)initWithDocID:(NSString *)docID
            Role:(RoleType)role
       firstname:(NSString *)firstname
        lastname:(NSString *)lastname
           email:(NSString *)email
        password:(NSString *)password
{
    self = [super init];
    if (self) {
        _docID = docID;
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
    self = [self initWithDocID:[userDictionary objectForKey:@"_id"]
                          Role:[User roleTypeFromString:[userDictionary objectForKey:@"role"]]
                     firstname:[userDictionary objectForKey:@"firstname"]
                      lastname:[userDictionary objectForKey:@"lastname"]
                         email:[userDictionary objectForKey:@"email"]
                      password:[userDictionary objectForKey:@"password"]];
#warning Testing
    for (id messageDictionary in userDictionary[@"messages"])
    {
        if ([messageDictionary isKindOfClass:NSDictionary.class])
        {
            [self.messages addObject:[[Message alloc] initWithMsgDictionary:messageDictionary]];
        }
    }
    
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
    
    return self;
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
    [jsonUser setValue:userMessages forKey:@"messages"];
    [jsonUser setValue:userEventWrappers forKey:@"eventWrappers"];
    [jsonUser setValue:[User stringFromRoleType:self.role] forKey:@"role"];
    [jsonUser setValue:self.firstname forKey:@"firstname"];
    [jsonUser setValue:self.lastname forKey:@"lastname"];
    [jsonUser setValue:self.email forKey:@"email"];
    [jsonUser setValue:self.password forKey:@"password"];
    
    if ([self.docID isEqualToString:@""] == NO)
    {
        [jsonUser setValue:self.docID forKey:@"_id"];
    }
    
    return jsonUser;
}

- (NSString *)name
{
    return [NSString stringWithFormat:@"%@ %@", self.firstname, self.lastname];
}

@end
