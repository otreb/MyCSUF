//
//  NewListViewController.m
//  MyCSUF
//
//  Created by Ismael Martinez on 9/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NewListViewController.h"
#import "Category.h"

@implementation NewListViewController

@synthesize textField;
@synthesize colorSegment;
@synthesize listDelegate;

- initWithManagedObjectContext:(NSManagedObjectContext *)context
{
    if ((self = [super init])) {
        managedObjectContext = [context retain];
    }
    return self;
}


// Will dismiss the modal the controller is currently in.
- (void)closeView
{
    [self dismissModalViewControllerAnimated:YES];
}

// Creates the Category once you are finished inputing your information.
- (void)donePressed
{
    NSString *color = @"Black";  // This is the Default color.
    if (self.colorSegment.selectedSegmentIndex >=0) {
        color = [self.colorSegment titleForSegmentAtIndex:self.colorSegment.selectedSegmentIndex];
    }
    [Category createNewCategory:self.textField.text withColor:color withManagedObjectContext:managedObjectContext];
    [self.listDelegate listCreated];    // Tells another controller that it has added a new Category.
    [self closeView];
}

- (IBAction)segmentTouched:(UISegmentedControl *)sender
{
    self.colorSegment.momentary = NO;
    self.colorSegment.selectedSegmentIndex = sender.selectedSegmentIndex;
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
    self.navigationItem.title = @"New Todo List";
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    [self.textField becomeFirstResponder];
}

- (void)releaseOutlets
{
    self.textField = nil;
    self.colorSegment = nil;
    self.listDelegate = nil;
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
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
