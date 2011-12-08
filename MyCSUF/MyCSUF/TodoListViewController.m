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

@synthesize listTable, completeTable;
@synthesize pageControl;
@synthesize tableScrollView;

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
    self.tableScrollView.contentSize = CGSizeMake(self.tableScrollView.frame.size.width*2, self.tableScrollView.frame.size.height);
    self.tableScrollView.showsVerticalScrollIndicator = NO;
    self.tableScrollView.showsHorizontalScrollIndicator = NO;
    self.tableScrollView.scrollsToTop = NO;
    self.tableScrollView.delegate = self;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [todoArray release];
    todoArray = [[Task todoListForCategory:currentCategory inManagedObjectContext:managedObjectContext] retain];
    completedArray = [[Task completedTaskForCategory:currentCategory inManagedObjectContext:managedObjectContext] retain];
    [self.listTable reloadData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.listTable = nil;
    self.completeTable = nil;
    self.tableScrollView = nil;
    self.pageControl = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Table View Data Source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 1) {
        return [completedArray count];
    }
    return [[todoArray objectAtIndex:section] count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView.tag == 1) {
        return 1;
    }
    return [todoArray count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView.tag ==1) {
        return @"Completed";
    }
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
    if (tableView.tag == 0)
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
    }
    else
    {
        Task *deleteTask = [completedArray objectAtIndex:indexPath.row];
        [completedArray release];
        completedArray = nil;
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
        completedArray = [[Task completedTaskForCategory:currentCategory inManagedObjectContext:managedObjectContext] retain];
    }
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
    if (tableView.tag ==0)
    {
        cell.title.text = [[[todoArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] title];
        cell.dateMonth.text = [NSDateFormatter localizedStringFromDate:[[[todoArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] date] dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterNoStyle];
        cell.dateTime.text = [NSDateFormatter localizedStringFromDate:[[[todoArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] date] dateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterShortStyle];
        cell.notes.text = [[[todoArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] notes];
    }
    else
    {
        cell.title.text = [[completedArray objectAtIndex:indexPath.row] title];
        cell.dateMonth.text = [NSDateFormatter localizedStringFromDate:[[completedArray objectAtIndex:indexPath.row] date] dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterNoStyle];
        cell.dateTime.text = [NSDateFormatter localizedStringFromDate:[[completedArray objectAtIndex:indexPath.row] date] dateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterShortStyle];
        cell.notes.text = [[completedArray objectAtIndex:indexPath.row] notes];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [indexPathSelect release];
    indexPathSelect = [indexPath retain];
    if (tableView.tag == 0)
    {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Choose one" 
                                                                 delegate:self
                                                        cancelButtonTitle:@"Cancel"
                                                   destructiveButtonTitle:@"Complete"
                                                        otherButtonTitles:@"Edit",@"Delete", nil];
        actionSheet.tag = 0;
        [actionSheet showFromTabBar:self.tabBarController.tabBar];
        [actionSheet release];
    }
    else
    {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Choose one" 
                                                                 delegate:self
                                                        cancelButtonTitle:@"Cancel"
                                                   destructiveButtonTitle:@"Not Complete"
                                                        otherButtonTitles:@"Delete", nil];
        actionSheet.tag = 1;
        [actionSheet showFromTabBar:self.tabBarController.tabBar];
        [actionSheet release];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Action Sheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 0)
    {
        if (buttonIndex == 0) {
            Task *task = [[todoArray objectAtIndex:indexPathSelect.section] objectAtIndex:indexPathSelect.row];
            [Task markTaskAsComplete:task inManagedObjectContext:managedObjectContext];
            [todoArray release];
            todoArray = nil;
            todoArray = [[Task todoListForCategory:currentCategory inManagedObjectContext:managedObjectContext] retain];
            [completedArray release];
            completedArray = nil;
            completedArray = [[Task completedTaskForCategory:currentCategory inManagedObjectContext:managedObjectContext] retain];
            [self.listTable reloadData];
            [self.completeTable reloadData];
        }
        else if (buttonIndex == 1) {
            NewTodoItemViewController *editTodoItem = [[NewTodoItemViewController alloc] initWithMangedObjectContext:managedObjectContext withEditableTask:[[todoArray objectAtIndex:indexPathSelect.section] objectAtIndex:indexPathSelect.row]];
            UINavigationController *navCon = [[UINavigationController alloc] init];
            [navCon pushViewController:editTodoItem animated:YES];
            [editTodoItem release];
            [self presentModalViewController:navCon animated:YES];
            [navCon release];
        }
        else if (buttonIndex == 2)
        {
            if ([self tableView:self.listTable canEditRowAtIndexPath:indexPathSelect]) {
                [self tableView:self.listTable commitEditingStyle:UITableViewCellEditingStyleDelete forRowAtIndexPath:indexPathSelect];
            }
        }
    }
    else
    {
        if (buttonIndex == 0) {
            Task *task = [completedArray objectAtIndex:indexPathSelect.row];
            [Task markTaskAsNotComplete:task inManagedObjectContext:managedObjectContext];
            [todoArray release];
            todoArray = nil;
            todoArray = [[Task todoListForCategory:currentCategory inManagedObjectContext:managedObjectContext] retain];
            [completedArray release];
            completedArray = nil;
            completedArray = [[Task completedTaskForCategory:currentCategory inManagedObjectContext:managedObjectContext] retain];
            [self.listTable reloadData];
            [self.completeTable reloadData];
        }
        else if (buttonIndex == 1) {
            if ([self tableView:self.completeTable canEditRowAtIndexPath:indexPathSelect]) {
                [self tableView:self.completeTable commitEditingStyle:UITableViewCellEditingStyleDelete forRowAtIndexPath:indexPathSelect];
            }
        }
    }
}

#pragma mark - Scroll View Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    self.pageControl.currentPage = page;
}

@end
