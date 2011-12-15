//
//  ViewController.h
//  Test
//
//  Created by Nicky on 11/28/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainController.h"

@interface ViewController : UIViewController{
     UITextField *usernameField;
     UITextField *passwordField;
    id<grabdata>delegate;
    UIActivityIndicatorView *loginIndicator;
    UITableView *table;
    NSArray *userArray;
    NSMutableData *tempData;
    NSMutableData *receivedData;
    NSString *term, *termName, *classNumber, *classDescriptionA, *scheduleNumber, *section, *component, *instructor, *meetingDays, *time, *room, *start_end;
}

@property (nonatomic, retain) IBOutlet UITextField *usernameField;
@property (nonatomic, retain) IBOutlet UITextField *passwordField;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *loginIndicator;
//@property (nonatomic, retain) IBOutlet UITableView *table;
@property (assign) id<grabdata>delegate;
//@property(nonatomic, retain) NSMutableData *receivedData;
//@property(nonatomic, retain) NSString *term, *termName, *classNumber, *classDescriptionA, *scheduleNumber, *section, *component, *instructor, *meetingDays, *time, *room, *start_end;
//-(NSArray *) receivedString:(NSString *) theString;

- (IBAction) login: (id) sender;

@end
