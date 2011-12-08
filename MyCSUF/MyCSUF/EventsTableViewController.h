//
//  EventsTableViewController.h
//  MyCSUF
//
//  Created by Ismael Martinez on 11/2/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventsTableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, NSXMLParserDelegate, UIActionSheetDelegate> {
    NSMutableData *tempData;
    NSArray *eventsArray;
    UITableView *table;
    NSDate *currentDate;
    NSManagedObjectContext *managedObjectContext;
}

@property (nonatomic, retain) IBOutlet UITableView *table;
@property (nonatomic, retain) NSDate *currentDate;

- initWithManagedObjectContext:(NSManagedObjectContext *)context;

@end
