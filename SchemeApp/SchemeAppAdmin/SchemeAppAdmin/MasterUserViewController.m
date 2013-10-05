//
//  MasterUserViewController.m
//  SchemeAppAdmin
//
//  Created by Marcus Norling on 9/25/13.
//  Copyright (c) 2013 Marcus Norling. All rights reserved.
//

#import "MasterUserViewController.h"
#import "PopoverUserViewController.h"
#import "User.h"
#import "DetailUserViewController.h"
#import "AwesomeUI.h"
#import "CircleImage.h"
#import "MasterUserCell.h"
#import "NavigationBar.h"

@interface MasterUserViewController () <UITableViewDelegate, PopoverUserDelegate>

@property (weak, nonatomic) IBOutlet UITableView *usersTableView;
@property (weak, nonatomic) IBOutlet NavigationBar *navBar;

@end

@implementation MasterUserViewController
{
    NSMutableArray *users;
    UIPopoverController *addUserPopover;
    PopoverUserViewController *puvc;
    NSUInteger selectedIndex;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.usersTableView registerNib:[UINib nibWithNibName:@"MasterUserCell" bundle:nil] forCellReuseIdentifier:@"MasterUserCell"];
    [Store.adminStore usersCompletion:^(NSArray *allUsers)
     {
         users = [NSMutableArray arrayWithArray:allUsers];
         [NSOperationQueue.mainQueue addOperationWithBlock:^
          {
              [self.usersTableView reloadData];
              NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
              [self.usersTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
              [self tableView:self.usersTableView didSelectRowAtIndexPath:indexPath];
             
          }];
     }];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    puvc = [[PopoverUserViewController alloc] init];
    puvc.delegate = self;
    [AwesomeUI setGGstyleTo:self.usersTableView];
    self.usersTableView.backgroundColor = [UIColor whiteColor];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [users count] + 2;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [AwesomeUI setStateUnselectedfor:[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selectedIndex inSection:0]]];
    [AwesomeUI setStateSelectedfor:[tableView cellForRowAtIndexPath:indexPath]];
    [self.delegate masterUserDidSelectUser:users[indexPath.row-1]];
    selectedIndex = indexPath.row;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MasterUserCell";
    MasterUserCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (!cell) {
//        cell = [[MasterUserCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//    }
    if (indexPath.row == 0 || indexPath.row == [users count] + 1) {
        cell.backgroundColor = [AwesomeUI backgroundColorForEmptyTableView];
        cell.nameLabel.text = @"";
        cell.roleLabel.text = @"";
        return cell;
    }
    User *user = users[indexPath.row-1];

    
    cell.nameLabel.text = [NSString stringWithFormat:@"%@ %@", user.firstname, user.lastname];
    cell.roleLabel.text = [User stringFromRoleType:user.role];
    if (user.image) {
        [cell.userImage removeFromSuperview];
       cell.userImage = [[CircleImage alloc]initWithImageForThumbnail:user.image rect:CGRectMake(7, 9, 58, 58)];
        [cell addSubview:cell.userImage];
    }
    
    
    
   
    return cell;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSString *url = [NSString stringWithFormat:@"%@/%@", DB_TYPE_USER, [users[indexPath.row - 1]docID]];
        [[Store dbSessionConnection] deletePath:url withCompletion:^(id jsonObject, id response, NSError *error) {
            [self.usersTableView reloadData];
        }];
        [users removeObject:users[indexPath.row - 1]];
        [self.usersTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 64;
    }else if (indexPath.row == [users count] + 1){
        return 140;
    }
    return 81;
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [AwesomeUI colorForIndexPath:indexPath];
    if (indexPath.row == 0 || indexPath.row == [users count] + 1) {
        cell.backgroundColor = [UIColor whiteColor];
    }
    [AwesomeUI addDefaultStyleTo:cell];
}
- (IBAction)addUser:(id)sender
{
    [self showPopover:sender];
}

-(void)showPopover:(id)sender
{
    //to avoid crash if it already showing
    if (addUserPopover.popoverVisible) {
        return [addUserPopover dismissPopoverAnimated:YES];
    }
    puvc.isInEditingMode = NO;
    addUserPopover = [[UIPopoverController alloc] initWithContentViewController:puvc];
    [addUserPopover setPopoverContentSize:CGSizeMake(320, 380)];
    [addUserPopover presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}

-(void)popoverUserDismissPopover
{
    [addUserPopover dismissPopoverAnimated:YES];
}
-(void)popoverUserCreateUser:(User *)user
{
    void(^saveHandler)(void) = ^(void)
    {
        [NSOperationQueue.mainQueue addOperationWithBlock:^
         {
             [self.navigationController popViewControllerAnimated:YES];
         }];
    };
    [[Store superAdminStore] createUser:user completion:^(id responseBody, id response, NSError *error) {
        saveHandler();
        [Store.adminStore usersCompletion:^(NSArray *allUsers)
         {
             users = [NSMutableArray arrayWithArray:allUsers];
             [NSOperationQueue.mainQueue addOperationWithBlock:^
              {
                  [self.usersTableView reloadData];
                  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[users count] - 1 inSection:0];
                  [self.usersTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
                  [self tableView:self.usersTableView didSelectRowAtIndexPath:indexPath];
              }];
         }];
        
    }];
    
}
@end
