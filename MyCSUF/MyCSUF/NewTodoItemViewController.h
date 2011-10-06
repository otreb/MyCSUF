//
//  NewTodoItemViewController.h
//  MyCSUF
//
//  Created by Ismael Martinez on 9/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DelegeMethods.h"
#import "Category.h"
#import "Task.h"

@interface NewTodoItemViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, NewTodoDelegate> {
    NSManagedObjectContext *managedObjectContext;
    NSMutableDictionary *tableData;
    UITableView *table;
    UISegmentedControl *prioritySegment;
    BOOL editing;
    BOOL cellAdjusted;
    int count;
    Category *currentCategory;
    NSString *stringDate;
    NSInteger selectedSegment;
    Task *currentTask;
    UITableViewCell *cellFive;
}

@property (retain) IBOutlet UITableView *table;
@property (assign) BOOL editing;
@property (retain) Category *currentCategory;
@property (retain) IBOutlet UITableViewCell *cellFive;
@property (retain) IBOutlet UISegmentedControl *prioritySegment;

- initWithMangedObjectContext:(NSManagedObjectContext *)context;
- initWithMangedObjectContext:(NSManagedObjectContext *)context withEditableTask:(Task *)task;

@end
