//
//  HelpViewController.h
//  MyCSUF
//
//  Created by Ismael Martinez on 12/15/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface HelpViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, MFMessageComposeViewControllerDelegate> {
    UITableView *table;
}

@property (nonatomic, retain) IBOutlet UITableView *table;

@end
