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

@end
