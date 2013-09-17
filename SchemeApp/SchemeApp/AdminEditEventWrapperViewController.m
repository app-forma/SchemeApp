//
//  AdminEditEventWrapperViewController.m
//  SchemeApp
//
//  Created by Marcus Norling on 9/16/13.
//  Copyright (c) 2013 Team leet. All rights reserved.
//

#import "AdminEditEventWrapperViewController.h"
@interface AdminEditEventWrapperViewController()<UIScrollViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation AdminEditEventWrapperViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.scrollView.contentSize = CGSizeMake(320, 1000);
    self.scrollView.frame = self.view.frame;
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 3;
}

#pragma mark - UIPickerViewDelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
#warning implement from db
{
    switch (row)
    {
        case 0:
            return @"Tom Blackmore";
            break;
        case 1:
            return @"Anders Carlsson";
            break;
        case 2:
            return @"Bill Gates";
            break;
        default:
            return @"";
            break;
    }
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
#warning implement value when selected
{
    
}


@end

