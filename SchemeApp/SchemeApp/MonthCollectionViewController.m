//
//  MonthCollectionViewController.m
//  SchemeApp
//
//  Created by Henrik on 2013-10-01.
//  Copyright (c) 2013 Team leet. All rights reserved.
//

#import "MonthCollectionViewController.h"
#import "DayCollectionViewCell.h"
#import "WeekCollectionViewCell.h"
#import "NSDate+Helpers.h"
#import "StudentEventsTableViewController.h"
#import "EventWrapper.h"
#import "Event.h"


@implementation MonthCollectionViewController
{
    NSIndexPath *currentIndexPath;
    NSDate *currentDate;
    NSDateComponents *currentDateComponents;
    UICollectionView *currentCollectionView;
    
    NSInteger weeksAdded;
    BOOL didNotAddWeekCellForPrevoiusIndexPath;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.daysInCurrentMonth + self.weeksInCurrentMonth;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self setInstanceVariablesToCurrent:indexPath
               andCurrentCollectionView:collectionView];
    
    if (self.shouldAddWeekCell)
    {
        return self.weekCell;
    }
    else
    {
        return self.dayCell;
    }
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    StudentEventsTableViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"StudentEventsTableViewController"];
    vc.eventsWithEventWrapper = [self eventsFilteredByDateOfSelectedCell:(DayCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath]];
    
    [self.navigationController pushViewController:vc
                                         animated:YES];
}

#pragma mark - Queries
- (NSInteger)daysInCurrentMonth
{
    switch (self.month)
    {
        case 1:
            return 31;
        case 2:
            return 28;
        case 3:
            return 31;
        case 4:
            return 30;
        case 5:
            return 31;
        case 6:
            return 30;
        case 7:
            return 31;
        case 8:
            return 31;
        case 9:
            return 30;
        case 10:
            return 31;
        case 11:
            return 30;
        case 12:
            return 31;
        default:
            return 0;
    }
}
- (NSInteger)weeksInCurrentMonth
{
    NSString *dateString = [NSString stringWithFormat:@"%d-%@%d-01",
                            self.year,
                            self.month < 10 ? @"0" : @"", self.month];
    
    return [self.currentCalendar rangeOfUnit:NSWeekCalendarUnit
                                      inUnit:NSMonthCalendarUnit
                                     forDate:[NSDate dateFromString:dateString]].length;
}
- (NSCalendar *)currentCalendar
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    calendar.firstWeekday = 2;
    
    return calendar;
}
- (BOOL)shouldAddWeekCell
{
    BOOL firstWeekday = currentDateComponents.weekday == self.currentCalendar.firstWeekday;
    BOOL firstDayOfMonth = currentIndexPath.row == 0;
    
    return (firstDayOfMonth || firstWeekday) && didNotAddWeekCellForPrevoiusIndexPath;
}
- (WeekCollectionViewCell *)weekCell
{
    static NSString *CellIdentifier = @"Week";
    WeekCollectionViewCell *cell = [currentCollectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier
                                                                                    forIndexPath:currentIndexPath];
    cell.label.text = [NSString stringWithFormat:@"%@%ld",
                       currentDateComponents.weekOfYear < 10 ? @"0" : @"",
                       (long)currentDateComponents.weekOfYear].capitalizedString;
    
    cell.date = currentDate;
    
    weeksAdded++;
    didNotAddWeekCellForPrevoiusIndexPath = NO;
    
    return cell;
}
- (DayCollectionViewCell *)dayCell
{
    static NSString *CellIdentifier = @"Day";
    DayCollectionViewCell *cell = [currentCollectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier
                                                                                   forIndexPath:currentIndexPath];
    
    cell.label.text = [NSString stringWithFormat:@"%ld", (long)currentIndexPath.row + 1 - weeksAdded];
    cell.date = currentDate;
    
    didNotAddWeekCellForPrevoiusIndexPath = YES;
    
    return cell;
}

#pragma mark - Extracted methods
- (void)setInstanceVariablesToCurrent:(NSIndexPath *)indexPath
             andCurrentCollectionView:(UICollectionView *)collectionView
{
    currentIndexPath = indexPath;
    if (currentIndexPath.row == 0) didNotAddWeekCellForPrevoiusIndexPath = YES;
    
    currentDate = [self dateFromIndexPath:currentIndexPath];
    currentDateComponents = [self.currentCalendar components:NSWeekOfYearCalendarUnit | NSWeekdayCalendarUnit
                                                    fromDate:currentDate];
    currentCollectionView = collectionView;

}
- (NSDate *)dateFromIndexPath:(NSIndexPath *)indexPath
{
    NSString *dateString = [NSString stringWithFormat:@"%d-%@%d-%@%d",
                            self.year,
                            self.month < 10 ? @"0" : @"", self.month,
                            indexPath.row + 1 - weeksAdded < 10 ? @"0" : @"", indexPath.row + 1 - weeksAdded];
    
    return [NSDate dateFromString:dateString];
}
- (NSMutableArray *)eventsFilteredByDateOfSelectedCell:(DayCollectionViewCell *)selectedCell
{
    NSDictionary *period;
    
    if ([selectedCell isKindOfClass:WeekCollectionViewCell.class])
    {
        period = [NSDate startAndEndDateOfWeekForDate:selectedCell.date];
    }
    else
    {
        period = [NSDate startAndEndTimeForDate:selectedCell.date];
    }
    
    return [self filteredDatesForScheme:period];
}
- (NSMutableArray *)filteredDatesForScheme:(NSDictionary *)period
{
    NSMutableArray *filteredArray = [NSMutableArray new];
    
    for (EventWrapper *eventWrapper in Store.mainStore.currentUser.eventWrappers)
    {
        for (Event *event in eventWrapper.events)
        {
            NSDate *startDate = [NSDate dateFromString:period[@"startDate"]];
            NSDate *endDate = [NSDate dateFromString:period[@"endDate"]];
            
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
