//
//  TodoListViewController.h
//  MyCSUF
//
//  Created by Ismael Martinez on 9/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Category.h"

/*
 Shows all your current Todos for the Category that was selected.
*/

@interface TodoListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate> {
    NSManagedObjectContext *managedObjectContext;
    UITableView *table;
    Category *currentCategory;
    NSArray *todoArray;
    NSIndexPath *indexPathSelect;
    UIPageControl *pageControl;
    UIScrollView *scrollView;
}

@property (retain) IBOutlet UITableView *table;
@property (retain) IBOutlet UIPageControl *pageControl;
@property (retain) IBOutlet UIScrollView *scrollView;

- initWithToDo:(Category *)category withManagedObjectContext:(NSManagedObjectContext *)context;

@end
