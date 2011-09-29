//
//  DatePickerViewController.h
//  MyCSUF
//
//  Created by Ismael Martinez on 9/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DelegeMethods.h"

@interface DatePickerViewController : UIViewController {
    UIDatePicker *datePicker;
    id<NewTodoDelegate>delegate;
}

@property (retain) IBOutlet UIDatePicker *datePicker;
@property (assign) id<NewTodoDelegate>delegate;

@end
