//
//  DetailMessageViewController.m
//  SchemeAppAdmin
//
//  Created by Marcus Norling on 9/25/13.
//  Copyright (c) 2013 Marcus Norling. All rights reserved.
//

#import "DetailMessageViewController.h"
#import "MasterMessageViewController.h"
#import "Message.h"
#import "NSDate+Helpers.h"


@interface DetailMessageViewController () <UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UILabel *fromLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UINavigationItem *navItem;



@end

@implementation DetailMessageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)splitViewController:(UISplitViewController *)svc
     willHideViewController:(UIViewController *)aViewController
          withBarButtonItem:(UIBarButtonItem *)barButtonItem
       forPopoverController:(UIPopoverController *)pc {}

- (void)splitViewController:(UISplitViewController *)svc
     willShowViewController:(UIViewController *)aViewController
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {}

-(BOOL)splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation
{
    return NO;
}

-(void)didSelectMessage:(Message *)message
{
    self.navItem.title = [NSString stringWithFormat:@"Message from %@", message.from.firstname];
    self.fromLabel.text = [message.from fullName];
    self.dateLabel.text = [message.date asDateString];
    self.textView.text = message.text;
}


- (IBAction)didPressTrash:(UIBarButtonItem *)sender {
    UIActionSheet *trashPrompt = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete message" otherButtonTitles:nil, nil];
    [trashPrompt showFromBarButtonItem:sender animated:YES];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"clicked delete.");
}

@end
