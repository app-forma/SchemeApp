//
//  EventWrappersForUserViewController.h
//  SchemeAppAdmin
//
//  Created by Erik Österberg on 2013-10-04.
//  Copyright (c) 2013 Marcus Norling. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventWrappersForUserViewController : UITableViewController

- (id)initWithUser:(User*)aUser eventWrappers:(NSArray *)eventWrappersForAdmin;

@end
