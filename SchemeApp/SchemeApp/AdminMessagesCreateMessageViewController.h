//
//  AdminMessagesCreateMessageViewController.h
//  SchemeApp
//
//  Created by Erik Österberg on 2013-09-17.
//  Copyright (c) 2013 Team leet. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol MessageCreateViewDelegate <NSObject>

-(void)didCreateMessage:(Message*)message;

@end

@interface AdminMessagesCreateMessageViewController : UIViewController

@property (nonatomic, assign) id<MessageCreateViewDelegate> delegate;

@end
