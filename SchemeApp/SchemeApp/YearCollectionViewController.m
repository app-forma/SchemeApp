//
//  YearCollectionViewController.m
//  SchemeApp
//
//  Created by Henrik on 2013-10-01.
//  Copyright (c) 2013 Team leet. All rights reserved.
//

#import "YearCollectionViewController.h"
#import "YearCollectionReusableView.h"
#import "YearCollectionViewCell.h"
#import "MonthCellCreator.h"
#import "MonthCollectionViewController.h"


@implementation YearCollectionViewController
{
    NSIndexPath *selectedIndexPath;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    MonthCollectionViewController *vc = segue.destinationViewController;
    vc.year = selectedIndexPath.section + 2013;
    vc.month = selectedIndexPath.row + 1;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 10;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 12;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Month";
    YearCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier
                                                                              forIndexPath:indexPath];
    cell.label.text = [self monthNameForIndexPath:indexPath];
    cell.backgroundColor = MonthCellCreator.workdayColor;
    
    return cell;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ViewIdentifier = @"Year";
    YearCollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                          withReuseIdentifier:ViewIdentifier
                                                                                 forIndexPath:indexPath];

    view.label.text = [NSString stringWithFormat:@"%d", 2013 + indexPath.section];
    
    return view;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    selectedIndexPath = indexPath;
}

#pragma mark - Extracted methods
- (NSString *)monthNameForIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row)
    {
        case 0:
            return @"Jan";
            break;
        case 1:
            return @"Feb";
            break;
        case 2:
            return @"Mar";
            break;
        case 3:
            return @"Apr";
            break;
        case 4:
            return @"May";
            break;
        case 5:
            return @"Jun";
            break;
        case 6:
            return @"Jul";
            break;
        case 7:
            return @"Aug";
            break;
        case 8:
            return @"Sep";
            break;
        case 9:
            return @"Oct";
            break;
        case 10:
            return @"Nov";
            break;
        case 11:
            return @"Dec";
            break;
        default:
            @throw [NSException exceptionWithName:@"OutOfRangeException"
                                           reason:@"indexPath.row should be 0 - 11"
                                         userInfo:nil];
            break;
    }
}

@end
