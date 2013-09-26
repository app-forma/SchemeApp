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
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@end


@implementation SchoolInfoViewController
{
    Location *currentLocation;
    MKPointAnnotation *currentLocationAnnotation;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    currentLocation = Store.mainStore.currentLocation;
    
    if (currentLocation)
    {
        [self setInputsToCurrentLocation];
    }
    else
    {
        self.mapView.showsUserLocation = YES;
    }
}

- (IBAction)addCurrentLocationAnnotation:(UITapGestureRecognizer*)recognizer
{
    if (!self.mapAnnotation)
    {
        CLLocationCoordinate2D coordinate;
        if (recognizer)
        {
            CGPoint tappedPoint = [recognizer locationInView:self.mapView];
            coordinate = [self.mapView convertPoint:tappedPoint toCoordinateFromView:self.mapView];
        }
        else
        {
            coordinate = CLLocationCoordinate2DMake(currentLocation.latitude.doubleValue,
                                                    currentLocation.longitude.doubleValue);
        }
        
        MKPointAnnotation *pa = [[MKPointAnnotation alloc] init];
        pa.coordinate = coordinate;
        
        [self.mapView addAnnotation:pa];
    }
}

- (IBAction)delete:(id)sender
{
    if (currentLocation)
    {
        [Store.adminStore deleteLocation:currentLocation
                              completion:^(BOOL success)
        {
            if (success)
            {
                currentLocation = nil;
            }
            else
            {
                [[[UIAlertView alloc] initWithTitle:@"Deletion error"
                                            message:@"Current location could not be deleted at the moment, please try again later."
                                           delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil] show];
            }
        }];
    }
}
- (IBAction)save:(id)sender
{
    BOOL inputsNotEmpty = self.nameTextField.text.length != 0 && self.mapAnnotation;
    
    if (inputsNotEmpty)
    {
        if (currentLocation)
        {
            currentLocation.name = self.nameTextField.text;
            currentLocation.latitude = [NSNumber numberWithDouble:self.mapAnnotation.coordinate.latitude];
            currentLocation.longitude = [NSNumber numberWithDouble:self.mapAnnotation.coordinate.longitude];
            
            [Store.adminStore updateLocation:currentLocation
                                  completion:^(Location *location)
             {
                 [self setCurrentLocationTo:location];
             }];
        }
        else
        {
            Location *location = [[Location alloc] init];
            location.name = self.nameTextField.text;
            location.latitude = [NSNumber numberWithDouble:self.mapAnnotation.coordinate.latitude];
            location.longitude = [NSNumber numberWithDouble:self.mapAnnotation.coordinate.longitude];
            
            [Store.adminStore createLocation:location
                                  completion:^(Location *location)
             {
                 [self setCurrentLocationTo:location];
             }];
        }
    }
    else
    {
        [[[UIAlertView alloc] initWithTitle:@"Input error"
                                    message:@"Please make sure all inputs are valid"
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}

#pragma mark - MKMapViewDelegate
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    self.mapView.showsUserLocation = NO;
    [self.mapView setRegion:[self regionForCoordinate:userLocation.coordinate]
                   animated:YES];
    
    [self.mapView removeAnnotations:self.mapView.annotations];
}
- (void)mapViewDidFinishRenderingMap:(MKMapView *)mapView fullyRendered:(BOOL)fullyRendered
{
    if (currentLocation)
    {
        [self addCurrentLocationAnnotation:nil];
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

#pragma mark - Queries
- (id <MKAnnotation>)mapAnnotation
{
    if (self.mapView.annotations.count > 0)
    {
        return self.mapView.annotations[0];
    }
    else
    {
        return nil;
    }
}

#pragma mark - Extracted methods
- (MKCoordinateRegion)regionForCoordinate:(CLLocationCoordinate2D)coordinate
{
    return MKCoordinateRegionMakeWithDistance(coordinate, 1000, 1000);
}
- (void)setInputsToCurrentLocation
{
    self.nameTextField.text = currentLocation.name;
    [self.mapView setRegion:[self regionForCoordinate:CLLocationCoordinate2DMake(currentLocation.latitude.doubleValue,
                                                                                 currentLocation.longitude.doubleValue)]
                   animated:YES];
}
- (void)setCurrentLocationTo:(Location *)location
{
    if (location)
    {
        currentLocation = location;
    }
    else
    {
        [[[UIAlertView alloc] initWithTitle:@"Update error"
                                    message:@"Current location could not be saved at the moment, please try again later."
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}

@end
