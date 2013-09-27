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
        self.from = [[User alloc]initWithUserDictionary:msgDictionary[@"from"]];
        self.date = [Helpers dateFromString:msgDictionary[@"date"]];
        self.text = msgDictionary[@"text"];
        for (NSString *receiverID in msgDictionary[@"receivers"]) {
            [self.receiverIDs addObject:receiverID];
        }
    }
    return self;
}
@end
