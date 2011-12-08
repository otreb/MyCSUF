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

@interface TodoListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, UIScrollViewDelegate> {
    NSManagedObjectContext *managedObjectContext;
    UITableView *listTable;
    UITableView *completeTable;
    Category *currentCategory;
    NSArray *todoArray;
    NSArray *completedArray;
    NSIndexPath *indexPathSelect;
    UIPageControl *pageControl;
    UIScrollView *tableScrollView;
}

@property (retain) IBOutlet UITableView *listTable;
@property (retain) IBOutlet UITableView *completeTable;
@property (retain) IBOutlet UIPageControl *pageControl;
@property (retain) IBOutlet UIScrollView *tableScrollView;

- initWithToDo:(Category *)category withManagedObjectContext:(NSManagedObjectContext *)context;

@end
