//
//  TitleViewController.h
//  MyCSUF
//
//  Created by Ismael Martinez on 9/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DelegeMethods.h"

@interface TitleViewController : UIViewController <UITextFieldDelegate> {
    UITextField *titleField;
    id<NewTodoDelegate>delegate;
}

@property (retain) IBOutlet UITextField *titleField;
@property (assign) id<NewTodoDelegate>delegate;

@end
