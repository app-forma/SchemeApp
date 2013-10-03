//
//  AttendanceViewController.m
//  SchemeAppAdmin
//
//  Created by Erik Österberg on 2013-10-03.
//  Copyright (c) 2013 Marcus Norling. All rights reserved.
//

#import "AttendanceViewController.h"
#import "User.h"

@interface AttendanceViewController ()

@end

@implementation AttendanceViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.user.attendances.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = self.user.attendances[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    return cell;
}

-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [[Store adminStore]removeAttendance:self.user.attendances[indexPath.row] forUser:self.user completion:^(BOOL success) {
            if (!success) {
                NSLog(@"Attendance wasnt actually removed.");
            }
        }];
        [self.user.attendances removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];        
    }
}

@end
