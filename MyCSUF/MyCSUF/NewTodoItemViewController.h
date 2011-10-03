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

@interface NewTodoItemViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, NewTodoDelegate> {
    NSManagedObjectContext *managedObjectContext;
    NSMutableDictionary *tableData;
    UITableView *table;
    BOOL editing;
    BOOL cellAdjusted;
    int count;
    Category *currentCategory;
    NSString *stringDate;
    NSInteger selectedSegment;
}

@property (retain) IBOutlet UITableView *table;
@property (assign) BOOL editing;
@property (retain) Category *currentCategory;

- initWithMangedObjectContext:(NSManagedObjectContext *)context;

@end
