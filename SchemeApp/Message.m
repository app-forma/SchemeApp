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
    
    return jsonMessage;
}

@end
