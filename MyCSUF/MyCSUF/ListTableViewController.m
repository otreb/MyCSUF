//
//  ListTableViewController.m
//  MyCSUF
//
//  Created by Ismael Martinez on 9/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ListTableViewController.h"
#import "Category.h"
#import "NewListViewController.h"
#import "TodoListViewController.h"

@implementation ListTableViewController

@synthesize managedObjectContext;

- initWithManagedObjectContext:(NSManagedObjectContext *)context
{
    if ((self = [super init])) {
        self.managedObjectContext = context;
        newListCreate = YES;
    }
    return self;
}

// Creates a new Category.
- (void)createNewList
{
    NewListViewController *newListViewController = [[NewListViewController alloc] initWithManagedObjectContext:self.managedObjectContext];
    newListViewController.listDelegate = self;
    UINavigationController *navCon = [[UINavigationController alloc] init];
    [navCon pushViewController:newListViewController animated:YES];
    [newListViewController release];
    navCon.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentModalViewController:navCon animated:YES];
    [navCon release];
}


// Puts the table view in edit Mode
- (void)editButton
{
    if ([self.tableView isEditing]) {
        [UIView animateWithDuration:0.3 animations:^{
            self.tableView.editing = NO;
        }];
    }
    else
        [UIView animateWithDuration:0.3 animations:^{
        self.tableView.editing = YES;
        }];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc]
                                              initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                              target:self
                                              action:@selector(editButton)] autorelease];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]
                                               initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                               target:self
                                               action:@selector(createNewList)] autorelease];
    self.navigationItem.title = @"My List";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // Checks if the table needs to be updated.
    if (newListCreate) {
        myList = [[Category myCurrentList:self.managedObjectContext] retain];
        [self.tableView reloadData];
        newListCreate = NO;
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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
    return [myList count];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

// Will remove a Category that you have deleted and updates that array.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.managedObjectContext deleteObject:[myList objectAtIndex:indexPath.row]];
    [self.managedObjectContext save:NULL];
    [myList release];
    myList = [[Category myCurrentList:self.managedObjectContext] retain];
    [tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    cell.textLabel.text = [[myList objectAtIndex:indexPath.row] name];
    NSString *color = [[myList objectAtIndex:indexPath.row] fontColor];
    if ([color isEqualToString:@"Blue"]) {
        cell.textLabel.textColor = [UIColor blueColor];
    }
    else if ([color isEqualToString:@"Oran."]) {
        cell.textLabel.textColor = [UIColor orangeColor];
    }
    else if ([color isEqualToString:@"Red"]) {
        cell.textLabel.textColor = [UIColor redColor];
    }
    else if ([color isEqualToString:@"Green"]) {
        cell.textLabel.textColor = [UIColor greenColor];
    }
    else if ([color isEqualToString:@"Purp"]) {
        cell.textLabel.textColor = [UIColor purpleColor];
    }
    else
    {
        cell.textLabel.textColor = [UIColor blackColor];
    }
    
    // Configure the cell...
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TodoListViewController *todoListViewController = [[TodoListViewController alloc] initWithToDo:[myList objectAtIndex:indexPath.row] withManagedObjectContext:self.managedObjectContext];
    [self.navigationController pushViewController:todoListViewController animated:YES];
    [todoListViewController release];
}

#pragma mark - List Delegate
- (void)listCreated
{
    newListCreate = YES;
}

@end
