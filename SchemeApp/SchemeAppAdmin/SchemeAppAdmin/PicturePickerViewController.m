//
//  PicturePickerViewController.m
//  SchemeAppAdmin
//
//  Created by Marcus Norling on 9/30/13.
//  Copyright (c) 2013 Marcus Norling. All rights reserved.
//

#import "PicturePickerViewController.h"

@interface PicturePickerViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
- (IBAction)showCamera:(id)sender;
- (IBAction)showLibrary:(id)sender;

@end

@implementation PicturePickerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        if (self.image) {
            self.imageView.image = self.image;
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showCamera:(id)sender {
}

- (IBAction)showLibrary:(id)sender {
}
@end
