//
//  StudentMessageDetailsViewController.m
//  SchemeApp
//
//  Created by Rikard Karlsson on 9/11/13.
//  Copyright (c) 2013 Team leet. All rights reserved.
//

#import "StudentMessageDetailsViewController.h"
#import "NSDate+Helpers.h"

@interface StudentMessageDetailsViewController () <UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UILabel *fromLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UITextView *messageTextView;

@end

@implementation StudentMessageDetailsViewController
{
    UIActionSheet *deletePrompt;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"Message";
    self.fromLabel.text = self.message.from.fullName;
    self.dateLabel.text = [self.message.date asDateString];
    self.messageTextView.text = self.message.text;
    
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
        [self.delegate didDeleteMessage:self.message];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
