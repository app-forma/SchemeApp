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


@interface MasterUserViewController () <UITableViewDelegate, PopoverUserDelegate>

@property (weak, nonatomic) IBOutlet UITableView *usersTableView;

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
    [Store.adminStore usersCompletion:^(NSArray *allUsers)
     {
         users = [NSMutableArray arrayWithArray:allUsers];
         [NSOperationQueue.mainQueue addOperationWithBlock:^
          {
              [self.usersTableView reloadData];
              NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
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

    return [users count];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [AwesomeUI setStateUnselectedfor:[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selectedIndex inSection:0]]];
    [AwesomeUI setStateSelectedfor:[tableView cellForRowAtIndexPath:indexPath]];
    [self.delegate masterUserDidSelectUser:users[indexPath.row]];
    selectedIndex = indexPath.row;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    User *user = users[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", user.firstname, user.lastname];
#warning just temporary, initiate custom cell
    UIView *image = [[CircleImage alloc]initWithImageForThumbnail:user.image rect:CGRectMake(250,20, 60, 60)];
    [cell.contentView addSubview:image];
    return cell;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSString *url = [NSString stringWithFormat:@"%@/%@", DB_TYPE_USER, [users[indexPath.row]docID]];
        [[Store dbSessionConnection] deletePath:url withCompletion:^(id jsonObject, id response, NSError *error) {
            [self.usersTableView reloadData];
        }];
        [users removeObject:users[indexPath.row]];
        [self.usersTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [AwesomeUI tableViewCellHeight];
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [AwesomeUI colorForIndexPath:indexPath];
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
