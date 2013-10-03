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
#import "MasterMessageCell.h"
#import "Message.h"
#import "AwesomeUI.h"
#import "CircleImage.h"
@interface AdminMessagesViewController () <UITableViewDelegate, UITableViewDataSource, MessageDetailViewDelegate, MessageCreateViewDelegate>

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation AdminMessagesViewController
{
    NSMutableArray *messages;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MasterMessageCell" bundle:nil] forCellReuseIdentifier:@"MasterMessageCell"];
    [AwesomeUI setGGstyleTo:self.tableView];    
    
    [self.navigationController.tabBarItem setSelectedImage:[UIImage imageNamed:@"messages_selected"]];
    
    self.navigationItem.title = @"Messages";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(didPressAddMessage)];

    [[Store studentStore]messagesForUser:[Store mainStore].currentUser completion:^(NSArray *messagesForUser) {
        messages = [messagesForUser mutableCopy];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MasterMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MasterMessageCell"];
    Message *message = messages[indexPath.row];
    [AwesomeUI addDefaultStyleTo:cell];
    cell.backgroundColor = [AwesomeUI colorForIndexPath:indexPath];
    cell.nameLabel.text = message.from.fullName;
    cell.dateLabel.text = message.date.asDateString;
    cell.messageLabel.text = message.text;
    UIView *image = [[CircleImage alloc]initWithImageForThumbnail:message.from.image rect:CGRectMake(260, 7, 50, 50)];
    [cell addSubview:image];
    

    return cell;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Message *message = messages[indexPath.row];
        [messages removeObject:message];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [[Store adminStore]deleteMessage:message forUser:[Store mainStore].currentUser completion:^(BOOL success) {
            if (!success) {
                NSLog(@"delete message failed");
            }
        }];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AdminMessagesDetailViewController *detailView = [self.storyboard instantiateViewControllerWithIdentifier:@"MessageDetailView"];
    detailView.message = messages[indexPath.row];
    detailView.delegate = self;
    [self.navigationController pushViewController:detailView animated:YES];
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
    [[Store adminStore]deleteMessage:message forUser:[Store mainStore].currentUser completion:^(BOOL success) {
        if (!success) {
            NSLog(@"delete message failed");
        }
    }];
}

-(void)didCreateMessage:(Message *)message
{
    [messages addObject:message];
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:messages.count - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
}


@end
