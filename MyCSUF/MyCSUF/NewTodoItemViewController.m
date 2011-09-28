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
#import "RepeatViewController.h"
#import "AlertViewController.h"
#import "NotesViewController.h"

@implementation NewTodoItemViewController

@synthesize table;
@synthesize editing;

- initWithMangedObjectContext:(NSManagedObjectContext *)context
{
    if ((self = [super init])) {
        managedObjectContext = context;
    }
    return self;
}

- (void)closeView
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)doneButtonPressed
{
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.table == nil) {
        self.table = [tableView retain];
    }
    if (tableData == nil) tableData = [[NSMutableDictionary alloc] initWithCapacity:6];
    static NSString *CellIdentifier = @"TodoListCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        if (indexPath.section == 2) cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        else
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
    switch (indexPath.section) {
        case 0:
            cell.textLabel.text = @"Title";
            cell.detailTextLabel.text = [tableData objectForKey:@"title"];
            break;
        case 1:
            cell.textLabel.text = @"Date";
            cell.detailTextLabel.text = [tableData objectForKey:@"date"];
            break;
        case 2:
            cell.textLabel.text = @"Repeat";
            cell.detailTextLabel.text = [tableData objectForKey:@"repeat"];
            break;
        case 3:
            cell.textLabel.text = @"Alert";
            cell.detailTextLabel.text = [tableData objectForKey:@"alert"];
            break;
        case 4:
            cell.textLabel.text = @"Category";
            break;
        case 5:
            cell.textLabel.text = @"Notes";
            cell.detailTextLabel.text = [tableData objectForKey:@"notes"];
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
                RepeatViewController *repeatViewController = [[RepeatViewController alloc] initWithStyle:UITableViewStyleGrouped];
                repeatViewController.delegate = self;
                [self.navigationController pushViewController:repeatViewController animated:YES];
                [repeatViewController release];
            }
            break;
        case 3:
            if (1) {
                AlertViewController *alertViewController = [[AlertViewController alloc] initWithNibName:@"RepeatViewController" bundle:nil];
                alertViewController.delegate = self;
                [self.navigationController pushViewController:alertViewController animated:YES];
                [alertViewController release];
            }
            break;
        case 4:
            break;
        case 5:
            if (1) {
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
    NSString *stringFromDate = [NSDateFormatter localizedStringFromDate:date dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterMediumStyle];
    [tableData setValue:stringFromDate forKey:@"date"];
}

- (void)updateRepeatField:(NSString *)repeat
{
    NSLog(@"%@",repeat);
    [tableData setValue:repeat forKey:@"repeat"];
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
