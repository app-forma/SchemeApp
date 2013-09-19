//
//  AdminMessagesDetailViewController.h
//  SchemeApp
//
//  Created by Erik Österberg on 2013-09-17.
//  Copyright (c) 2013 Team leet. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Message;

@protocol MessageDetailViewDelegate <NSObject>

-(void)willdeleteMessage:(Message*)message;

@end

@interface AdminMessagesDetailViewController : UIViewController

@property (nonatomic, assign) id<MessageDetailViewDelegate> delegate;
@property (nonatomic) Message *message;

@end
