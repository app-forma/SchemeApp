//
//  PopoverEventViewController.h
//  SchemeAppAdmin
//
//  Created by Rikard Karlsson on 10/2/13.
//  Copyright (c) 2013 Marcus Norling. All rights reserved.
//

@protocol PopoverEventDelegate <NSObject>

-(void)dismissEventPopover;
-(Event *)eventPopoverCurrentEvent;
-(void)eventPopoverCreateEvent:(Event *)event;
-(void)eventPopoverUpdateEvent:(Event *)event;

@end

#import <UIKit/UIKit.h>

@interface PopoverEventViewController : UIViewController <UITextFieldDelegate>

@property (weak) id <PopoverEventDelegate> delegate;
@property (nonatomic, assign) BOOL eventIsInEditingMode;

@end