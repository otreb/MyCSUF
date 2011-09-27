//
//  TodoListViewController.h
//  MyCSUF
//
//  Created by Ismael Martinez on 9/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TodoListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    NSManagedObjectContext *managedObjectContext;
    UITableView *table;
}

@property (retain) IBOutlet UITableView *table;

- initWithManagedObjectContext:(NSManagedObjectContext *)context;

@end
