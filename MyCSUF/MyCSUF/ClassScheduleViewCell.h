//
//  ClassScheduleViewCell.h
//  MyCSUF
//
//  Created by Bert Aguilar on 10/10/11.
//  Copyright 2011 Apple Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClassScheduleViewCell : UITableViewCell {
    UILabel *courseName;
    UILabel *courseNumber;
    UILabel *teacher;
    UILabel *room;
    UILabel *classTime;
    UILabel *classDays;
    UILabel *classComponent;
}

@property (retain) IBOutlet UILabel *courseName;
@property (retain) IBOutlet UILabel *courseNumber;
@property (retain) IBOutlet UILabel *teacher;
@property (retain) IBOutlet UILabel *room;
@property (retain) IBOutlet UILabel *classTime;
@property (retain) IBOutlet UILabel *classDays;
@property (retain) IBOutlet UILabel *classComponent;

@end
