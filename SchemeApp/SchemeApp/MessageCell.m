//
//  MessageCell.m
//  SchemeApp
//
//  Created by Erik Österberg on 2013-09-12.
//  Copyright (c) 2013 Team leet. All rights reserved.
//

#import "MessageCell.h"

@implementation MessageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    self.messageTextView.contentInset = UIEdgeInsetsMake(-7, -5, -5, 0);

}

@end
