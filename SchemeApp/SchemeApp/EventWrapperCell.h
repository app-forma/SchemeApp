//
//  EventWrapperCell.h
//  SchemeApp
//
//  Created by Marcus Norling on 9/12/13.
//  Copyright (c) 2013 Team leet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventWrapperCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *eventWrapperName;
@property (weak, nonatomic) IBOutlet UILabel *eventWrapperStartDate;
@property (weak, nonatomic) IBOutlet UILabel *eventWrapperEndDate;
@property (weak, nonatomic) IBOutlet UILabel *eventWrapperOwnerName;

@end
