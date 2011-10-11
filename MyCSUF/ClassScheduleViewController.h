//
//  ClassScheduleViewController.h
//  MyCSUF
//
//  Created by Bert Aguilar on 10/5/11.
//  Copyright 2011 Apple Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClassScheduleViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource> {
    NSArray *courseData;
}

@property(nonatomic, retain) NSArray *courseData;

@end
