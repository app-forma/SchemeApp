//
//  SchemeAppTests.m
//  SchemeAppTests
//
//  Created by Johan Thorell on 2013-09-09.
//  Copyright (c) 2013 Team leet. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "User.h"


@interface SchemeAppTests : XCTestCase
@end


@implementation SchemeAppTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testIfUserAsDictionaryReturnValidJSONFormat
{
    User *user = [[User alloc] initWithDocID:[[NSUUID UUID] UUIDString]
                                        Role:StudentRole
                                   firstname:@"Firstname"
                                    lastname:@"Lastname"
                                       email:@"email@email.com"
                                    password:@"password"];
    
    XCTAssertTrue([NSJSONSerialization isValidJSONObject:user.asDictionary], @"User instance method 'asDicitonary' must return a valid JSON object!");
}

@end
