//
//  AdminMessagesDetailViewController.m
//  SchemeApp
//
//  Created by Erik Österberg on 2013-09-17.
//  Copyright (c) 2013 Team leet. All rights reserved.
//

#import "AdminMessagesDetailViewController.h"
#import "Message.h"

@interface AdminMessagesDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *fromField;
@property (weak, nonatomic) IBOutlet UILabel *dateField;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation AdminMessagesDetailViewController

-(BOOL)prefersStatusBarHidden { return YES; }

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.textView.contentInset = UIEdgeInsetsMake(-7, -5, -5, 0);
    
    self.fromField.text = self.message.from;
    self.dateField.text = [Helpers stringFromNSDate:self.message.date];
    self.textView.text = self.message.text;
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Reply" style:UIBarButtonItemStyleDone target:self action:@selector(didPressReply)];
    
}

-(void)didPressReply
{
    
}

@end
