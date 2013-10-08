//
//  StudentAutomaticPresence.m
//  SchemeApp
//
//  Created by Rikard Karlsson on 9/25/13.
//  Copyright (c) 2013 Team leet. All rights reserved.
//

#import "StudentAutomaticPresence.h"
#import "Location.h"

@implementation StudentAutomaticPresence
{
    CLLocationManager *locationManager;
    CLRegion *schoolRegion;
}

-(id)initWithSchoolLocation:(Location *)schoolLocation
{
    self = [super init];
    if (self) {
        CLLocationCoordinate2D center = CLLocationCoordinate2DMake(schoolLocation.latitude.doubleValue, schoolLocation.longitude.doubleValue);
        locationManager = [[CLLocationManager alloc] init];
        schoolRegion = [[CLCircularRegion alloc] initWithCenter:center radius:300 identifier:@"School"];
        schoolRegion.notifyOnEntry = YES;
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.distanceFilter = kCLDistanceFilterNone;
        [locationManager startMonitoringForRegion:schoolRegion];
    }
    return self;
}

-(void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    [locationManager stopMonitoringForRegion:schoolRegion];
    
    [[[UIAlertView alloc] initWithTitle:@"Welcome" message:@"We have now confirmed your presence through our very advanced geolocation system!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
    
    [[Store studentStore] addAttendanceCompletion:^(BOOL success) {
        if (success) {
            NSLog(@"Attendance registered.");
            [NSUserDefaults.standardUserDefaults setObject:NSDate.date.asDateString forKey:@"latestAttendance"];
        }
    }];
}

-(void)dealloc {
    [locationManager stopMonitoringForRegion:schoolRegion];
}

- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region
{
}

-(void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error
{
    NSLog(@"monitoring did fail: %@", error);
}



@end