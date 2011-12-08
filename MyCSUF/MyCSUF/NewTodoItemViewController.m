//
//  NewTodoItemViewController.m
//  MyCSUF
//
//  Created by Ismael Martinez on 9/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NewTodoItemViewController.h"
#import "Configurations.h"
#import "TitleViewController.h"
#import "DatePickerViewController.h"
#import "AlertViewController.h"
#import "NotesViewController.h"
#import "Task.h"
#import "ListTableViewController.h"

@implementation NewTodoItemViewController

@synthesize table;
@synthesize editing;
@synthesize currentCategory;
@synthesize cellFive;
@synthesize prioritySegment;

- initWithMangedObjectContext:(NSManagedObjectContext *)context
{
    if ((self = [super init])) {
        managedObjectContext = context;
    }
    return self;
}

// Will fill the view with all the todo information if a todo item was selected.
- initWithMangedObjectContext:(NSManagedObjectContext *)context withEditableTask:(Task *)task
{
    if ((self = [super init])) {
        managedObjectContext = context;
        currentTask = task;
        currentCategory = (Category *)task.category;
        tableData = [[NSMutableDictionary alloc] init];
        [tableData setValue:task.title forKey:@"title"];
        [tableData setValue:task.date forKey:@"date"];
        [tableData setValue:task.alert forKey:@"alert"];
        [tableData setValue:currentCategory.name forKey:@"category"];
        [tableData setValue:task.notes forKey:@"notes"];
        [tableData setValue:task.priority forKey:@"priority"];
        [stringDate release];
        stringDate = [[NSDateFormatter localizedStringFromDate:task.date dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterShortStyle] retain];
    }
    return self;
}

- initWithMangedObjectContext:(NSManagedObjectContext *)context withEvent:(NSMutableDictionary *)dictionary
{
    if ((self = [super init])) {
        managedObjectContext = context;
        tableData = dictionary;
        event = YES;
    }
    return self;
}

- (void)closeView
{
    [self dismissModalViewControllerAnimated:YES];
}

// Schedules the notification if one was selected.
- (void)scheduleNotificationReminder
{
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    NSString *time = [tableData objectForKey:@"alert"];
    int interval = 0;
    if ([time isEqualToString:@"5 minutes before"]) interval = 5;
    else if ([time isEqualToString:@"10 minutes before"]) interval = 10;
    else if ([time isEqualToString:@"15 minutes before"]) interval = 15;
    else if ([time isEqualToString:@"30 minutes before"]) interval = 30;
    else if ([time isEqualToString:@"1 hour before"]) interval = 60;
    else if ([time isEqualToString:@"2 hour before"]) interval = 2*60;
    else if ([time isEqualToString:@"1 day before"]) interval = 60*24;
    else if ([time isEqualToString:@"2 days before"]) interval = 2*60*24;
    localNotification.fireDate = [NSDate dateWithTimeInterval:-60*interval sinceDate:[tableData objectForKey:@"date"]];
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    NSDateFormatter *format = [[[NSDateFormatter alloc] init] autorelease];
    [format setDateFormat:@"EEE MMM dd 'at' hh:mm aaa"];
    localNotification.alertBody = [NSString stringWithFormat:@"Appointment for %@ on %@",[tableData objectForKey:@"title"],[format stringFromDate:[tableData objectForKey:@"date"]]];
    localNotification.alertAction = NSLocalizedString(@"View Details", nil);
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    localNotification.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:[tableData objectForKey:@"title"], @"title",[tableData objectForKey:@"date"], @"date",nil];
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    [localNotification release];
}

// Will save all the data that was entered by the user.
- (void)doneButtonPressed
{
    [tableData setValue:[NSNumber numberWithInt:selectedSegment] forKey:@"priority"];
    if ([[tableData objectForKey:@"title"] length] > 0)
    {
        if (!currentCategory)
        {
            UIAlertView *alert = [[UIAlertView alloc] 
                                  initWithTitle:@"Error"
                                  message:@"Please select a category for this todo"
                                  delegate:nil
                                  cancelButtonTitle:@"Ok"
                                  otherButtonTitles: nil];
            [alert show];
            [alert release];
        }
        else {
            if (currentTask == nil)
                [Task addTodoItem:tableData withCategory:currentCategory inMangedObjectContext:managedObjectContext];
            else
                [Task editTodoItem:currentTask withNewInformation:tableData inMangedObjectContext:managedObjectContext];
            if ([tableData objectForKey:@"alert"] != nil && [tableData objectForKey:@"date"] !=nil)
                [self scheduleNotificationReminder];
            [self closeView];
        }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Error"
                              message:@"Need to supply a Title"
                              delegate:nil
                              cancelButtonTitle:@"Ok"
                              otherButtonTitles: nil];
        [alert show];
        [alert release];
    }
}
- (void)prioritySegmentChanged:(UISegmentedControl *)segment
{
    selectedSegment = segment.selectedSegmentIndex;
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
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(closeView)] autorelease];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonPressed)] autorelease];
    if (!editing) {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
    self.navigationItem.title = @"New Todo";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [tableData setValue:currentCategory.name forKey:@"category"];
    if ([[tableData allKeys] count] > 0) {
        if (!self.navigationItem.rightBarButtonItem.enabled) {
            self.navigationItem.rightBarButtonItem.enabled = YES;
        }
        [self.table reloadData];
    }
}

- (void)releaseOutlets
{
    self.table = nil;
    self.cellFive = nil;
    self.prioritySegment = nil;
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

#pragma mark - Table View Data Source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return kNumberOfCells;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return kNumberOfSections;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Adjust cell number 4 so that the note can be displayed in a single cell and not overlap.
    if (indexPath.section == 4) {
        count = 0;
        int length = [[tableData objectForKey:@"notes"] length];
        while (length > 25) {
            count+=15;
            length -= 25;
        }
    }
    // This is for the custom cell with the segment control as a subview.
    else if (indexPath.section == 5) {
        return 63;
    }
    return (indexPath.section == 4) ? count+50 : 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.table == nil) {
        self.table = [tableView retain];
    }
    if (tableData == nil) tableData = [[NSMutableDictionary alloc] initWithCapacity:6];
    // Checks if section 5 is currently being configure.  Returns a custom cell.
    if (indexPath.section ==5) {
        self.prioritySegment.selectedSegmentIndex = [[tableData valueForKey:@"priority"] intValue];
        [self.prioritySegment addTarget:self action:@selector(prioritySegmentChanged:) forControlEvents:UIControlEventValueChanged];
        return cellFive;
    }
    
    // Creates the same cell for the rest of the table view.
    static NSString *CellIdentifier = @"TodoListCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil && indexPath.section !=5) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
    switch (indexPath.section) {
        case 0:
            cell.textLabel.text = @"Title";
            cell.detailTextLabel.text = [tableData objectForKey:@"title"];
            break;
        case 1:
            cell.textLabel.text = @"Date";
            cell.detailTextLabel.text = stringDate;
            break;
        case 2:
            cell.textLabel.text = @"Alert";
            cell.detailTextLabel.text = [tableData objectForKey:@"alert"];
            break;
        case 3:
            cell.textLabel.text = @"Category";
            cell.detailTextLabel.text = [tableData objectForKey:@"category"];
            break;
        case 4:
            cell.textLabel.text = @"Notes";
            cell.textLabel.textColor = [UIColor grayColor];
            if ([tableData objectForKey:@"notes"] != nil) {
                cell.textLabel.text = [tableData objectForKey:@"notes"];
                cell.textLabel.textColor = [UIColor blackColor];
                cell.textLabel.numberOfLines = count;
            }
            break;
        default:
            break;
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            if (1)
            {
                TitleViewController *titleViewController;
                if ([tableData objectForKey:@"title"] != nil) {
                    titleViewController = [[TitleViewController alloc] initWithTitle:[tableData objectForKey:@"title"]];
                }
                else
                    titleViewController = [[TitleViewController alloc] init];
                
                titleViewController.delegate = self;
                [self.navigationController pushViewController:titleViewController animated:YES];
                [titleViewController release];
            }
            break;
        case 1:
            if (1) {
                DatePickerViewController *datePickerViewController = [[DatePickerViewController alloc] init];
                datePickerViewController.delegate = self;
                [self.navigationController pushViewController:datePickerViewController animated:YES];
                [datePickerViewController release];
            }
            break;
        case 2:
            if (1) {
                AlertViewController *alertViewController = [[AlertViewController alloc] initWithNibName:@"ListTableViewController" bundle:nil];
                alertViewController.delegate = self;
                [self.navigationController pushViewController:alertViewController animated:YES];
                [alertViewController release];
            }
            break;
        case 3:
            if (event) {
                ListTableViewController *listTableView = [[ListTableViewController alloc] initWithManagedObjectContext:managedObjectContext creatingEvent:YES];
                listTableView.delegate = self;
                [self.navigationController pushViewController:listTableView animated:YES];
                [listTableView release];
            }
            break;
        case 4:
            if (1) {
                cellAdjusted = NO;
                NotesViewController *noteViewController;
                if (currentTask.notes != nil) {
                    noteViewController = [[NotesViewController alloc] initWithText:currentTask.notes];
                }
                else
                    noteViewController = [[NotesViewController alloc] init];
                noteViewController.delegate = self;
                [self.navigationController pushViewController:noteViewController animated:YES];
                [noteViewController release];
            }
            break;
        default:
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - New Todo Delegate
- (void)updateTitleField:(NSString *)title
{
    [tableData setValue:title forKey:@"title"];
}

- (void)updateDateField:(NSDate *)date
{
    [stringDate release];
    stringDate = [[NSDateFormatter localizedStringFromDate:date dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterShortStyle] retain];
    [tableData setValue:date forKey:@"date"];
    
}

- (void)updateAlertField:(NSString *)alert
{
    [tableData setValue:alert forKey:@"alert"];
}

- (void)updateNotesField:(NSString *)notes
{
    [tableData setValue:notes forKey:@"notes"];
}

- (void)updateCategoryField:(Category *)category;
{
    currentCategory = category;
}

@end
