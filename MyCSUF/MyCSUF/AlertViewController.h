//
//  AlertViewController.h
//  MyCSUF
//
//  Created by Ismael Martinez on 9/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DelegeMethods.h"

@interface AlertViewController : UITableViewController {
    id<NewTodoDelegate>delegate;
    NSArray *eventAlerts;
    int index;
}

@property (assign) id<NewTodoDelegate>delegate;

@end
