//
//  AdminStudentsViewController.m
//  SchemeApp
//
//  Created by Marcus Norling on 9/12/13.
//  Copyright (c) 2013 Team leet. All rights reserved.
//

#import "AdminStudentsViewController.h"
#import "AdminEditStudentViewController.h"
#import "User.h"


@interface AdminStudentsViewController ()

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end


@implementation AdminStudentsViewController
{
    NSMutableArray *users;
    User *selectedUser;
}

-(void)loadView
{
    [super loadView];
    [self.navigationController.tabBarItem setSelectedImage:[UIImage imageNamed:@"users_selected"]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [Store.adminStore usersCompletion:^(NSArray *allUsers)
     {
         users = [NSMutableArray arrayWithArray:allUsers];
         [NSOperationQueue.mainQueue addOperationWithBlock:^
         {
             [self.tableview reloadData];
             [self.activityIndicator stopAnimating];
         }];
     }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
#warning Testing
    NSLog(@"Id: %@", segue.identifier);
    NSLog(@"Role: %d", selectedUser.role);
    if([segue.identifier isEqualToString:@"EditUser"])
    {
        NSLog(@"User: %@", selectedUser);
        AdminEditStudentViewController *viewController = segue.destinationViewController;
        viewController.selectedUser = selectedUser;
    }
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return users.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = [users[indexPath.row] firstname];
    
    return cell;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedUser = users[indexPath.row];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [Store.superAdminStore deleteUser:selectedUser
                               completion:^(id jsonObject, id response, NSError *error)
        {
            if (error)
            {
                [NSOperationQueue.mainQueue addOperationWithBlock:^
                {
                    [self.tableview reloadData];
                    [[[UIAlertView alloc] initWithTitle:@"Deletion error"
                                               message:error.localizedDescription
                                              delegate:nil
                                     cancelButtonTitle:@"OK"
                                     otherButtonTitles:nil] show];
                }];
            }
            else
            {
                [users removeObject:selectedUser];
                [NSOperationQueue.mainQueue addOperationWithBlock:^
                 {
                     [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                 }];
            }
        }];
    }
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedUser = users[indexPath.row];
}

@end
