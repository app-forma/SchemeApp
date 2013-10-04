//
//  MasterUserCell.h
//  SchemeAppAdmin
//
//  Created by Johan Thorell on 2013-10-04.
//  Copyright (c) 2013 Marcus Norling. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MasterUserCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *roleLabel;
@property (strong, nonatomic) IBOutlet UIView *userImage;

@end
