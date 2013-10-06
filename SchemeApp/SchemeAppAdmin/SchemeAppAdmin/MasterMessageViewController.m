//
//  MasterMessageViewController.m
//  SchemeAppAdmin
//
//  Created by Marcus Norling on 9/25/13.
//  Copyright (c) 2013 Marcus Norling. All rights reserved.
//

#import "MasterMessageViewController.h"
#import "CreateMessageViewController.h"
#import "AwesomeUI.h"
#import "CircleImage.h"
#import "UIImage+Base64.h"
#import "MasterMessageCell.h"

@interface MasterMessageViewController () <UITableViewDataSource, UITableViewDelegate, CreateMessageViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MasterMessageViewController
{
    NSMutableArray *messages;
    UIPopoverController *createMessagePopover;
    NSIndexPath *selectedIndexPath;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MasterMessageCell" bundle:nil] forCellReuseIdentifier:@"MasterMessageCell"];
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    [[Store adminStore]messagesForUser:[Store mainStore].currentUser completion:^(NSArray *messagesForUser) {
        messages = [messagesForUser mutableCopy];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
    
    [AwesomeUI setGGstyleTo:self.tableView];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return messages.count + 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 64;
    }else if (indexPath.row == [messages count] + 1){
        return 140;
    }
    return 81;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MasterMessageCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"MasterMessageCell"];
    if (indexPath.row == 0 || indexPath.row == [messages count] + 1) {
                [cell.userImage removeFromSuperview];
        cell.backgroundColor = [UIColor whiteColor];
        cell.nameLabel.text = @"";
        cell.messageLabel.text = @"";
        cell.dateLabel.text = @"";
        return cell;
    }
    Message *message = messages[indexPath.row - 1];
    
    [AwesomeUI addColorAndDefaultStyleTo:cell forIndexPath:indexPath];
    cell.nameLabel.text = [message.from fullName];
    cell.messageLabel.text = message.text;
    cell.dateLabel.text = message.date.asDateString;
    if (message.from.image) {
        [cell.userImage removeFromSuperview];
        cell.userImage = [[CircleImage alloc]initWithImageForThumbnail:message.from.image rect:CGRectMake(7, 9, 58, 58)];
            [cell addSubview:cell.userImage];
    }


    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [AwesomeUI setStateUnselectedfor:[self.tableView cellForRowAtIndexPath:selectedIndexPath]];
    [AwesomeUI setStateSelectedfor:[self.tableView cellForRowAtIndexPath:indexPath]];
    [self.delegate didSelectMessage:messages[indexPath.row-1]];
    selectedIndexPath = indexPath;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Message *message = messages[indexPath.row-1];
        [messages removeObject:message];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [[Store adminStore]deleteMessage:message forUser:[Store mainStore].currentUser completion:^(BOOL success) {
            if (!success) {
                NSLog(@"delete message failed");
            }
        }];
    }
}

#pragma callbacks
- (IBAction)didPressAdd:(id)sender {
    if (createMessagePopover.popoverVisible) {
        return [createMessagePopover dismissPopoverAnimated:YES];
    }
    UIStoryboard *createMessageStoryboard = [UIStoryboard storyboardWithName:@"CreateMessage" bundle:nil];
    CreateMessageViewController *createMessageView = [createMessageStoryboard instantiateInitialViewController];
    createMessageView.delegate = self;
    createMessagePopover = [[UIPopoverController alloc] initWithContentViewController:createMessageView];
    [createMessagePopover setPopoverContentSize:CGSizeMake(300, 500)];
    [createMessagePopover presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}

-(void)didCreateMessage
{
    [createMessagePopover dismissPopoverAnimated:YES];
}

-(void)didCreateAndGetMessage:(Message *)message
{
    [messages addObject:message];
    dispatch_async(dispatch_get_main_queue(), ^{
        [createMessagePopover dismissPopoverAnimated:YES];
        NSIndexPath *thisIndexPath = [NSIndexPath indexPathForItem:messages.count - 1 inSection:0];
        [self.delegate didSelectMessage:message];
        [self.tableView insertRowsAtIndexPaths:@[thisIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView selectRowAtIndexPath:thisIndexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    });
}

@end
