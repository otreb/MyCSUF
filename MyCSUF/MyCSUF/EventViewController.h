//
//  EventViewController.h
//  MyCSUF
//
//  Created by Ismael Martinez on 11/16/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventViewController : UIViewController {
    NSURL *URL;
    NSMutableData *tempData;
    UILabel *whenLabel, *whereLabel, *eventTypeLabel, *organizationLabel, *expectedLabel, *registeredLabel, *eventStateLabel, *moreInfo;
    UITextView *noteView;
    UIWebView *web;
}

- initWithURL:(NSString *)sender;

@property (nonatomic, retain) IBOutlet UILabel *whenLabel, *whereLabel, *eventTypeLabel, *organizationLabel, *expectedLabel, *registeredLabel, *eventStateLabel, *moreInfo;
@property (nonatomic, retain) IBOutlet UITextView *noteView;
@property (nonatomic, retain) IBOutlet UIWebView *web;

@end
