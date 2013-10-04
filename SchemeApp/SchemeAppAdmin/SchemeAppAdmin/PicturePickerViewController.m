//
//  PicturePickerViewController.m
//  SchemeAppAdmin
//
//  Created by Marcus Norling on 9/30/13.
//  Copyright (c) 2013 Marcus Norling. All rights reserved.
//

#import "PicturePickerViewController.h"

@interface PicturePickerViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

- (IBAction)showCamera:(id)sender;
- (IBAction)showLibrary:(id)sender;
- (IBAction)saveChanges:(id)sender;
- (IBAction)cancel:(id)sender;

@end

@implementation PicturePickerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
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
    if (self.user.image) {
        [self.delegate picturePicker:self didFinishPickingPicture:self.user.image forUser:self.user];
    } else {
        [self.delegate picturePickerDidCancel];
    }
}

- (IBAction)cancel:(id)sender {
    [self.delegate picturePickerDidCancel];
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
