//
//  ListTableViewController.h
//  MyCSUF
//
//  Created by Ismael Martinez on 9/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

/*
 The Following is the Category View Controller which contains each todo list.
 */

#import <UIKit/UIKit.h>
#import "DelegeMethods.h"

@interface ListTableViewController : UITableViewController <ListDelegate> {
    NSManagedObjectContext *managedObjectContext;   // context that has the information about the data saved.
    NSArray *myList;    // it will hold all the categories that are stored in the database.
    BOOL newListCreate; // checks if a new list was created.  If so it updates the table.
    BOOL event;
    id<NewTodoDelegate>delegate;
}

@property (retain) NSManagedObjectContext *managedObjectContext;
@property (assign) id<NewTodoDelegate>delegate;

- initWithManagedObjectContext:(NSManagedObjectContext *)context;
- initWithManagedObjectContext:(NSManagedObjectContext *)context creatingEvent:(BOOL)Event;

@end
