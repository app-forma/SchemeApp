//
//  PicturePickerViewController.m
//  SchemeAppAdmin
//
//  Created by Marcus Norling on 9/30/13.
//  Copyright (c) 2013 Marcus Norling. All rights reserved.
//

#import "PicturePickerIPhoneViewController.h"

@interface PicturePickerIPhoneViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

- (IBAction)showCamera:(id)sender;
- (IBAction)showLibrary:(id)sender;
- (IBAction)saveChanges:(id)sender;

@end

@implementation PicturePickerIPhoneViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar setHidden:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.tabBarController.tabBar setHidden:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    self.user = [Store mainStore].currentUser;
    [self.loadIndicator stopAnimating];
    self.loadingView.hidden = YES;
    if (self.user.image) {
        self.imageView.image = self.user.image;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)showCamera:(id)sender
{
    [self showImagePickerControllerForType:UIImagePickerControllerSourceTypeCamera];
}

- (IBAction)showLibrary:(id)sender
{
    [self showImagePickerControllerForType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (IBAction)saveChanges:(id)sender {
    [self.loadIndicator startAnimating];
    self.loadingView.hidden = NO;
    
    NSLog(@"USER: %@", self.user);
    NSLog(@"EVENTWRAPPERS: %@", self.user.eventWrappers);
    
    
    [[Store superAdminStore] updateUser:self.user completion:^(id responseBody, id response, NSError *error) {
        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
        NSInteger statusCode = [httpResponse statusCode];
        if (statusCode == 200 || statusCode == 201) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.loadingView setHidden:YES];
                [self.tabBarController setSelectedIndex:3];
            });
        } else {
            NSLog(@"Error saving image: %@", error);
        }
    }];
}

- (IBAction)cancel:(id)sender {
    [self cancel];
}

- (void)cancel
{
    [self.tabBarController.tabBar setHidden:NO];
    [self.tabBarController setSelectedIndex:0];
}

- (BOOL)showImagePickerControllerForType:(UIImagePickerControllerSourceType) sourceType
{
    if([UIImagePickerController isSourceTypeAvailable:sourceType])
    {
        UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
        cameraUI.delegate = self;
        cameraUI.sourceType = sourceType;
        
        [self presentViewController:cameraUI animated:YES completion:nil];
        return YES;
    }
    
    return NO;
}


#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    self.user.image = image;
    self.imageView.image = image;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
