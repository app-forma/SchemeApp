//
//  StudentMessageViewController.m
//  SchemeApp
//
//  Created by Johan Thorell on 2013-09-13.
//  Copyright (c) 2013 Team leet. All rights reserved.
//

#import "StudentMessageViewController.h"
//#import "MessageCell.h"
#import "MasterMessageCell.h"
#import "Message.h"
#import "User.h"
#import "StudentMessageDetailsViewController.h"
#import "StudentAutomaticPresence.h"
#import "AwesomeUI.h"
#import "CircleImage.h"


@interface StudentMessageViewController ()<UITableViewDelegate, UITableViewDataSource, StudentMessageDetailDelegate, UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong) UIActivityIndicatorView *activityView;
@end

@implementation StudentMessageViewController
{
    NSMutableArray *messages;
    UIActionSheet *signOutPopup;
    StudentAutomaticPresence *sap;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [AwesomeUI backgroundColorForEmptyTableView];
    [AwesomeUI setGGstyleTo:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MasterMessageCell" bundle:nil] forCellReuseIdentifier:@"MasterMessageCell"];

    
    [[Store studentStore]messagesForUser:[Store mainStore].currentUser completion:^(NSArray *messagesForUser) {
        messages = [messagesForUser mutableCopy];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [self.activityView stopAnimating];
        });
    }];
    
    [self.navigationController.tabBarItem setSelectedImage:[UIImage imageNamed:@"messages_selected.png"]];
    self.navigationItem.title = @"Messages";
    self.activityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.activityView.frame = CGRectMake(150, 150, 20, 20);
    
    [self.view addSubview:self.activityView];
    if (!messages) {
        [self.activityView startAnimating];
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [messages count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 81;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"MasterMessageCell";
    MasterMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    Message *message = messages[indexPath.row];
    [AwesomeUI addDefaultStyleTo:cell];
    cell.backgroundColor = [AwesomeUI colorForIndexPath:indexPath];
    cell.nameLabel.text = message.from.fullName;
    cell.dateLabel.text = message.date.asDateString;
    cell.messageLabel.text = message.text;
    if (message.from.image) {
        [cell.userImage removeFromSuperview];
        cell.userImage = [[CircleImage alloc]initWithImageForThumbnail:message.from.image rect:CGRectMake(7, 9, 58, 58)];
        [cell addSubview:cell.userImage];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    StudentMessageDetailsViewController *studentMessageDetailsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"StudentMessageDetailsViewController"];
    studentMessageDetailsViewController.delegate = self;
    studentMessageDetailsViewController.message = messages[indexPath.row];
    [self.navigationController pushViewController:studentMessageDetailsViewController animated:YES];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self didDeleteMessage:messages[indexPath.row]];
    }
}

-(void)didDeleteMessage:(Message *)message
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:[messages indexOfObject:message] inSection:0];
    [messages removeObject:message];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [[Store studentStore]deleteMessage:message forUser:[Store mainStore].currentUser completion:^(BOOL success) {
        if (!success) {
            NSLog(@"message deletion failed.");
        }
    }];
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1.0f;
}

@end
