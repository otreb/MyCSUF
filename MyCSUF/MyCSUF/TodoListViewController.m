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
#import "TodoListTableViewCell.h"

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

// Shows the new view controller to be able to create a new todo item.
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
    if (section == 0) 
        return @"High";
    else if (section == 1)
        return @"Medium";
    return @"Low";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 66;
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
    NSArray *scheduleNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    for (UILocalNotification *notification in scheduleNotifications)
    {
        if ([notification.userInfo objectForKey:@"title"] == deleteTask.title &&
            [notification.userInfo objectForKey:@"date"] == deleteTask.date) {
            [[UIApplication sharedApplication] cancelLocalNotification:notification];
        }
    }
    [managedObjectContext deleteObject:deleteTask];
    [managedObjectContext save:NULL];
    todoArray = [[Task todoListForCategory:currentCategory inManagedObjectContext:managedObjectContext] retain];
    [tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TodoListCell";

    TodoListTableViewCell *cell = (TodoListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *items = [[NSBundle mainBundle] loadNibNamed:@"TodoListTableViewCell" owner:nil options:nil];
        for (id currentObjects in items)
        {
            if ([currentObjects isKindOfClass:[UITableViewCell class]]) {
                cell = (TodoListTableViewCell *)currentObjects;
                break;
            }
        }
    }
    cell.title.text = [[[todoArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] title];
    cell.date.text = [NSDateFormatter localizedStringFromDate:[[[todoArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] date] dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterShortStyle];
    cell.notes.text = [[[todoArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] notes];
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
    [indexPathSelect release];
    indexPathSelect = [indexPath retain];
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Choose one" 
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:@"Complete"
                                                    otherButtonTitles:@"Edit", nil];
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
    [actionSheet release];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Action Sheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
    }
    else if (buttonIndex == 1) {
        NewTodoItemViewController *editTodoItem = [[NewTodoItemViewController alloc] initWithMangedObjectContext:managedObjectContext withEditableTask:[[todoArray objectAtIndex:indexPathSelect.section] objectAtIndex:indexPathSelect.row]];
        UINavigationController *navCon = [[UINavigationController alloc] init];
        [navCon pushViewController:editTodoItem animated:YES];
        [editTodoItem release];
        [self presentModalViewController:navCon animated:YES];
        [navCon release];
    }
}

@end
