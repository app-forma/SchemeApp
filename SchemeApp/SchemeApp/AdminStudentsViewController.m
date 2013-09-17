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
    NSArray *users;
    User *selectedUser;
}

-(void)loadView
{
    [super loadView];
    if ([self.tabBarItem respondsToSelector:@selector(setFinishedSelectedImage:withFinishedUnselectedImage:)]) {
        [self.tabBarItem setSelectedImage:[UIImage imageNamed:@"users_selected"]];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
#warning Testing
    [Store.adminStore usersCompletion:^(NSArray *allUsers)
    {
        users = allUsers;
        [self.tableview reloadData];
        [self.activityIndicator stopAnimating];
    }];
//    [Store.adminStore userWithType:StudentRole completion:^(NSArray *students)
//     {
//         users = students;
//         [self.tableview reloadData];
//         [self.activityIndicator stopAnimating];
//     }];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
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

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedUser = users[indexPath.row];
}




@end
