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

@interface MasterUserViewController () <UITableViewDelegate, PopoverUserDelegate>

@property (weak, nonatomic) IBOutlet UITableView *usersTableView;

@end

@implementation MasterUserViewController
{
    NSMutableArray *users;
    UIPopoverController *addUserPopover;
    PopoverUserViewController *puvc;
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
    [self.delegate masterUserDidSelectUser:users[indexPath.row]];
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


- (IBAction)addUser:(id)sender
{
    [self showPopover:sender];
}

-(void)showPopover:(id)sender
{
    puvc.isInEditingMode = NO;
    addUserPopover = [[UIPopoverController alloc] initWithContentViewController:puvc];
    [addUserPopover setPopoverContentSize:CGSizeMake(320, 380)];
    [addUserPopover presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}

-(void)dismissPopover
{
    [addUserPopover dismissPopoverAnimated:YES];
}

@end
