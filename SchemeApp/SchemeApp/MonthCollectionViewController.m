//
//  MonthCollectionViewController.m
//  SchemeApp
//
//  Created by Henrik on 2013-10-01.
//  Copyright (c) 2013 Team leet. All rights reserved.
//

#import "MonthCollectionViewController.h"
#import "MonthCollectionViewCell.h"
#import "DayCollectionViewController.h"


@implementation MonthCollectionViewController
{
    NSIndexPath *selectedIndexPath;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    DayCollectionViewController *vc = segue.destinationViewController;
    vc.month = selectedIndexPath.row;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 12;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    MonthCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier
                                                                                 forIndexPath:indexPath];
    
    cell.monthLabel.text = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    selectedIndexPath = indexPath;
}

@end
