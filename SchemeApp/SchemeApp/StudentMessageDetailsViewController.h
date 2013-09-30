//
//  StudentMessageDetailsViewController.h
//  SchemeApp
//
//  Created by Rikard Karlsson on 9/11/13.
//  Copyright (c) 2013 Team leet. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol StudentMessageDetailDelegate <NSObject>

- (void)didDeleteMessage:(Message *)message;

@end

@class Message;
@interface StudentMessageDetailsViewController : UIViewController

@property (nonatomic, assign) id delegate;
@property (nonatomic) Message *message;

@end
