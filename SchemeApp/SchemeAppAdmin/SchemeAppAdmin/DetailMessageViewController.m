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

@interface DetailMessageViewController () <MasterMessageDelegate>
@property (weak, nonatomic) IBOutlet UILabel *fromLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UINavigationItem *navItem;


@end

@implementation DetailMessageViewController
{
    UIBarButtonItem *barButtonForMaster;
    UIViewController *masterViewController;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)splitViewController:(UISplitViewController *)svc
     willHideViewController:(UIViewController *)aViewController
          withBarButtonItem:(UIBarButtonItem *)barButtonItem
       forPopoverController:(UIPopoverController *)pc
{
    barButtonForMaster = barButtonItem;
    masterViewController = aViewController;
}


- (void)splitViewController:(UISplitViewController *)svc
     willShowViewController:(UIViewController *)aViewController
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!masterViewController.view.window) {
        [barButtonForMaster.target performSelector:barButtonForMaster.action withObject:barButtonForMaster afterDelay:0.01];
    }
    
}
-(void)didSelectMessage:(Message *)message
{
    self.navItem.title = [NSString stringWithFormat:@"Message from %@", message.from.firstname];
    self.fromLabel.text = [message.from fullName];
    self.dateLabel.text = [message.date asDateString];
    self.textView.text = message.text;
}


- (IBAction)didPressTrash:(id)sender {
}

@end
