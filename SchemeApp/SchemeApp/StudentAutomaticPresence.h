//
//  StudentAutomaticPresence.h
//  SchemeApp
//
//  Created by Rikard Karlsson on 9/25/13.
//  Copyright (c) 2013 Team leet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@class Location;
@interface StudentAutomaticPresence : NSObject <CLLocationManagerDelegate, UIAlertViewDelegate>

-(id)initWithSchoolLocation:(Location*)schoolLocation;

@end


