//
//  TodoListViewController.m
//  MyCSUF
//
//  Created by Ismael Martinez on 9/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TodoListViewController.h"
#import "NewTodoItemViewController.h"
#import "Task.h"

@implementation TodoListViewController

@synthesize table;

- initWithToDo:(Category *)category withManagedObjectContext:(NSManagedObjectContext *)context
{
    if ((self = [super init])) {
        managedObjectContext = context;
        currentCategory = category;
    }
    return self;
}

- (void)addButtonPressed
{
    NewTodoItemViewController *newTodoItemViewController = [[NewTodoItemViewController alloc] initWithMangedObjectContext:managedObjectContext];
    newTodoItemViewController.currentCategory = currentCategory;
    UINavigationController *navCon = [[UINavigationController alloc] init];
    [navCon pushViewController:newTodoItemViewController animated:YES];
    [newTodoItemViewController release];
    navCon.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentModalViewController:navCon animated:YES];
    [navCon release];
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
                                               initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                               target:self
                                               action:@selector(addButtonPressed)] autorelease];
    self.navigationItem.title = @"Todo";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [todoArray release];
    todoArray = [[Task todoListForCategory:currentCategory inManagedObjectContext:managedObjectContext] retain];
    [self.table reloadData];
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
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Table View Data Source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[todoArray objectAtIndex:section] count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [todoArray count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"High";
            break;
        case 1:
            return @"Medium";
            break;
        case 2:
            return @"Low";
            break;
        default:
            break;
    }
    return @"";
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    Task *deleteTask = [[todoArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    [todoArray release];
    todoArray = nil;
    [managedObjectContext deleteObject:deleteTask];
    [managedObjectContext save:NULL];
    todoArray = [[Task todoListForCategory:currentCategory inManagedObjectContext:managedObjectContext] retain];
    [tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TodoListCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
    cell.textLabel.text = [[[todoArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] title];
    
    return cell;
}

@end
