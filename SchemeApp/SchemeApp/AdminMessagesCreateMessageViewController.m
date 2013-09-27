//
//  AdminMessagesCreateMessageViewController.m
//  SchemeApp
//
//  Created by Erik Österberg on 2013-09-17.
//  Copyright (c) 2013 Team leet. All rights reserved.
//

#define MESSAGE_TYPE 0
#define MAILING_TYPE 1

#define RECIPIENTS_SECTION 0
#define SEARCH_SECTION 1
#define SUGGESTIONS_SECTION 2

#import "AdminMessagesCreateMessageViewController.h"
#import "SearchCell.h"
#import "ReceiverCell.h"
#import "Message.h"
#import "User.h"
#import "Helpers.h"

@interface AdminMessagesCreateMessageViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
@property (weak, nonatomic) IBOutlet UISegmentedControl *messageTypeControl;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation AdminMessagesCreateMessageViewController
{
    UIBarButtonItem *sendButton;
    
    NSArray *users;
    NSMutableArray *receivers;
    NSMutableArray *suggestedUsers;

    UIColor *lightGrayColor;
    UIColor *whiteColor;
}
-(BOOL)prefersStatusBarHidden { return YES; }

- (void)viewDidLoad
{
    [super viewDidLoad];

    lightGrayColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1];
    whiteColor = [UIColor whiteColor];
    
    self.textView.layer.borderWidth = 1.0f;
    self.textView.layer.borderColor = [[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1]CGColor];
    self.textView.layer.cornerRadius = 7.0f;
    
    UINavigationItem *navItem = [[UINavigationItem alloc]initWithTitle:@"New message"];
    navItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(didPressCancel)];
    sendButton = [[UIBarButtonItem alloc]initWithTitle:@"Send" style:UIBarButtonItemStyleDone target:self action:@selector(didPressSend)];
    navItem.rightBarButtonItem = sendButton;
    [self.navBar pushNavigationItem:navItem animated:NO];
    
    [self.messageTypeControl addTarget:self action:@selector(messageTypeDidChange:) forControlEvents:UIControlEventValueChanged];
    
    receivers = [NSMutableArray new];
    users = [NSArray new];
    
    [[Store adminStore]usersCompletion:^(NSArray *allUsers) {
        users = allUsers;
    }];
        
    [self.tableView reloadData];
}

#pragma mark - textfield delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}

-(void)textFieldDidChange :(UITextField *)textField{
    NSMutableArray *filteredSuggestions = [NSMutableArray new];
    if (textField.text.length > 0) {
        for (User *user in users) {
            NSRange firstNameRange = [user.firstname rangeOfString:textField.text options:NSCaseInsensitiveSearch];
            NSRange lastNameRange = [user.lastname rangeOfString:textField.text options:NSCaseInsensitiveSearch];
            if ((firstNameRange.location != NSNotFound || lastNameRange.location != NSNotFound) && ![receivers containsObject:user]) {
                [filteredSuggestions addObject:user];
            }
        }
    }
    if (![filteredSuggestions isEqualToArray:suggestedUsers]) {
        suggestedUsers = filteredSuggestions;
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:SUGGESTIONS_SECTION] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

#pragma mark - table view
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.messageTypeControl.selectedSegmentIndex == MESSAGE_TYPE ? 3 : 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.section == SEARCH_SECTION ? 44 : 33;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == RECIPIENTS_SECTION) { return receivers.count; }
    if (section == SUGGESTIONS_SECTION) { return suggestedUsers.count; }
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    if (section == SEARCH_SECTION) {
        SearchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchCell" forIndexPath:indexPath];
        cell.textField.delegate = self;
        [cell.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        return cell;
    }
    static NSString *cellIdentifier = @"ReceiverCell";
    ReceiverCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    User *user = section == SUGGESTIONS_SECTION ? suggestedUsers[indexPath.row] : receivers[indexPath.row];
    cell.accessoryType = section == RECIPIENTS_SECTION ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    cell.backgroundColor = section == SUGGESTIONS_SECTION ? lightGrayColor : whiteColor;
    cell.nameLabel.text = [NSString stringWithFormat:@"%@ %@", user.firstname, user.lastname];
    cell.roleLabel.text = [user roleTypeAsString];
    return cell;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.section == RECIPIENTS_SECTION ? YES : NO;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [receivers removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.section == SUGGESTIONS_SECTION ? YES : NO;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == SUGGESTIONS_SECTION) {
        [receivers addObject:suggestedUsers[indexPath.row]];

        [tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:receivers.count -
                                             1 inSection:RECIPIENTS_SECTION]] withRowAnimation:UITableViewRowAnimationAutomatic];
        [suggestedUsers removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];        
    }
}

#pragma mark - events
-(void)messageTypeDidChange:(UISegmentedControl*)control
{
    [self.tableView reloadData];
}

-(void)didPressCancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didPressSend {
    if (self.textView.text.length < 3) { return; }
    sendButton.enabled = NO;
    
    Message *message = [[Message alloc]init];
    message.text = self.textView.text;
    message.from = Store.mainStore.currentUser;;
    message.date = [NSDate date];
    
    if (self.messageTypeControl.selectedSegmentIndex == MESSAGE_TYPE) {
        [[Store adminStore]sendMessage:message toUsers:receivers completion:^(Message *message) {
            [[NSOperationQueue mainQueue]addOperationWithBlock:^{
                NSPredicate *containsUser = [NSPredicate predicateWithFormat:@"self.email matches %@", [Store mainStore].currentUser.email];
                [receivers filteredArrayUsingPredicate:containsUser].count > 0 ? [self returnToMessageViewAndSetMessage:message] : [self dismissViewControllerAnimated:YES completion:nil];
            }];
        }];
    } else {
        [[Store adminStore]broadcastMessage:message completion:^(Message *message) {
            [self performSelectorOnMainThread:@selector(returnToMessageViewAndSetMessage:) withObject:message waitUntilDone:YES];
        }];
    }
}

-(void)returnToMessageViewAndSetMessage:(Message*)message
{
    [self.delegate didCreateMessage:message];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
