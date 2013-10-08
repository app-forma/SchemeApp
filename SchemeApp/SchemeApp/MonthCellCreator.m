//
//  MonthCellCreator.m
//  SchemeApp
//
//  Created by Henrik on 2013-10-05.
//  Copyright (c) 2013 Team leet. All rights reserved.
//

#import "MonthCellCreator.h"
#import "MonthCollectionViewCell.h"


@interface MonthCellCreator ()

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic) NSInteger year, month, weekOfYear, weekOfMonth, day, weekday;

@end


@implementation MonthCellCreator
{
    BOOL emptyCellsHasBeenAdded;
    MonthCollectionViewCell *cell;
}

+ (NSInteger)numberOfCellsInMonthForSection:(NSInteger)section
                                    andYear:(NSInteger)year
{
    MonthCellCreator *ccc = [[MonthCellCreator alloc] initWithCollectionView:nil
                                                                         indexPath:[NSIndexPath indexPathForRow:0
                                                                                                      inSection:section]
                                                                           andYear:year];
    return ccc.nrOfDays + ccc.nrOfWeeks + ccc.nrOfEmptyCells;
}

+ (UICollectionViewCell *)createCellForCollectionView:(UICollectionView *)collectionView
                                            indexPath:(NSIndexPath *)indexPath
                                                 year:(NSInteger)year
{
    MonthCellCreator *ccc = [[MonthCellCreator alloc] initWithCollectionView:collectionView
                                                                         indexPath:indexPath
                                                                           andYear:year];
    return [ccc createCell];
}

- (id)initWithCollectionView:(UICollectionView *)collectionView
                   indexPath:(NSIndexPath *)indexPath
                     andYear:(NSInteger)year
{
    self = [super init];
    if (self)
    {
        _collectionView = collectionView;
        _indexPath = indexPath;
        _year = year;
        
        [self setInstanceDate];
        [self setInstanceDateComponents];
    }
    return self;
}

- (MonthCollectionViewCell *)createCell
{
    static NSString *CellIdentifier = @"MonthCell";
    cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier
                                                          forIndexPath:self.indexPath];
    
    BOOL shouldSetupCellAsWeekCell = (self.indexPath.row == 0 || self.indexPath.row % 8 == 0);
    
    if (shouldSetupCellAsWeekCell)
    {
        [self setupCellAsWeekCell];
    }
    else if (emptyCellsHasBeenAdded)
    {
        [self setupCellAsDayCell];
    }
    else
    {
        [self setupCellAsEmptyCell];
    }
    
    return cell;
}

#pragma mark - Queries
- (NSCalendar *)calendar
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    calendar.firstWeekday = 2;
    
    return calendar;
}
#pragma mark Number of rows
- (NSInteger)nrOfDays
{
    switch (self.month)
    {
        case 1: return 31;
        case 2: return 28;
        case 3: return 31;
        case 4: return 30;
        case 5: return 31;
        case 6: return 30;
        case 7: return 31;
        case 8: return 31;
        case 9: return 30;
        case 10:return 31;
        case 11:return 30;
        case 12:return 31;
            
        default:
            @throw [NSException exceptionWithName:@"OutOfRangeException"
                                           reason:@"Month should be 1 - 12"
                                         userInfo:nil];
            break;
    }
}
- (NSInteger)nrOfWeeks
{
    return [self.calendar rangeOfUnit:NSWeekCalendarUnit
                               inUnit:NSMonthCalendarUnit
                              forDate:self.date].length;
}
- (NSInteger)nrOfEmptyCells
{
    NSDate *date = [self createDateForYear:self.year
                                     month:self.indexPath.section + 1
                                    andDay:1];
    
    NSDateComponents *components = [self.calendar components:NSWeekdayCalendarUnit
                                                    fromDate:date];
    switch (components.weekday)
    {
        case 1:return 6;
        case 2:return 0;
        case 3:return 1;
        case 4:return 2;
        case 5:return 3;
        case 6:return 4;
        case 7:return 5;
            
        default:
            @throw [NSException exceptionWithName:@"OutOfRangeException"
                                           reason:@"Weekday should be between 0 - 6"
                                         userInfo:nil];
            break;
    }
}

#pragma mark - Extracted methods
- (NSInteger)dayCalculatedFromIndexPath
{
    NSInteger calculatedDay = self.indexPath.row - (self.weeksAddedCalculatedFromIndexPath + self.nrOfEmptyCells) + 1;
    
    if (calculatedDay < 1)
    {
        return 1;
    }
    else
    {
        emptyCellsHasBeenAdded = YES;
        return calculatedDay;
    }
}
- (NSInteger)weeksAddedCalculatedFromIndexPath
{
    if (self.indexPath.row < 9)
    {
        return 1;
    }
    else if (self.indexPath.row < 17)
    {
        return 2;
    }
    else if (self.indexPath.row < 25)
    {
        return 3;
    }
    else if (self.indexPath.row < 33)
    {
        return 4;
    }
    else if (self.indexPath.row < 41)
    {
        return 5;
    }
    else
    {
        return 6;
    }
}
#pragma mark Date
- (void)setInstanceDate
{
    self.date = [self createDateForYear:self.year
                                  month:self.indexPath.section + 1
                                 andDay:self.dayCalculatedFromIndexPath];
}
- (void)setInstanceDateComponents
{
    NSDateComponents *components = [self.calendar components: NSYearCalendarUnit |
                                    NSMonthCalendarUnit |
                                    NSWeekOfYearCalendarUnit |
                                    NSWeekOfMonthCalendarUnit |
                                    NSWeekdayCalendarUnit |
                                    NSDayCalendarUnit
                                                    fromDate:self.date];
    self.year = components.year;
    self.month = components.month;
    self.weekOfYear = components.weekOfYear;
    self.weekOfMonth = components.weekOfMonth;
    self.weekday = components.weekday;
    self.day = components.day;
}
- (NSDate *)createDateForYear:(NSInteger)year
                        month:(NSInteger)month
                       andDay:(NSInteger)day
{
    NSString *dateString = [NSString stringWithFormat:@"%d-%@%d-%@%d",
                            year,
                            month < 10 ? @"0" : @"", month,
                            day < 10 ? @"0" : @"", day];
    
    return [NSDate dateFromString:dateString];
}
#pragma mark Cell
- (void)setupCellAsWeekCell
{
    cell.label.text = [NSString stringWithFormat:@"%@%d", self.weekOfYear < 10 ? @"0" : @"",
                       self.weekOfYear];
    
    cell.backgroundColor = MonthCellCreator.weekColor;
    
    cell.startDate = self.date;
    cell.endDate = [self.date dateByAddingTimeInterval:60*60*24*7];
}
- (void)setupCellAsDayCell
{
    cell.label.text = [NSString stringWithFormat:@"%d", self.day];
    
    UIColor *color;
    BOOL saturdayOrSunday = self.weekday == 1 || self.weekday == 7;
    
    if (saturdayOrSunday)
    {
        color = MonthCellCreator.weekendColor;
    }
    else
    {
        color = MonthCellCreator.workdayColor;
    }
    cell.backgroundColor = color;

    cell.startDate = self.date;
    cell.endDate = [self.date dateByAddingTimeInterval:60*60*24];
}
- (void)setupCellAsEmptyCell
{
    cell.label.text = @"";
}
#pragma mark Cell Color
+ (UIColor *)monthColor
{
    return MonthCellCreator.workdayColor;
}
+ (UIColor *)weekColor
{
    return [MonthCellCreator colorWithRed:232
                                       green:107
                                        blue:223
                                       alpha:1.0];
}
+ (UIColor *)weekendColor
{
    return [MonthCellCreator colorWithRed:186
                                       green:60
                                        blue:255
                                       alpha:1.0];
}
+ (UIColor *)workdayColor
{
    return [MonthCellCreator colorWithRed:214
                                       green:153
                                        blue:255
                                       alpha:1.0];
}
+ (UIColor *)colorWithRed:(CGFloat)r
                    green:(CGFloat)g
                     blue:(CGFloat)b
                    alpha:(CGFloat)a
{
    return [UIColor colorWithRed:r/255.0f
                           green:g/255.0f
                            blue:b/255.0f
                           alpha:a];
}

@end
