//
//  MenuViewController.m
//  SchemeAppAdmin
//
//  Created by Marcus Norling on 9/24/13.
//  Copyright (c) 2013 Marcus Norling. All rights reserved.
//

#import "MenuViewController.h"
#import "MessageViewController.h"
#import "EventWrappersViewController.h"
#import "UsersViewController.h"
#import "SchoolInfoViewController.h"

@interface MenuViewController ()
{
    MessageViewController *messageViewController;
    EventWrappersViewController *eventWrapperViewController;
    UsersViewController *usersViewController;
    SchoolInfoViewController *schoolInfoViewController;
    NSArray *menuItems;
}
@end

@implementation MenuViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        NSDictionary *menuItem1 = @{@"label":@"School info", @"tag":@(0)};
        NSDictionary *menuItem2 = @{@"label":@"Users", @"tag":@(1)};
        NSDictionary *menuItem3 = @{@"label":@"Courses", @"tag":@(2)};
        NSDictionary *menuItem4 = @{@"label":@"Messages", @"tag":@(3)};
        menuItems = @[menuItem1, menuItem2, menuItem3, menuItem4];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [menuItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = menuItems[indexPath.row][@"label"];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UINavigationController *navCtrl = self.splitViewController.viewControllers[1];
    
    if (navCtrl.visibleViewController != [self viewControllerForIndexPath:indexPath]) {
        [self.splitViewController.viewControllers[1] pushViewController:[self viewControllerForIndexPath:indexPath] animated:NO];
    }
}

- (UIViewController *)viewControllerForIndexPath:(NSIndexPath*)indexPath
{
    switch (indexPath.row) {
        case 0:
            if (!schoolInfoViewController) {
                return [[SchoolInfoViewController alloc] init];
            }
            return schoolInfoViewController;
            break;
        case 1:
            if (!usersViewController) {
                return [[UsersViewController alloc] init];
            }
            return usersViewController;
            break;
        case 2:
            if (!eventWrapperViewController) {
                return [[EventWrappersViewController alloc] init];
            }
            return eventWrapperViewController;
            break;
        case 3:
            if (!messageViewController) {
           return [[MessageViewController alloc] init];
            }
            return messageViewController;
            break;
        default:
            break;
    }
    NSLog(@"FAIL");
    return nil;
}
@end
