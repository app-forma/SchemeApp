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
@interface AdminMessagesViewController () <UITableViewDelegate, UITableViewDataSource, MessageDetailViewDelegate, MessageCreateViewDelegate>

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
    cell.nameLabel.text = [NSString stringWithFormat:@"%@ %@", message.from.firstname, message.from.lastname];
    return cell;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [messages removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [[Store adminStore]updateMessages:messages forUser:[Store mainStore].currentUser];
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
    detailView.delegate = self;
}

-(void)didPressAddMessage
{
    AdminMessagesCreateMessageViewController *createView = [self.storyboard instantiateViewControllerWithIdentifier:@"CreateMessageView"];
    createView.delegate = self;
    [self presentViewController:createView animated:YES completion:nil];
}

#pragma mark - detail view delegate method
-(void)willdeleteMessage:(Message *)message
{
    [messages removeObject:message];
    [self.tableView reloadData];
    [[Store adminStore]updateMessages:messages forUser:[Store mainStore].currentUser];
}

-(void)didCreateMessage:(Message *)message
{
    [messages addObject:message];
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:messages.count - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
}


@end
