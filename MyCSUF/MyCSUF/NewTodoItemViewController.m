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
    static NSString *CellIdentifier = @"TodoListCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
    switch (indexPath.section) {
        case 0:
            cell.textLabel.text = @"Title";
            break;
        case 1:
            cell.textLabel.text = @"Date";
            break;
        case 2:
            cell.textLabel.text = @"Repeat";
            break;
        case 3:
            cell.textLabel.text = @"Alert";
            break;
        case 4:
            cell.textLabel.text = @"Category";
            break;
        case 5:
            cell.textLabel.text = @"Notes";
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
            break;
        case 2:
            break;
        case 3:
            break;
        case 4:
            break;
        case 5:
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
}

- (void)updateDateField:(NSDate *)date
{
    NSLog(@"%@",[NSDateFormatter localizedStringFromDate:date dateStyle:NSDateFormatterLongStyle timeStyle:NSDateFormatterLongStyle]);
}

- (void)updateReminderField:(NSString *)reminder
{
    NSLog(@"%@",reminder);
}

@end
