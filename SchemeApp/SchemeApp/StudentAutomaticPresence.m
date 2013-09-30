//
//  StudentAutomaticPresence.m
//  SchemeApp
//
//  Created by Rikard Karlsson on 9/25/13.
//  Copyright (c) 2013 Team leet. All rights reserved.
//

#import "StudentAutomaticPresence.h"

@implementation StudentAutomaticPresence

-(void)setCenterForRegion:(CLLocationCoordinate2D)center
{
    locationManager = [[CLLocationManager alloc] init];
    testRegion = [[CLCircularRegion alloc] initWithCenter:center radius:300 identifier:@"test"];
    [locationManager setDelegate:self];
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    [locationManager startMonitoringForRegion:testRegion];
    testRegion.notifyOnEntry = YES;
    
    automaticPresence = [[UIAlertView alloc] initWithTitle:@"Welcome" message:@"We have now confirmed your presence through our very advanced geolocation operating system!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    
    goodbye = [[UIAlertView alloc] initWithTitle:@"Goodbye" message:@"Thank you for today!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    
    startedMonitoringForRegion = [[UIAlertView alloc] initWithTitle:@"Started" message:nil delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    
    
}

-(void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    NSLog(@"Entered Region - %@", region.identifier);
    [locationManager stopMonitoringForRegion:testRegion];
    [automaticPresence show];
}

-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    NSLog(@"Exit Region - %@", region.identifier);
    [goodbye show];
}


- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region {
    [startedMonitoringForRegion show];
}

@end