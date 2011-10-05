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

@implementation NewTodoItemViewController

@synthesize table;
@synthesize editing;
@synthesize currentCategory;

- initWithMangedObjectContext:(NSManagedObjectContext *)context
{
    if ((self = [super init])) {
        managedObjectContext = context;
    }
    return self;
}

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

- (void)closeView
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)doneButtonPressed
{
    [tableData setValue:[NSNumber numberWithInt:selectedSegment] forKey:@"priority"];
    if ([[tableData objectForKey:@"title"] length] > 0)
    {
        if (currentTask == nil)
            [Task addTodoItem:tableData withCategory:currentCategory inMangedObjectContext:managedObjectContext];
        else
            [Task editTodoItem:currentTask withNewInformation:tableData inMangedObjectContext:managedObjectContext];
        [self closeView];
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

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.table = nil;
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
    return (indexPath.section == 4) ? count+50 : 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.table == nil) {
        self.table = [tableView retain];
    }
    if (prioritySegment == nil) {
        prioritySegment = [[[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Low",@"Medium",@"High", nil]] autorelease];
    }
    if (tableData == nil) tableData = [[NSMutableDictionary alloc] initWithCapacity:6];
    static NSString *CellIdentifier = @"TodoListCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
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
                if (!cellAdjusted)
                {
                    count = 0;
                    int length = [[tableData objectForKey:@"notes"] length];
                    while (length > 25) {
                        count+=15;
                        length -= 25;
                    }
                }
                cell.textLabel.text = [tableData objectForKey:@"notes"];
                cell.textLabel.textColor = [UIColor blackColor];
                cell.textLabel.numberOfLines = count;
                if (!cellAdjusted) {
                    cellAdjusted = YES;
                    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:NO];
                }
            }
            prioritySegment.hidden = YES;
            break;
        case 5:
            cell.textLabel.text = @"Priority";
            prioritySegment.selectedSegmentIndex = [[tableData objectForKey:@"priority"] boolValue]?[[tableData objectForKey:@"priority"] intValue]: 0;
            [prioritySegment addTarget:self action:@selector(prioritySegmentChanged:) forControlEvents:UIControlEventValueChanged];
            CGPoint origin = CGPointMake(80, 5);
            prioritySegment.frame = CGRectMake(origin.x, origin.y, 212.0, 44.0);
            [cell.contentView addSubview:prioritySegment];
            prioritySegment.hidden = NO;
            break;
        default:
            break;
    }
    if (indexPath.section == 5) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    else
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            if (1)
            {
                TitleViewController *titleViewController = [[TitleViewController alloc] init];
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
                AlertViewController *alertViewController = [[AlertViewController alloc] initWithNibName:@"RepeatViewController" bundle:nil];
                alertViewController.delegate = self;
                [self.navigationController pushViewController:alertViewController animated:YES];
                [alertViewController release];
            }
            break;
        case 3:
            break;
        case 4:
            if (1) {
                cellAdjusted = NO;
                NotesViewController *noteViewController = [[NotesViewController alloc] init];
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
    NSLog(@"%@",title);
    [tableData setValue:title forKey:@"title"];
}

- (void)updateDateField:(NSDate *)date
{
    NSLog(@"%@",[NSDateFormatter localizedStringFromDate:date dateStyle:NSDateFormatterLongStyle timeStyle:NSDateFormatterLongStyle]);
    [stringDate release];
    stringDate = [[NSDateFormatter localizedStringFromDate:date dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterShortStyle] retain];
    [tableData setValue:date forKey:@"date"];
    
}

- (void)updateAlertField:(NSString *)alert
{
    NSLog(@"%@",alert);
    [tableData setValue:alert forKey:@"alert"];
}

- (void)updateNotesField:(NSString *)notes
{
    NSLog(@"%@", notes);
    [tableData setValue:notes forKey:@"notes"];
}

@end
