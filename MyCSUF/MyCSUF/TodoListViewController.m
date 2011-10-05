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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)] autorelease];
    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(10, 0, tableView.bounds.size.width - 10, 18)] autorelease];
    switch (section) {
        case 0:
            label.text = @"High";
            [label sizeToFit];
            [headerView setBackgroundColor:[UIColor colorWithRed:150.0/255.0 green:5.0/255.0 blue:11.0/255.0 alpha:1.0]];
            break;
        case 1:
            label.text = @"Medium";
            [label sizeToFit];
            [headerView setBackgroundColor:[UIColor colorWithRed:24.0/255.0 green:34.0/255.0 blue:190.0/255.0 alpha:1.0]];
            break;
        case 2:
            label.text = @"Low";
            [label sizeToFit];
            [headerView setBackgroundColor:[UIColor colorWithRed:202.0/255.0 green:84.0/255.0 blue:3.0/255.0 alpha:1.0]];
            break;
        default:
            break;
    }
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    [headerView addSubview:label];
    return headerView;
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
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    switch (indexPath.section) {
        case 0:
//            if (1) {
//                UIImage *image = [UIImage imageNamed:@"priorityHigh.png"];
//                UIImageView *imageView = [[[UIImageView alloc] initWithImage:image] autorelease];
//                imageView.contentMode = UIViewContentModeScaleToFill;
//                cell.backgroundView  = imageView;
//            }
            break;
        case 1:
            break;
        case 2:
            break;
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewTodoItemViewController *editTodoItem = [[NewTodoItemViewController alloc] initWithMangedObjectContext:managedObjectContext withEditableTask:[[todoArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
    UINavigationController *navCon = [[UINavigationController alloc] init];
    [navCon pushViewController:editTodoItem animated:YES];
    [editTodoItem release];
    [self presentModalViewController:navCon animated:YES];
    [navCon release];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
