//
//  TodoListViewController.h
//  MyCSUF
//
//  Created by Ismael Martinez on 9/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Category.h"

@interface TodoListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    NSManagedObjectContext *managedObjectContext;
    UITableView *table;
    Category *currentCategory;
    NSArray *todoArray;
}

@property (retain) IBOutlet UITableView *table;

- initWithToDo:(Category *)category withManagedObjectContext:(NSManagedObjectContext *)context;

@end
