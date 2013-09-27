//
//  MasterMessageViewController.h
//  SchemeAppAdmin
//
//  Created by Marcus Norling on 9/25/13.
//  Copyright (c) 2013 Marcus Norling. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Message;

@protocol MasterMessageDelegate <NSObject>

-(void)didSelectMessage:(Message*)message;

@end

@interface MasterMessageViewController : UIViewController
@property (nonatomic, assign) id <MasterMessageDelegate> delegate;

@end
