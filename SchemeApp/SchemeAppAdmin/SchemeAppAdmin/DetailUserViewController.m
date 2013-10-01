//
//  DetailUserViewController.m
//  SchemeAppAdmin
//
//  Created by Marcus Norling on 9/25/13.
//  Copyright (c) 2013 Marcus Norling. All rights reserved.
//

#import "DetailUserViewController.h"
#import "MasterUserViewController.h"
#import "UIButton+CustomButton.h"
#import "PopoverUserViewController.h"
#import "PicturePickerViewController.h"

@interface DetailUserViewController ()<PopoverUserDelegate, PicturePickerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *roleLabel;
@property (weak, nonatomic) IBOutlet UINavigationItem *navItem;
- (IBAction)showImagePicker:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;

@end

@implementation DetailUserViewController
{
    UIButton *addButton;
    UIButton *editButton;
    UIPopoverController *userInfoPopover;
    PopoverUserViewController *puvc;
    User *currentUser;
}


- (void)splitViewController:(UISplitViewController *)svc
     willHideViewController:(UIViewController *)aViewController
          withBarButtonItem:(UIBarButtonItem *)barButtonItem
       forPopoverController:(UIPopoverController *)pc
{
}


- (void)splitViewController:(UISplitViewController *)svc
     willShowViewController:(UIViewController *)aViewController
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        puvc = [[PopoverUserViewController alloc] init];
        puvc.delegate = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    // Do any additional setup after loading the view from its nib.
}

-(BOOL)splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation
{
    return NO;
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    editButton = [UIButton customButtonWithIconImage:[UIImage imageNamed:@"editIcon"] tag:2];
    [editButton addTarget:self action:@selector(editUser:) forControlEvents:UIControlEventTouchUpInside];
    
    editButton.translatesAutoresizingMaskIntoConstraints = NO;

    [self.view addSubview:editButton];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(editButton);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[editButton(50.0)]-(25.0)-|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(50.0)-[editButton(90.0)]" options:0 metrics:nil views:views]];
}

- (void)editUser:(id)sender
{
    [self showPopover:sender for:@"edit"];
}

-(User *)popoverUserCurrentUser
{
    return currentUser;
}
- (IBAction)deleteUser:(id)sender
{
    NSLog(@"Delete this fucking USELESS USER SON OF STUDENT!");
}

-(void)showPopover:(id)sender for:(NSString *)method
{
    puvc.isInEditingMode = YES;
    
    userInfoPopover = [[UIPopoverController alloc] initWithContentViewController:puvc];
    UIButton *senderButton = (UIButton *)sender;
    [userInfoPopover setPopoverContentSize:CGSizeMake(320, 350)];
    [userInfoPopover presentPopoverFromRect:senderButton.bounds inView:senderButton permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
}

-(void)masterUserDidSelectUser:(User *)user
{
    self.navItem.title = [NSString stringWithFormat:@"%@ %@", user.firstname, user.lastname];
    self.nameLabel.text = [NSString stringWithFormat:@"%@ %@", user.firstname, user.lastname];
    self.emailLabel.text = user.email;
    self.roleLabel.text = [user roleAsString];
    if (user.image) {
        self.userImage.image = user.image;
    } else {
        self.userImage.image = nil;
    }
    currentUser = user;
    
}

-(void)popoverUserUpdateUser:(User *)user
{
    void(^saveHandler)(void) = ^(void)
    {
        [NSOperationQueue.mainQueue addOperationWithBlock:^
         {
             [self.navigationController popViewControllerAnimated:YES];
         }];
    };
    
    [[Store superAdminStore] updateUser:user completion:^(id responseBody, id response, NSError *error) {
        saveHandler();
    }];
}
-(void)popoverUserDismissPopover
{
    [userInfoPopover dismissPopoverAnimated:YES];
}

#pragma mark - ImagePicker delegate and actions
-(void)picturePickerDidCancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)picturePicker:(PicturePickerViewController *)picturePicker didFinishPickingPicture:(UIImage *)image forUser:(User *)user
{
    self.userImage.image = image;
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
@end
