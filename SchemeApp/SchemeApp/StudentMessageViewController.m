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
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MasterMessageCell" bundle:nil] forCellReuseIdentifier:@"MasterMessageCell"];
    [AwesomeUI setGGstyleTo:self.tableView];
    
    [[Store studentStore]messagesForUser:[Store mainStore].currentUser completion:^(NSArray *messagesForUser) {
        messages = [messagesForUser mutableCopy];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
    
    [self.navigationController.tabBarItem setSelectedImage:[UIImage imageNamed:@"messages_selected.png"]];
    self.navigationItem.title = @"Messages";
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [messages count];
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
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
    UIView *image = [[CircleImage alloc]initWithImageForThumbnail:message.from.image rect:CGRectMake(260, 7, 50, 50)];
    [cell addSubview:image];
    
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 81;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1.0f;
}

@end
