//
//  StudentMessageDetailsViewController.m
//  SchemeApp
//
//  Created by Rikard Karlsson on 9/11/13.
//  Copyright (c) 2013 Team leet. All rights reserved.
//

#import "StudentMessageDetailsViewController.h"

@interface StudentMessageDetailsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *fromLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UITextView *messageTextView;

@end

@implementation StudentMessageDetailsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



// En vy med detaljer för det valda meddelandet av studenten.

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"Message";
    self.fromLabel.text = self.from;
    self.dateLabel.text = [Helpers stringFromNSDate:self.date];
    self.messageTextView.text = self.message;
    
    

    
}

@end