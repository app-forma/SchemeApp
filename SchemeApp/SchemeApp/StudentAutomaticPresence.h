//
//  StudentAutomaticPresence.h
//  SchemeApp
//
//  Created by Rikard Karlsson on 9/25/13.
//  Copyright (c) 2013 Team leet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface StudentAutomaticPresence : NSObject <CLLocationManagerDelegate, UIAlertViewDelegate>
{
    CLLocationManager *locationManager;
    CLRegion *testRegion;
    UIAlertView *automaticPresence;
    UIAlertView *goodbye;
    UIAlertView *startedMonitoringForRegion;
}

-(void)setCenterForRegion:(CLLocationCoordinate2D)center;

@end


