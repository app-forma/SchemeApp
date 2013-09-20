//
//  StudentMessageViewController.m
//  SchemeApp
//
//  Created by Johan Thorell on 2013-09-13.
//  Copyright (c) 2013 Team leet. All rights reserved.
//

#import "StudentMessageViewController.h"
#import "MessageCell.h"
#import "Message.h"
#import "User.h"
#import "Helpers.h"
#import "StudentMessageDetailsViewController.h"

@interface StudentMessageViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation StudentMessageViewController
{
    //for testing:
    NSArray *messages;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    messages = Store.mainStore.currentUser.messages;
    [self.navigationController.tabBarItem setSelectedImage:[UIImage imageNamed:@"messages_selected.png"]];
    self.navigationItem.title = @"Messages";
    
    // Sign out
    UIBarButtonItem *signOutButton = [[UIBarButtonItem alloc] initWithTitle:@"Sign Out" style:UIBarButtonItemStylePlain target:self action:@selector(signOut)];
    self.navigationItem.rightBarButtonItem = signOutButton;
}

-(void)signOut
{
    UIStoryboard *loginSb = [UIStoryboard storyboardWithName:@"LoginStoryboard" bundle:nil];
    UIViewController *initialLoginVC = [loginSb instantiateInitialViewController];
    initialLoginVC.modalTransitionStyle = UIModalPresentationFullScreen;
    [self presentViewController:initialLoginVC animated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [messages count]; // returnera antalet meddelanden som finns tillgängliga för eleven. MessageStore?
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Skapa en custom cell. Lärarens namn, datum och början av meddelandet.
    
    static NSString *cellId = @"MessageCell";
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    
    Message *message = messages[indexPath.row];
    cell.nameLabel.text = [NSString stringWithFormat:@"%@ %@",  message.from.firstname, message.from.lastname];
    cell.dateLabel.text = [Helpers stringFromNSDate:message.date];
    cell.messageTextView.text = message.text;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    StudentMessageDetailsViewController *studentMessageDetailsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"StudentMessageDetailsViewController"];
    
    MessageCell *cell = (MessageCell *)[tableView cellForRowAtIndexPath:indexPath];
    studentMessageDetailsViewController.message = cell.messageTextView.text;
    studentMessageDetailsViewController.from = cell.nameLabel.text;
    studentMessageDetailsViewController.date = [Helpers dateFromString:cell.dateLabel.text];
    
    
    [self.navigationController pushViewController:studentMessageDetailsViewController animated:YES];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 81;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1.0f;
}


@end
