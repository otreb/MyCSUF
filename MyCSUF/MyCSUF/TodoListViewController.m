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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table View Data Source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [todoArray count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TodoListCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
    cell.textLabel.text = [[todoArray objectAtIndex:indexPath.row] title];
    
    return cell;
}

@end
