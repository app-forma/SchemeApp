//
//  SchoolInfoViewController.m
//  SchemeAppAdmin
//
//  Created by Marcus Norling on 9/24/13.
//  Copyright (c) 2013 Marcus Norling. All rights reserved.
//

#import "SchoolInfoViewController.h"
#import "Location.h"


@interface SchoolInfoViewController () <UITextFieldDelegate, UIBarPositioningDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@end


@implementation SchoolInfoViewController
{
    Location *currentLocation;
    MKPointAnnotation *currentLocationAnnotation;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    currentLocationAnnotation = [[MKPointAnnotation alloc] init];
    
    [Store fetchLocationCompletion:^(Location *location) {
        currentLocation = location;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setInputsToCurrentLocation];
        });
    }];
}

-(UIBarPosition)positionForBar:(id<UIBarPositioning>)bar
{
    return UIBarPositionTopAttached;
}

#pragma mark - text field delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    return [textField resignFirstResponder];
}

#pragma mark - Actions
- (IBAction)userTapped:(UITapGestureRecognizer*)recognizer
{
    [self.mapView removeAnnotation:currentLocationAnnotation];
    
    CLLocationCoordinate2D coordinate;
    if (recognizer) {
        CGPoint tappedPoint = [recognizer locationInView:self.mapView];
        coordinate = [self.mapView convertPoint:tappedPoint toCoordinateFromView:self.mapView];
        
        if (currentLocation) {
            currentLocation.latitude = [NSNumber numberWithDouble:coordinate.latitude];
            currentLocation.longitude = [NSNumber numberWithDouble:coordinate.longitude];
        }
    } else {
        coordinate = CLLocationCoordinate2DMake(currentLocation.latitude.doubleValue,
                                                currentLocation.longitude.doubleValue);
    }
    
    currentLocationAnnotation.coordinate = coordinate;
    [self.mapView addAnnotation:currentLocationAnnotation];
}

- (IBAction)userPressedSave:(id)sender
{
    if (self.nameTextField.text.length && currentLocationAnnotation)
    {
        if (currentLocation)
        {
            currentLocation.name = self.nameTextField.text;
            currentLocation.latitude = [NSNumber numberWithDouble:currentLocationAnnotation.coordinate.latitude];
            currentLocation.longitude = [NSNumber numberWithDouble:currentLocationAnnotation.coordinate.longitude];
            
            [Store.adminStore updateLocation:currentLocation
                                  completion:^(Location *location)
             {
                 currentLocation = location;
             }];
        }
        else
        {
            Location *location = [[Location alloc] init];
            location.name = self.nameTextField.text;
            location.latitude = [NSNumber numberWithDouble:currentLocationAnnotation.coordinate.latitude];
            location.longitude = [NSNumber numberWithDouble:currentLocationAnnotation.coordinate.longitude];
            
            [Store.adminStore createLocation:location
                                  completion:^(Location *location)
             {
                 currentLocation = location;
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
        [self userTapped:nil];
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
- (MKCoordinateRegion)regionForCoordinate:(CLLocationCoordinate2D)coordinate
{
    return MKCoordinateRegionMakeWithDistance(coordinate, 1000, 1000);
}
- (void)setInputsToCurrentLocation
{
    if (currentLocation) {
        self.nameTextField.text = currentLocation.name;
        [self.mapView setRegion:[self regionForCoordinate:CLLocationCoordinate2DMake(currentLocation.latitude.doubleValue,
                                                                                     currentLocation.longitude.doubleValue)]
                       animated:YES];
        
    } else {
        self.mapView.showsUserLocation = YES;
    }
}

@end
