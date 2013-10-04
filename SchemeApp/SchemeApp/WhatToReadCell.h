//
//  WhatToReadCell.h
//  SchemeApp
//
//  Created by Rikard Karlsson on 9/24/13.
//  Copyright (c) 2013 Team leet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WhatToReadCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *courseLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UITextView *whatToReadTextField;

@end
