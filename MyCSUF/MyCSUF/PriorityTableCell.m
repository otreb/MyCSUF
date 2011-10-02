//
//  PriorityTableCell.m
//  MyCSUF
//
//  Created by Ismael Martinez on 10/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PriorityTableCell.h"

@implementation PriorityTableCell

@synthesize prioritySegment;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.prioritySegment = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Low", @"Medium", @"High", nil]];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
