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
    User *lasse = [[User alloc]initWithRole:SuperAdminRole firstname:@"lasse" lastname:@"erikssom" email:@"laase@fjghafd.se" password:@"123456"];
    User *henrik = [[User alloc]initWithRole:SuperAdminRole firstname:@"henrik" lastname:@"holmgren" email:@"laase@fjghafd.ru" password:@"password"];
    
    Message *mess1 = [[Message alloc]init];
    mess1.from = lasse;
    mess1.date = [NSDate date];
    mess1.text = @"asdkjfghasdkgajhgdka";
    
    
    User *master = [[User alloc]initWithRole:SuperAdminRole firstname:@"Anders" lastname:@"Carlsson" email:@"anders@coredev.se" password:@"Master"];
    
    Message *mess2 = [[Message alloc]init];
    mess2.from = master;
    mess2.date = [NSDate date];
    mess2.text = @"Hej grabbar! Jag har kollat i ert repository och det ser lite stökigt ut. Hur är det med Git-kunskaperna?";
    
    Message *mess3 = [[Message alloc] init];
    mess3.from = henrik;
    mess3.date = [NSDate date];
    mess3.text = @"Tror dom flesta av oss vet hur man utför alla kommandon men där slutar kunskaperna =) Men nu tror jag att vi fått häng på vad git faktiskt gör vid pull och push";
    
    messages = @[mess1, mess2, mess3];
    
	// Do any additional setup after loading the view.
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
    cell.nameLabel.text = [NSString stringWithFormat:@"%@ %@", message.from.firstname, message.from.lastname];
    cell.dateLabel.text = [Helpers stringFromNSDate:message.date];
    cell.messageTextView.text = message.text;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    StudentMessageDetailsViewController *studentMessageDetailsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"StudentMessageDetailsViewController"];
    
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
