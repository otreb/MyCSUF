//
//  MyCSUFappAppDelegate.h
//  MyCSUFapp
//
//  Created by Bert Aguilar on 9/19/11.
//  Copyright 2011 Apple Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyCSUFappViewController;

@interface MyCSUFappAppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet MyCSUFappViewController *viewController;

@end
