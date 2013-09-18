//
//  AdminMessageViewController.m
//  SchemeApp
//
//  Created by Marcus Norling on 9/12/13.
//  Copyright (c) 2013 Team leet. All rights reserved.
//

#import "AdminMessagesViewController.h"
#import "AdminMessagesDetailViewController.h"
#import "AdminMessagesCreateMessageViewController.h"
#import "MessageCell.h"
#import "Message.h"
@interface AdminMessagesViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation AdminMessagesViewController
{
    NSMutableArray *messages;
    Message *selectedMessage;
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}

-(void)loadView
{
    [super loadView];
    [self.navigationController.tabBarItem setSelectedImage:[UIImage imageNamed:@"messages_selected"]];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    messages = Store.mainStore.currentUser.messages;

    self.navigationItem.title = @"Messages";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(didPressAddMessage)];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    if(indexPath) {
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

#pragma mark table view
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return messages.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageCell"];
    Message *message = messages[indexPath.row];
    cell.dateLabel.text = [Helpers stringFromNSDate:message.date];
    cell.messageTextView.text = message.text;
    cell.nameLabel.text = message.from;
    return cell;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSLog(@"delete");
    }
}

-(void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedMessage = messages[indexPath.row];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    AdminMessagesDetailViewController *detailView = (AdminMessagesDetailViewController*)segue.destinationViewController;
    detailView.message = selectedMessage;
}

-(void)didPressAddMessage
{
    AdminMessagesCreateMessageViewController *createView = [self.storyboard instantiateViewControllerWithIdentifier:@"CreateMessageView"];
    [self presentViewController:createView animated:YES completion:nil];
}

@end
