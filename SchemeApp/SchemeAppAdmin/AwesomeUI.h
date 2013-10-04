//
//  AwesomeUI.h
//  SchemeAppAdmin
//
//  Created by Marcus Norling on 10/1/13.
//  Copyright (c) 2013 Marcus Norling. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AwesomeUI : NSObject

/**
 *  Theme colors
 */
+ (UIColor *)backgroundColorForEmptyTableView;
+ (UIColor *)backgroundColorForCoverViews;
+ (UIColor *)fontColorForCoverViews;

/**
 *  Theme fonts
 */
+ (UIFont *)fontForCoverViews;

/**
 *  TableView style
 */
+ (void)setGGstyleTo:(UITableView *)tableView;
+ (UIColor *)colorForIndexPath:(NSIndexPath *)indexPath;
+ (NSInteger)tableViewCellHeight;
+ (NSUInteger)tableViewHeaderHeight;

/**
 *  Cell style
 */
+ (void)addDefaultStyleTo:(UITableViewCell*)cell;
+ (void)addColorAndDefaultStyleTo:(UITableViewCell *)cell forIndexPath:(NSIndexPath*)indexPath;
+ (void)setStateSelectedfor:(UITableViewCell*)cell;
+ (void)setStateUnselectedfor:(UITableViewCell*)cell;
@end
