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
#import "NavigationBar.h"

@interface MasterUserViewController () <UITableViewDelegate, PopoverUserDelegate>

@property (weak, nonatomic) IBOutlet UITableView *usersTableView;
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;

@end

@implementation MasterUserViewController
{
    NSMutableArray *users;
    UIPopoverController *addUserPopover;
    PopoverUserViewController *puvc;
    NSArray *colorForRow;
    NSUInteger selectedRow;
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
    colorForRow = @[[UIColor colorWithRed:239/255.0f green:148/255.0f blue:71/255.0f alpha:1.0f], [UIColor colorWithRed:243/255.0f green:82/255.0f blue:66/255.0f alpha:1.0f], [UIColor colorWithRed:221/255.0f green:49/255.0f blue:91/255.0f alpha:1.0f], [UIColor colorWithRed:155/255.0f green:49/255.0f blue:97/255.0f alpha:1.0f], [UIColor colorWithRed:67/255.0f green:46/255.0f blue:56/255.0f alpha:1.0f]];
    self.usersTableView.separatorColor = [UIColor clearColor];
    self.usersTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = colorForRow[indexPath.row%5];
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:22];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}
- (NSString *)tableView:(UITableView *)aTableView titleForHeaderInSection:(NSInteger)section
{
    return @"Users";
}

//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//
//    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 244, 40)];
//    
//    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(20, 0, 30, 30)];
//    button.titleLabel.text = @"Add";
//    button.titleLabel.textColor = [UIColor blackColor];
//    [button addTarget:self action:@selector(showPopover:) forControlEvents:UIControlEventTouchUpInside];
//    [view addSubview:button];
//    return view;
//    
//}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell *prevCell= [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selectedRow inSection:0]];
    prevCell.layer.borderColor = [UIColor clearColor].CGColor;
    prevCell.layer.borderWidth = 0;
    
    UITableViewCell *selCell = [tableView cellForRowAtIndexPath:indexPath];
    
    selCell.layer.borderColor = [UIColor whiteColor].CGColor;
    selCell.layer.borderWidth = 1;
    selCell.layer.cornerRadius = 2;
    
    
    
    [self.delegate masterUserDidSelectUser:users[indexPath.row]];
    selectedRow = indexPath.row;
    
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
