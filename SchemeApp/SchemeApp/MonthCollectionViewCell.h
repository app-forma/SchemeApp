//
//  MonthCollectionViewCell.h
//  SchemeApp
//
//  Created by Henrik on 2013-10-01.
//  Copyright (c) 2013 Team leet. All rights reserved.
//

@import UIKit;


@interface MonthCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *label;

@property BOOL isWeekCell;

@property (strong, nonatomic) NSDate *startDate;
@property (strong, nonatomic) NSDate *endDate;

@end
