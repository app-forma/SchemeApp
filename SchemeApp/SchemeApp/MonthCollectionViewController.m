//
//  MonthCollectionViewController.m
//  SchemeApp
//
//  Created by Henrik on 2013-10-01.
//  Copyright (c) 2013 Team leet. All rights reserved.
//

#import "MonthCollectionViewController.h"
#import "MonthCollectionReusableView.h"
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
    
    NSInteger weeksAdded, emptyCellsAdded;
    BOOL didNotAddWeekCellForPrevoiusIndexPath;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.emptyCellsInCurrentMonth + self.daysInCurrentMonth + self.weeksInCurrentMonth;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ViewIdentifier = @"Month";
    MonthCollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                           withReuseIdentifier:ViewIdentifier
                                                                                  forIndexPath:indexPath];
    view.label.text = self.monthName;
    
    return view;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self setInstanceVariablesToCurrent:indexPath
               andCurrentCollectionView:collectionView];
    
    if (self.shouldAddWeekCell)
    {
        return self.weekCell;
    }
    else if (self.shouldAddEmptyCell)
    {
        return self.emptyCell;
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
- (NSCalendar *)currentCalendar
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    calendar.firstWeekday = 2;
    
    return calendar;
}
- (BOOL)shouldAddWeekCell
{
    BOOL firstWeekday = currentDateComponents.weekday == self.currentCalendar.firstWeekday;
    BOOL firstCell = currentIndexPath.row == 0;
    
    return (firstCell || firstWeekday) && didNotAddWeekCellForPrevoiusIndexPath;
}
- (BOOL)shouldAddEmptyCell
{
    if (self.emptyCellsInCurrentMonth == emptyCellsAdded)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}
- (NSString *)monthName
{
    switch (self.month)
    {
        case 1:
            return @"January";
        case 2:
            return @"February";
        case 3:
            return @"Mars";
        case 4:
            return @"April";
        case 5:
            return @"May";
        case 6:
            return @"June";
        case 7:
            return @"July";
        case 8:
            return @"August";
        case 9:
            return @"September";
        case 10:
            return @"October";
        case 11:
            return @"November";
        case 12:
            return @"December";
        default:
            @throw [NSException exceptionWithName:@"OutOfRangeException"
                                           reason:@"self.month should be 1 - 12"
                                         userInfo:nil];
            break;
    }
}
#pragma mark Number of rows
- (NSInteger)emptyCellsInCurrentMonth
{
#warning Refactor
    NSString *dateString = [NSString stringWithFormat:@"%d-%@%d-01",
                            self.year,
                            self.month < 10 ? @"0" : @"", self.month];
    
    NSDate *date = [NSDate dateFromString:dateString];
    
    NSDateComponents *components = [self.currentCalendar components:NSWeekdayCalendarUnit
                                                           fromDate:date];
    switch (components.weekday)
    {
        case 1:
            return 6;
        case 2:
            return 0;
        case 3:
            return 1;
        case 4:
            return 2;
        case 5:
            return 3;
        case 6:
            return 4;
        case 7:
            return 5;
        default:
            return 0;
    }
}
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
#pragma mark Cells
- (UICollectionViewCell *)emptyCell
{
    static NSString *CellIdentifier = @"Empty";
    WeekCollectionViewCell *cell = [currentCollectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier
                                                                                    forIndexPath:currentIndexPath];
    emptyCellsAdded++;
    
    return cell;
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
    
    cell.label.text = [NSString stringWithFormat:@"%ld", (long)currentIndexPath.row + 1 - weeksAdded - emptyCellsAdded];
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
    NSInteger dayNumber = indexPath.row + 1 - emptyCellsAdded - weeksAdded;
    NSString *dateString = [NSString stringWithFormat:@"%d-%@%d-%@%d", self.year,
                                                                       self.month < 10 ? @"0" : @"", self.month,
                                                                       dayNumber < 10 ? @"0" : @"", dayNumber];
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
