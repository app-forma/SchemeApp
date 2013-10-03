//
//  PicturePickerStoryboardViewController.m
//  SchemeApp
//
//  Created by Marcus Norling on 10/3/13.
//  Copyright (c) 2013 Team leet. All rights reserved.
//

#import "PicturePickerStoryboardViewController.h"
#import "PicturePickerViewController.h"

@interface PicturePickerStoryboardViewController ()<PicturePickerDelegate>
{
    PicturePickerViewController *picturePicker;
}
@property (weak, nonatomic) IBOutlet UIView *storyboardView;

@end

@implementation PicturePickerStoryboardViewController

#pragma mark - Picture picker delegate
-(void)picturePicker:(PicturePickerViewController *)picturePicker didFinishPickingPicture:(UIImage *)image forUser:(User *)user
{
    user.image = image;
    [[Store superAdminStore] updateUser:user completion:^(id responseBody, id response, NSError *error) {
        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
        NSInteger statusCode = [httpResponse statusCode];
        if (statusCode == 200) {
            [self.tabBarController.tabBar setHidden:NO];
            [self.tabBarController setSelectedIndex:0];
        } else {
            NSLog(@"Error saving image: %@", error);
        }
    }];
}

-(void)picturePickerDidCancel
{
    [self.tabBarController.tabBar setHidden:NO];    
    [self.tabBarController setSelectedIndex:0];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tabBarController.tabBar setHidden:YES];
    picturePicker = [[PicturePickerViewController alloc] init];
    picturePicker.delegate = self;
    picturePicker.user = [Store mainStore].currentUser;
    [self.navigationController pushViewController:picturePicker animated:YES];
    [self.navigationController.navigationBar setHidden:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setHidden:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
/*
 #pragma mark - ImagePicker delegate and actions
 -(void)picturePickerDidCancel
 {
 [self dismissViewControllerAnimated:YES completion:nil];
 }
 
 -(void)picturePicker:(PicturePickerViewController *)picturePicker didFinishPickingPicture:(UIImage *)image forUser:(User *)user
 {
 self.userImage = [[CircleImage alloc] initWithImageForDetailView:image rect:imageSize];
 [self.view addSubview:self.userImage];
 user.image = image;
 [[Store superAdminStore] updateUser:user completion:^(id responseBody, id response, NSError *error) {
 NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
 NSInteger statusCode = [httpResponse statusCode];
 if (statusCode == 200) {
 [self dismissViewControllerAnimated:YES completion:nil];
 } else {
 #warning add error msg
 NSLog(@"Error saving image: %@", error);
 }
 }];
 }
 
 - (IBAction)showImagePicker:(id)sender {
 PicturePickerViewController *pickerController = [[PicturePickerViewController alloc] init];
 pickerController.user = currentUser;
 pickerController.delegate = self;
 [self presentViewController:pickerController animated:YES completion:nil];
 }
*/