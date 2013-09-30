//
//  MasterMessageViewController.m
//  SchemeAppAdmin
//
//  Created by Marcus Norling on 9/25/13.
//  Copyright (c) 2013 Marcus Norling. All rights reserved.
//

#import "MasterMessageViewController.h"
#import "CreateMessageViewController.h"

@interface MasterMessageViewController () <UITableViewDataSource, UITableViewDelegate, CreateMessageViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MasterMessageViewController
{
    NSMutableArray *messages;
    UIPopoverController *createMessagePopover;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[Store studentStore]messagesForUser:[Store mainStore].currentUser completion:^(NSArray *messagesForUser) {
        messages = [messagesForUser mutableCopy];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
   
        
    
    
    
}
#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    Message *message = messages[indexPath.row];
    cell.textLabel.text = [message.from fullName];
    cell.detailTextLabel.text = message.text;   
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate didSelectMessage:messages[indexPath.row]];
}

#pragma callbacks
- (IBAction)didPressAdd:(id)sender {
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
    [createMessagePopover dismissPopoverAnimated:YES];
}

@end
