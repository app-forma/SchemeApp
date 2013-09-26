//
//  MasterUserViewController.h
//  SchemeAppAdmin
//
//  Created by Marcus Norling on 9/25/13.
//  Copyright (c) 2013 Marcus Norling. All rights reserved.
//

#import <UIKit/UIKit.h>
@class User;
@protocol MasterUserDelegate <NSObject>

- (void)masterUserDidSelectUser:(User*)user;

@end
@interface MasterUserViewController : UITableViewController
@property (weak) id <MasterUserDelegate> delegate;
@end
