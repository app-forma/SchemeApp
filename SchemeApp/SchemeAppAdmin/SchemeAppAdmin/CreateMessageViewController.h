//
//  MessageEditViewController.h
//  SchemeAppAdmin
//
//  Created by Erik Österberg on 2013-09-27.
//  Copyright (c) 2013 Marcus Norling. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CreateMessageViewDelegate <NSObject>

-(void)didCreateAndGetMessage:(Message*)message;
-(void)didCreateMessage;


@end


@interface CreateMessageViewController : UITableViewController

@property (nonatomic, assign) id delegate;

@end
