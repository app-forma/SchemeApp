//
//  MonthCellCreator.h
//  SchemeApp
//
//  Created by Henrik on 2013-10-05.
//  Copyright (c) 2013 Team leet. All rights reserved.
//

@class MonthCollectionViewCell;


@interface MonthCellCreator : NSObject

+ (NSInteger)numberOfCellsInMonthForSection:(NSInteger)section
                                    andYear:(NSInteger)year;

+ (MonthCollectionViewCell *)createCellForCollectionView:(UICollectionView *)collectionView
                                               indexPath:(NSIndexPath *)indexPath
                                                    year:(NSInteger)year;
#pragma mark - Cell Colors
+ (UIColor *)monthColor;
+ (UIColor *)weekColor;
+ (UIColor *)weekendColor;
+ (UIColor *)workdayColor;

@end
