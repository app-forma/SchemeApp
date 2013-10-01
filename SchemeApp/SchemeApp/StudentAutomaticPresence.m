//
//  StudentAutomaticPresence.m
//  SchemeApp
//
//  Created by Rikard Karlsson on 9/25/13.
//  Copyright (c) 2013 Team leet. All rights reserved.
//

#import "StudentAutomaticPresence.h"

@implementation StudentAutomaticPresence
{
    CLLocationManager *locationManager;
    CLRegion *schoolRegion;
    UIAlertView *automaticPresence;
    UIAlertView *goodbye;
    UIAlertView *startedMonitoringForRegion;
}

-(void)setCenterForRegion:(CLLocationCoordinate2D)center
{
    locationManager = [[CLLocationManager alloc] init];
     schoolRegion = [[CLCircularRegion alloc] initWithCenter:center radius:300 identifier:@"School"];
    [locationManager setDelegate:self];
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    [locationManager startMonitoringForRegion:schoolRegion];
    schoolRegion.notifyOnEntry = YES;
    
    automaticPresence = [[UIAlertView alloc] initWithTitle:@"Welcome" message:@"We have now confirmed your presence through our very advanced geolocation operating system!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    
    goodbye = [[UIAlertView alloc] initWithTitle:@"Goodbye" message:@"Thank you for today!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    
    startedMonitoringForRegion = [[UIAlertView alloc] initWithTitle:@"Started" message:nil delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    
    
    NSLog(@"center.long: %f, center.lat: %f", center.longitude, center.latitude);
    
    
}

-(void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    NSLog(@"Entered Region - %@", region.identifier);
    [locationManager stopMonitoringForRegion:schoolRegion];
    [automaticPresence show];
    
    [[Store studentStore] addAttendanceCompletion:^(BOOL success) {
        if (success) {
            NSLog(@"Attendance registered.");
        }
    }];
}

- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region {
    [startedMonitoringForRegion show];
}

@end