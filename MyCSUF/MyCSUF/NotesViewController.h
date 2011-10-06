//
//  NotesViewController.h
//  MyCSUF
//
//  Created by Ismael Martinez on 9/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DelegeMethods.h"

@interface NotesViewController : UIViewController {
    UITextView *notes;
    id<NewTodoDelegate>delegate;
    NSString *currentNote;
}

@property (retain) IBOutlet UITextView *notes;
@property (assign) id<NewTodoDelegate>delegate;

- initWithText:(NSString *)note;

@end
