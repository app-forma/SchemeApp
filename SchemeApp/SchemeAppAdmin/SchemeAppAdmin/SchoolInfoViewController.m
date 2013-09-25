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
    MKPointAnnotation *currentLocationAnnotation;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (Store.mainStore.currentLocation)
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
    if (!self.mapHasAnnotation)
    {
        CLLocationCoordinate2D coordinate;
        if (recognizer)
        {
            CGPoint tappedPoint = [recognizer locationInView:self.mapView];
            coordinate = [self.mapView convertPoint:tappedPoint toCoordinateFromView:self.mapView];
        }
        else
        {
            coordinate = CLLocationCoordinate2DMake(Store.mainStore.currentLocation.latitude.doubleValue,
                                                    Store.mainStore.currentLocation.longitude.doubleValue);
        }
        
        MKPointAnnotation *pa = [[MKPointAnnotation alloc] init];
        pa.coordinate = coordinate;
        
        [self.mapView addAnnotation:pa];
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
#warning Testing
//    [self addCurrentLocationAnnotation:nil];
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
- (BOOL)mapHasAnnotation
{
    return self.mapView.annotations.count > 0;
}
- (id <MKAnnotation>)mapAnnotation
{
    if (self.mapHasAnnotation)
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
    self.nameTextField.text = Store.mainStore.currentLocation.name;
    [self.mapView setRegion:[self regionForCoordinate:CLLocationCoordinate2DMake(Store.mainStore.currentLocation.latitude.doubleValue,
                                                                                 Store.mainStore.currentLocation.longitude.doubleValue)]
                   animated:YES];
}

@end
