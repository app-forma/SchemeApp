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


@interface AdminStudentsViewController () <UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong) UIActivityIndicatorView *activityView;
@end

@implementation AdminStudentsViewController
{
    NSMutableArray *users;
    User *selectedUser;
    
    BOOL isFiltered;
    NSMutableArray *filteredUsers;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController.tabBarItem setSelectedImage:[UIImage imageNamed:@"users_selected"]];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.activityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.activityView.frame = CGRectMake(150, 150, 20, 20);
    
    [self.view addSubview:self.activityView];
    if (!users) {
        [self.activityView startAnimating];
    }
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
             [self.activityView stopAnimating];
         }];
     }];
}

#pragma mark Search Bar delegate

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length == 0) {
        isFiltered = NO;
    } else {
        isFiltered = YES;
        filteredUsers = [NSMutableArray new];
        for (User *user in users) {
            NSRange textRange = [user.fullName rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if (textRange.location != NSNotFound) {
                [filteredUsers addObject:user];
            }
        }
    }
    [self.tableview reloadData];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return isFiltered ? filteredUsers.count : users.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text =  isFiltered ? [filteredUsers[indexPath.row]fullName] : [users[indexPath.row] fullName];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedUser = isFiltered ? filteredUsers[indexPath.row] : users[indexPath.row];
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
    selectedUser = isFiltered ? filteredUsers[indexPath.row] : users[indexPath.row];
}

@end
