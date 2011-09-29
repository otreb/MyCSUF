//
//  RepeatViewController.m
//  MyCSUF
//
//  Created by Ismael Martinez on 9/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RepeatViewController.h"

@implementation RepeatViewController

@synthesize delegate;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)closeView
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)doneButtonPressed
{
    NSString *stringOfDays = [[[NSString alloc] init] autorelease];
    
    for (int i=0; i< 7; i++) {
        if ([selectedIndex containsObject:[NSNumber numberWithInt:i]]) {
            switch (i) {
                case 0:
                    stringOfDays = [stringOfDays stringByAppendingString:@"Mon "];
                    break;
                case 1:
                    stringOfDays = [stringOfDays stringByAppendingString:@"Tues "];
                    break;
                case 2:
                    stringOfDays = [stringOfDays stringByAppendingString:@"Wed "];
                    break;
                case 3:
                    stringOfDays = [stringOfDays stringByAppendingString:@"Thurs "];
                    break;
                case 4:
                    stringOfDays = [stringOfDays stringByAppendingString:@"Fri "];
                    break;
                case 5:
                    stringOfDays = [stringOfDays stringByAppendingString:@"Sat "];
                    break;
                case 6:
                    stringOfDays = [stringOfDays stringByAppendingString:@"Sun"];
                    break;
                default:
                    break;
            }
        }
    }
    [self.delegate updateRepeatField:stringOfDays];
    [days release];
    [selectedIndex release];
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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]
                                               initWithBarButtonSystemItem:UIBarButtonSystemItemDone 
                                               target:self
                                               action:@selector(doneButtonPressed)] autorelease];
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc]
                                              initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                              target:self
                                              action:@selector(closeView)] autorelease];
    if (selectedIndex == nil) selectedIndex = [[NSMutableArray alloc] init];
    if (days == nil) days = [[NSMutableArray alloc] init];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.delegate = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"Every Monday";
            break;
        case 1:
            cell.textLabel.text = @"Every Tuesday";
            break;
        case 2:
            cell.textLabel.text = @"Every Wednesday";
            break;
        case 3:
            cell.textLabel.text = @"Every Thursday";
            break;
        case 4:
            cell.textLabel.text = @"Every Friday";
            break;
        case 5:
            cell.textLabel.text = @"Every Saturday";
            break;
        case 6:
            cell.textLabel.text = @"Every Sunday";
            break;
        default:
            break;
    }
    if ([selectedIndex containsObject:indexPath]) cell.accessoryType = UITableViewCellAccessoryCheckmark;
    else cell.accessoryType = UITableViewCellAccessoryNone;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([selectedIndex containsObject:[NSNumber numberWithInt:indexPath.row]])
    {
        [selectedIndex removeObject:[NSNumber numberWithInt:indexPath.row]];
        [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryNone];
    }
    else 
    {
        [selectedIndex addObject:[NSNumber numberWithInt:indexPath.row]];
        [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
