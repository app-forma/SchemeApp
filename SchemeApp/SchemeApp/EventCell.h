//
//  EventCell.h
//  SchemeApp
//
//  Created by Johan Thorell on 2013-09-16.
//  Copyright (c) 2013 Team leet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EventCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UITextView *info;
@property (weak, nonatomic) IBOutlet UILabel *courseName;
@end
