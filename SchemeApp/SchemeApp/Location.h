//
//  Location.h
//  SchemeApp
//
//  Created by Henrik on 2013-09-25.
//  Copyright (c) 2013 Team leet. All rights reserved.
//

@import Foundation;


@interface Location : NSObject

@property (nonatomic, readonly) NSString *docID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSNumber *latitude;
@property (nonatomic, copy) NSNumber *longitude;

- (id)initWithLocationDictionary:(NSDictionary *)locationDictionary;

- (NSDictionary *)asDictionary;

@end
