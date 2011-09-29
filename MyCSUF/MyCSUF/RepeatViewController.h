//
//  RepeatViewController.h
//  MyCSUF
//
//  Created by Ismael Martinez on 9/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DelegeMethods.h"

@interface RepeatViewController : UITableViewController {
    id<NewTodoDelegate>delegate;
    NSMutableArray *selectedIndex;
    NSMutableArray *days;
}

@property (assign) id<NewTodoDelegate>delegate;

@end
