//
//  PriorityTableCell.h
//  MyCSUF
//
//  Created by Ismael Martinez on 10/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PriorityTableCell : UITableViewCell {
    UISegmentedControl *prioritySegment;
}

@property (retain) IBOutlet UISegmentedControl *prioritySegment;

@end
