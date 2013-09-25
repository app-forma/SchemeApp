//
//  SchoolInfoViewController.m
//  SchemeAppAdmin
//
//  Created by Marcus Norling on 9/24/13.
//  Copyright (c) 2013 Marcus Norling. All rights reserved.
//

#import "SchoolInfoViewController.h"
#import "Location.h"


@interface SchoolInfoViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@end


@implementation SchoolInfoViewController
{
    MKPointAnnotation *location;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (Store.mainStore.currentLocation)
    {
        [self setLocationAnnotation];
        [self setInputsToCurrentLocation];
    }
    else
    {
        self.mapView.showsUserLocation = YES;
    }
}

- (IBAction)save:(id)sender
{
#warning Implement
    
}

#pragma mark - MKMapViewDelegate
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    self.mapView.showsUserLocation = NO;
    
    [self.mapView setRegion:[self regionForCoordinate:userLocation.coordinate]
                   animated:YES];
}
- (void)mapViewDidFinishRenderingMap:(MKMapView *)mapView fullyRendered:(BOOL)fullyRendered
{
    if (location && self.mapView.annotations.count == 0)
    {
        [self.mapView addAnnotation:location];
    }
}
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKPinAnnotationView *pav;
    
    if (![annotation isKindOfClass:MKUserLocation.class])
    {
        pav = [[MKPinAnnotationView alloc] init];
        pav.draggable = YES;
        pav.animatesDrop = YES;
    }
    
    return pav;
}

#pragma mark - Extracted methods
- (void)setLocationAnnotation
{
    if (!location)
    {
        location = [[MKPointAnnotation alloc] init];
    }
    
    location.coordinate = CLLocationCoordinate2DMake(Store.mainStore.currentLocation.latitude.doubleValue,
                                                     Store.mainStore.currentLocation.longitude.doubleValue);
}
- (MKCoordinateRegion)regionForCoordinate:(CLLocationCoordinate2D)coordinate
{
    return MKCoordinateRegionMakeWithDistance(coordinate, 1000, 1000);
}
- (void)setInputsToCurrentLocation
{
    [self.mapView setRegion:[self regionForCoordinate:location.coordinate]
                   animated:YES];
    
    self.nameTextField.text = Store.mainStore.currentLocation.name;
}

@end
