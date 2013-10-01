//
//  DayCollectionViewController.m
//  SchemeApp
//
//  Created by Henrik on 2013-10-01.
//  Copyright (c) 2013 Team leet. All rights reserved.
//

#import "DayCollectionViewController.h"
#import "DayCollectionViewCell.h"
#import "StudentEventsTableViewController.h"
#import "EventWrapper.h"
#import "Event.h"


@implementation DayCollectionViewController

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    switch (self.month)
    {
        case 0:
            return 31;
            break;
        case 1:
            return 28;
            break;
        case 2:
            return 31;
            break;
        case 3:
            return 30;
            break;
        case 4:
            return 31;
            break;
        case 5:
            return 30;
            break;
        case 6:
            return 31;
            break;
        case 7:
            return 31;
            break;
        case 8:
            return 30;
            break;
        case 9:
            return 31;
            break;
        case 10:
            return 30;
            break;
        case 11:
            return 31;
            break;
        default:
            return 0;
            break;
    }
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    DayCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier
                                                                              forIndexPath:indexPath];
    
    cell.dayLabel.text = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *dateString = [NSString stringWithFormat:@"2013-%@%d-%@%d",
                            self.month + 1 < 10 ? @"0" : @"", self.month + 1,
                            indexPath.row + 1 < 10 ? @"0" : @"", indexPath.row + 1];
    
    StudentEventsTableViewController *setvc = [self.storyboard instantiateViewControllerWithIdentifier:@"StudentEventsTableViewController"];
    setvc.eventsWithEventWrapper = [self filteredDatesForScheme:[Helpers startAndEndTimeForDate:[Helpers dateFromString:dateString]]];
    
    [self.navigationController pushViewController:setvc animated:YES];
}

#pragma mark - Extracted method
- (NSMutableArray *)filteredDatesForScheme:(NSDictionary *)dateDictionary
{
    NSMutableArray *filteredArray = [NSMutableArray new];
    
    for (EventWrapper *eventWrapper in Store.mainStore.currentUser.eventWrappers)
    {
        for (Event *event in eventWrapper.events)
        {
            NSDate *startDate = [Helpers dateFromString:dateDictionary[@"startTime"]];
            NSDate *endDate = [Helpers dateFromString:dateDictionary[@"endTime"]];
            BOOL startsAfterStartDate = startDate.timeIntervalSince1970 < event.startDate.timeIntervalSince1970;
            BOOL endsBeforeEndDate = endDate.timeIntervalSince1970 > event.endDate.timeIntervalSince1970;
            if (startsAfterStartDate && endsBeforeEndDate)
            {
                NSDictionary *eDic = @{@"eventWrapper": eventWrapper, @"event": event};
                [filteredArray addObject:eDic];
            }
        }
    }
    
    return filteredArray;
}

@end
