//
//  AwesomeUI.h
//  SchemeAppAdmin
//
//  Created by Erik Österberg on 2013-10-04.
//  Copyright (c) 2013 Marcus Norling. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AwesomeUI : NSObject

#pragma mark - GLOBAL THEME
+(void)setGlobalStylingTo:(UIWindow *)window;
+(void)setStyleToBar:(id)bar;

#pragma mark - THEME COLORS
+ (UIColor *)backgroundColorForEmptyTableView;
+ (UIColor *)backgroundColorForCoverViews;
+ (UIColor *)fontColorForCoverViews;

#pragma mark - THEME FONTS
+ (UIFont *)fontForCoverViews;
#pragma mark - TABLE VIEWS
+ (UIColor *)colorForIndexPath:(NSIndexPath *)indexPath;
+ (void)setGGstyleTo:(UITableView *)tableView;
+ (NSInteger)tableViewCellHeight;
+ (NSUInteger)tableViewHeaderHeight;

#pragma mark - TABLE VIEW CELLS
+ (void)addDefaultStyleTo:(UITableViewCell*)cell;
+(void)addColorAndDefaultStyleTo:(UITableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath;
+ (void)setStateSelectedfor:(UITableViewCell*)cell;
+ (void)setStateUnselectedfor:(UITableViewCell*)cell;

@end
