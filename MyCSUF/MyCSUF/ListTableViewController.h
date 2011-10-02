//
//  ListTableViewController.h
//  MyCSUF
//
//  Created by Ismael Martinez on 9/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DelegeMethods.h"

@interface ListTableViewController : UITableViewController <ListDelegate> {
    NSManagedObjectContext *managedObjectContext;
    NSArray *myList;
    BOOL newListCreate;
}

@property (retain) NSManagedObjectContext *managedObjectContext;

- initWithManagedObjectContext:(NSManagedObjectContext *)context;

@end
