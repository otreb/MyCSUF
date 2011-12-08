//
//  EventsTableCell.h
//  MyCSUF
//
//  Created by Ismael Martinez on 11/9/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventsTableCell : UITableViewCell {
    UILabel *titleLabel;
    UILabel *dateLabel;
    UILabel *locationLabel;
}

@property (nonatomic, retain) IBOutlet UILabel *titleLabel;
@property (nonatomic, retain) IBOutlet UILabel *dateLabel;
@property (nonatomic, retain) IBOutlet UILabel *locationLabel;

@end
