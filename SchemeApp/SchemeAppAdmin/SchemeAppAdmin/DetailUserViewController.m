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
#import "CircleImage.h"
#import "AttendanceViewController.h"
#import "EventWrappersForUserViewController.h"
#import "AwesomeUI.h"

@interface DetailUserViewController ()<PopoverUserDelegate, PicturePickerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *roleLabel;
@property (weak, nonatomic) IBOutlet UINavigationItem *navItem;
@property (strong, nonatomic) IBOutlet UIView *userImage;
@property (weak, nonatomic) IBOutlet UIButton *coursesButton;
- (IBAction)showImagePicker:(id)sender;




@end

@implementation DetailUserViewController
{
    UIButton *addButton;
    UIButton *editButton;
    UIBarButtonItem *attendanceButton;
    UIPopoverController *userInfoPopover;
    UIPopoverController *attendancePopover;
    UIPopoverController *eventWrappersForUserPopover;
    PopoverUserViewController *puvc;
    User *currentUser;
    CGRect imageSize;
    
    NSArray *eventWrappers;
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
        imageSize = CGRectMake(100, 154, 160, 160);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    attendanceButton = [[UIBarButtonItem alloc]initWithTitle:@"Attendance" style:UIBarButtonItemStylePlain target:self action:@selector(didPressAttendance:)];
    
    [[Store adminStore]eventWrappersCompletion:^(NSArray *allEventWrappers) {
        eventWrappers = allEventWrappers;
    }];    
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
    [self.userImage removeFromSuperview];
    self.navItem.title = [NSString stringWithFormat:@"%@ %@", user.firstname, user.lastname];
    self.nameLabel.text = [NSString stringWithFormat:@"%@ %@", user.firstname, user.lastname];
    self.emailLabel.text = user.email;
    self.roleLabel.text = [user roleAsString];
    if (user.image) {
        CircleImage *userImage = [[CircleImage alloc]initWithImageForDetailView:user.image rect:imageSize];
        self.userImage = userImage;
        [self.view addSubview:self.userImage];
    } else {
        self.userImage = nil;
    }
    [self updateButtonVisibilityForUser:user];
    
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
    [self updateButtonVisibilityForUser:user];
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

- (IBAction)didPressCourses:(UIButton *)sender {
    if (eventWrappersForUserPopover.popoverVisible) {
        return [eventWrappersForUserPopover dismissPopoverAnimated:YES];
    }
    EventWrappersForUserViewController *coursesTable = [[EventWrappersForUserViewController alloc]initWithUser:currentUser eventWrappers:eventWrappers];
    eventWrappersForUserPopover = [[UIPopoverController alloc]initWithContentViewController:coursesTable];
    [eventWrappersForUserPopover setPopoverContentSize:CGSizeMake(300, 500)];
    [eventWrappersForUserPopover presentPopoverFromRect:sender.bounds inView:sender.viewForBaselineLayout permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}

-(void)didPressAttendance:(UIBarButtonItem*)sender {
    if (attendancePopover.popoverVisible) {
        return [attendancePopover dismissPopoverAnimated:YES];
    }
    AttendanceViewController *attendanceTable = [AttendanceViewController new];
    attendanceTable.user = currentUser;
    attendancePopover = [[UIPopoverController alloc] initWithContentViewController:attendanceTable];
    [attendancePopover setPopoverContentSize:CGSizeMake(300, 500)];
    [attendancePopover presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];

}

-(void)updateButtonVisibilityForUser:(User*)user {
    if (user.role == StudentRole) {
        [self.navItem setLeftBarButtonItem:attendanceButton animated:YES];
        self.coursesButton.enabled = YES;
        [UIView animateWithDuration:0.25 animations:^{
            self.coursesButton.alpha = 1;
        }];
    } else {
        [self.navItem setLeftBarButtonItem:nil animated:YES];
        self.coursesButton.enabled = NO;
        [UIView animateWithDuration:0.25 animations:^{
            self.coursesButton.alpha = 0;
        }];
    }
}

@end
