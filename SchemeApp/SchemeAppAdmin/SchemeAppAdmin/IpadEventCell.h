//
//  IpadEventCell.h
//  SchemeAppAdmin
//
//  Created by Rikard Karlsson on 10/1/13.
//  Copyright (c) 2013 Marcus Norling. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IpadEventCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextView *info;
@property (weak, nonatomic) IBOutlet UILabel *room;
@property (weak, nonatomic) IBOutlet UILabel *date;

@end
