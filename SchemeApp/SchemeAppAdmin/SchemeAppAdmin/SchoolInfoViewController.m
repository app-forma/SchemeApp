//
//  SchoolInfoViewController.m
//  SchemeAppAdmin
//
//  Created by Marcus Norling on 9/24/13.
//  Copyright (c) 2013 Marcus Norling. All rights reserved.
//

#import "SchoolInfoViewController.h"

@import MapKit;


@interface SchoolInfoViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@end


@implementation SchoolInfoViewController

- (void)viewDidLoad
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (IBAction)save:(id)sender
{
#warning Implement
    
}

@end
