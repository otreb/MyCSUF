//
//  NewListViewController.h
//  MyCSUF
//
//  Created by Ismael Martinez on 9/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

/*
 This Controller will create a new Category.  It just consist of a text field
 and a segment control.
*/

#import <UIKit/UIKit.h>
#import "DelegeMethods.h"

@interface NewListViewController : UIViewController {
    NSManagedObjectContext *managedObjectContext;
    UITextField *textField;
    UISegmentedControl *colorSegment;
    id<ListDelegate>listDelegate;
}

@property (retain) IBOutlet UITextField *textField;
@property (retain) IBOutlet UISegmentedControl *colorSegment;
@property (assign) id<ListDelegate>listDelegate;

- initWithManagedObjectContext:(NSManagedObjectContext *)context;

- (IBAction)segmentTouched:(UISegmentedControl *)sender;

@end
