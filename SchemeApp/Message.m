//
//  Messages.m
//  SchemeApp
//
//  Created by Johan Thorell on 2013-09-10.
//  Copyright (c) 2013 Team leet. All rights reserved.
//

#import "Message.h"
#import "User.h"
#import "Helpers.h"

@implementation Message

+ (id)messageWithText:(NSString*)text receivers:(NSArray *)receivers
{
    Message *message = [[self alloc]init];
    message.text = text;
    message.from = [Store mainStore].currentUser;
    message.date = [NSDate date];
    message.receiverIDs = [NSMutableArray new];
    for (User *receiver in receivers) {
        [message.receiverIDs addObject:receiver.docID];
    }
    return message;
}

- (NSDictionary *)asDictionary
{
    NSMutableDictionary *jsonMessage = [[NSMutableDictionary alloc]init];
    [jsonMessage setObject:self.text forKey:@"text"];
    [jsonMessage setObject:[Helpers stringFromNSDate:self.date] forKey:@"date"];
    [jsonMessage setObject:self.from.docID forKey:@"from"];

    NSMutableArray *receiverIDs = [NSMutableArray new];
    for (NSString *receiverID in self.receiverIDs) {
        [receiverIDs addObject:receiverID];
    }
    [jsonMessage setObject:receiverIDs forKey:@"receivers"];
    
    if (self.docID) {
        [jsonMessage setObject:self.docID forKey:@"_id"];
    }    
    return jsonMessage;
}
- (id)initWithMsgDictionary:(NSDictionary *)msgDictionary
{
    self = [super init];
    if (self) {
        _docID = msgDictionary[@"_id"];
        if ([msgDictionary[@"from"] isKindOfClass:[NSDictionary class]]) {
            self.from = [[User alloc]initWithUserDictionary:msgDictionary[@"from"]];
        } else {
            self.from = [User new];
            self.from.firstname = @"Deleted";
            self.from.lastname = @" user";
        }
        self.date = [Helpers dateFromString:msgDictionary[@"date"]];
        self.text = msgDictionary[@"text"];
        self.receiverIDs = [NSMutableArray new];
        for (NSString *receiverID in msgDictionary[@"receivers"]) {
            [self.receiverIDs addObject:receiverID];
        }
    }
    return self;
}

@end
