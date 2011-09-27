//
//  NewTodoItemViewController.h
//  MyCSUF
//
//  Created by Ismael Martinez on 9/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DelegeMethods.h"

@interface NewTodoItemViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, NewTodoDelegate> {
    NSManagedObjectContext *managedObjectContext;
    UITableView *table;
    BOOL editing;
}

@property (retain) IBOutlet UITableView *table;
@property (assign) BOOL editing;

- initWithMangedObjectContext:(NSManagedObjectContext *)context;

@end
