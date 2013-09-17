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
- (IBAction)didPressSend:(id)sender;

@end

@implementation AdminMessagesCreateMessageViewController
{
    NSArray *users;
    NSMutableArray *recipients;
    NSMutableArray *suggestions;

    UIColor *lightGrayColor;
    UIColor *whiteColor;
}
-(BOOL)prefersStatusBarHidden { return YES; }

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.textView.layer.borderWidth = 1.0f;
    self.textView.layer.borderColor = [[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1]CGColor];
    self.textView.layer.cornerRadius = 7.0f;
    
    UINavigationItem *navItem = [[UINavigationItem alloc]initWithTitle:@"New message"];
    navItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(didPressCancel)];
    [self.navBar pushNavigationItem:navItem animated:NO];
    
    [self.messageTypeControl addTarget:self action:@selector(messageTypeDidChange:) forControlEvents:UIControlEventValueChanged];
    
    
    lightGrayColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1];
    whiteColor = [UIColor whiteColor];
    
    //DUMMY DATA:
    users = @[@"Johan", @"Erik", @"Henrik", @"Marcus", @"Tobias", @"Rickard", @"Master Anders", @"Dummy student"];
    recipients = [NSMutableArray new];
    
    [self.tableView reloadData];
}

#pragma mark - textfield delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}

-(void)textFieldDidChange :(UITextField *)textField{
    NSMutableArray *filteredSuggestions = [NSMutableArray new];
    for (NSString *name in users) {
        NSRange textRange = [name rangeOfString:textField.text options:NSCaseInsensitiveSearch];
        if (textRange.location != NSNotFound && ![recipients containsObject:name]) {
            [filteredSuggestions addObject:name];
        }
    }
    if (![filteredSuggestions isEqualToArray:suggestions]) {
        suggestions = filteredSuggestions;
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationAutomatic];
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
    if (section == RECIPIENTS_SECTION) { return recipients.count; }
    if (section == SUGGESTIONS_SECTION) { return suggestions.count; }
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
    cell.accessoryType = section == RECIPIENTS_SECTION ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    cell.backgroundColor = section == SUGGESTIONS_SECTION ? lightGrayColor : whiteColor;
    cell.nameLabel.text = section == SUGGESTIONS_SECTION ? suggestions[indexPath.row] : recipients[indexPath.row];
    return cell;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.section == RECIPIENTS_SECTION ? YES : NO;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [recipients removeObjectAtIndex:indexPath.row];
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
        [recipients addObject:suggestions[indexPath.row]];
        [tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:recipients.count -
                                             1 inSection:RECIPIENTS_SECTION]] withRowAnimation:UITableViewRowAnimationAutomatic];
        [suggestions removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];        
    }
}

#pragma mark - events
-(void)messageTypeDidChange:(UISegmentedControl*)control
{
    NSString *type = control.selectedSegmentIndex == MESSAGE_TYPE ? @"message" : @"mailing";
    [self.tableView reloadData];
}
-(void)didPressCancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didPressSend:(id)sender {
    User *currentUsr = Store.mainStore.currentUser;
    Message *message = [[Message alloc]init];
    message.text = self.textView.text;
    message.from = [NSString stringWithFormat:@"%@ %@", currentUsr.firstname, currentUsr.lastname];
    message.date = [NSDate date];
    
    if (self.messageTypeControl == MESSAGE_TYPE) {
        
    } else {
        [[Store adminStore]broadcastMessage:message completion:^(Message *message) {
            NSLog(@"ok");
        }];
        
    }
}
@end
