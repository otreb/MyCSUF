//
//  DatePickerViewController.m
//  MyCSUF
//
//  Created by Ismael Martinez on 9/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DatePickerViewController.h"

@implementation DatePickerViewController

@synthesize datePicker;
@synthesize delegate;

- (void)closeView
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)donePressed
{
    [self.delegate updateDateField:self.datePicker.date];
    [self closeView];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]
                                               initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                               target:self
                                               action:@selector(donePressed)] autorelease];
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc]
                                              initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                              target:self
                                              action:@selector(closeView)] autorelease];
    self.navigationItem.title = @"Date";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.datePicker.date = [NSDate date];
}

- (void)releaseOutlets
{
    self.datePicker = nil;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [self releaseOutlets];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
