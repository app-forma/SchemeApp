//
//  AwesomeUI.m
//  SchemeAppAdmin
//
//  Created by Marcus Norling on 10/1/13.
//  Copyright (c) 2013 Marcus Norling. All rights reserved.
//

#import "AwesomeUI.h"

static NSArray *colors;

@implementation AwesomeUI

+ (void)initialize
{
    [super initialize];
    
    colors = @[[UIColor colorWithRed:239/255.0f green:148/255.0f blue:71/255.0f alpha:1.0f], [UIColor colorWithRed:243/255.0f green:82/255.0f blue:66/255.0f alpha:1.0f], [UIColor colorWithRed:221/255.0f green:49/255.0f blue:91/255.0f alpha:1.0f], [UIColor colorWithRed:155/255.0f green:49/255.0f blue:97/255.0f alpha:1.0f], [UIColor colorWithRed:67/255.0f green:46/255.0f blue:56/255.0f alpha:1.0f]];
}

#pragma mark - TABLE VIEWS
/**
 *  Color for row in tableView
 */
+ (UIColor *)colorForIndexPath:(NSIndexPath *)indexPath
{
    return colors[indexPath.row % 5];
}

/**
 *  Set style to tableView
 */
+ (void)setGGstyleTo:(UITableView *)tableView
{
    tableView.separatorColor = [UIColor clearColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

/**
 *  Default cellHeight / headerHeight
 */
+ (NSInteger)tableViewCellHeight
{
    return 100;
}

+ (NSUInteger)tableViewHeaderHeight
{
    return 40;
}

#pragma mark - TABLE VIEW CELLS
/**
 *  Sets cell to default styling
 */
+ (void)addDefaultStyleTo:(UITableViewCell*)cell
{
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:22];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
}

/**
 *  Sets cell to selected/highlighted state
 */
+ (void)setStateSelectedfor:(UITableViewCell*)cell
{
    cell.layer.borderColor = [UIColor whiteColor].CGColor;
    cell.layer.borderWidth = 1;
    cell.layer.cornerRadius = 2;
}

/**
 *  Sets cell to unselected/unhighlighted state
 */
+ (void)setStateUnselectedfor:(UITableViewCell*)cell
{
    cell.layer.borderColor = [UIColor clearColor].CGColor;
    cell.layer.borderWidth = 0;
}
@end