//
//  MonthCollectionViewController.m
//  SchemeApp
//
//  Created by Henrik on 2013-10-01.
//  Copyright (c) 2013 Team leet. All rights reserved.
//


#import "MonthCollectionViewController.h"
#import "MonthCellCreator.h"
#import "MonthCollectionReusableView.h"
#import "MonthCollectionViewCell.h"

#import "NSDate+Helpers.h"
#import "StudentEventsTableViewController.h"
#import "EventWrapper.h"
#import "Event.h"


@implementation MonthCollectionViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationItem.title = [NSString stringWithFormat:@"%ld", (long)self.year];
    
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0
                                                                    inSection:self.month - 1]
                                atScrollPosition:UICollectionViewScrollPositionCenteredVertically
                                        animated:NO];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 12;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [MonthCellCreator numberOfCellsInMonthForSection:section
                                                       andYear:self.year];
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ViewIdentifier = @"Month";
    MonthCollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                           withReuseIdentifier:ViewIdentifier
                                                                                  forIndexPath:indexPath];
    view.label.text = [self monthNameForIndexPath:indexPath];
    
    return view;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [MonthCellCreator createCellForCollectionView:collectionView
                                                  indexPath:indexPath
                                                       year:self.year];
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    MonthCollectionViewCell *selectedCell;
    selectedCell = (MonthCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    StudentEventsTableViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"StudentEventsTableViewController"];
    vc.eventsWithEventWrapper = [self filteredEventsWithStartDate:selectedCell.startDate
                                                       andEndDate:selectedCell.endDate];
    [self.navigationController pushViewController:vc
                                         animated:YES];
}

#pragma mark - Extracted methods
- (NSString *)monthNameForIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section + 1)
    {
        case 1: return @"January";
        case 2: return @"February";
        case 3: return @"Mars";
        case 4: return @"April";
        case 5: return @"May";
        case 6: return @"June";
        case 7: return @"July";
        case 8: return @"August";
        case 9: return @"September";
        case 10:return @"October";
        case 11:return @"November";
        case 12:return @"December";
            
        default:
            @throw [NSException exceptionWithName:@"OutOfRangeException"
                                           reason:@"Number of month should be 1 - 12"
                                         userInfo:nil];
            break;
    }
}
- (NSMutableArray *)filteredEventsWithStartDate:(NSDate *)startDate
                                     andEndDate:(NSDate *)endDate
{
    NSMutableArray *filteredArray = [NSMutableArray new];
    
    for (EventWrapper *eventWrapper in Store.mainStore.currentUser.eventWrappers)
    {
        for (Event *event in eventWrapper.events)
        {
            BOOL startsAfterPeriod = event.startDate.timeIntervalSince1970 > startDate.timeIntervalSince1970;
            BOOL endsBeforePeriod = event.endDate.timeIntervalSince1970 < endDate.timeIntervalSince1970;
            
            if (startsAfterPeriod && endsBeforePeriod)
            {
                [filteredArray addObject:@{@"eventWrapper": eventWrapper,
                                           @"event": event}];
            }
        }
    }
    
    return filteredArray;
}

@end
