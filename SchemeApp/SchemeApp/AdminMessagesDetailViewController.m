//
//  AdminMessagesDetailViewController.m
//  SchemeApp
//
//  Created by Erik Österberg on 2013-09-17.
//  Copyright (c) 2013 Team leet. All rights reserved.
//

#import "AdminMessagesDetailViewController.h"
#import "Message.h"

@interface AdminMessagesDetailViewController () <UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UILabel *fromField;
@property (weak, nonatomic) IBOutlet UILabel *dateField;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation AdminMessagesDetailViewController
{
    UIActionSheet *deletePrompt;
}
-(BOOL)prefersStatusBarHidden { return YES; }

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.textView.contentInset = UIEdgeInsetsMake(-7, -5, -5, 0);
    
    self.fromField.text = [NSString stringWithFormat:@"%@ %@", self.message.from.firstname, self.message.from.lastname];
    self.dateField.text = [Helpers stringFromNSDate:self.message.date];
    self.textView.text = self.message.text;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(didPressTrash)];
    
    deletePrompt = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete" otherButtonTitles:nil, nil];
}

-(void)didPressTrash
{
     [deletePrompt showFromTabBar:self.tabBarController.tabBar];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self.delegate willdeleteMessage:self.message];
        [self.navigationController popViewControllerAnimated:YES];
    }
}


@end
