//
//  EventsTableViewController.m
//  MyCSUF
//
//  Created by Ismael Martinez on 11/2/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "EventsTableViewController.h"
#import "EventsTableCell.h"
#import "EventViewController.h"
#import "NewTodoItemViewController.h"

//#define EventsURL @"http://25livepub.collegenet.com/s.aspx?calendar=all-non-academic&widget=main&srpc.cbid=trumba.spud.3&srpc.get=true&"
#define EventsURL @"http://25livepub.collegenet.com/calendars/all-non-academic.rss"

@implementation EventsTableViewController

@synthesize table;
@synthesize currentDate;

- initWithManagedObjectContext:(NSManagedObjectContext *)context
{
    self = [super init];
    if (self) {
        managedObjectContext = context;
    }
    return self;
}

- (void)separateEvents:(NSArray *)eventsInfoArray
{
    int outCount = 0;
    NSMutableArray *finalArray = [[NSMutableArray alloc] init];
    for (NSArray *tempArray in eventsInfoArray)
    {
        int innerCount = 0;
        NSMutableDictionary *tempDictionary = [[NSMutableDictionary alloc] init];
        for (NSString *tempString in tempArray)
        {
            switch (innerCount) {
                case 0:
                    [tempDictionary setValue:[tempString substringWithRange:NSMakeRange(7, [tempString length]-8)] forKey:@"title"];
                    break;
                case 1:
                    if (1) 
                    {
                        NSString *string = [tempString stringByReplacingOccurrencesOfString:@"&lt;" withString:@""];
                        string = [string stringByReplacingOccurrencesOfString:@"b&gt;" withString:@""];
                        string = [string stringByReplacingOccurrencesOfString:@"/b&gt;" withString:@""];
                        string = [string stringByReplacingOccurrencesOfString:@"&amp;nbsp;&amp;ndash;&amp;nbsp;" withString:@"-"];
                        NSArray *array = [string componentsSeparatedByString:@"br/&gt;"];
                        [tempDictionary setValue:[array objectAtIndex:0] forKey:@"location"];
                        [tempDictionary setValue:[array objectAtIndex:1] forKey:@"date"];
                    }
                    break;
                case 2:
                    [tempDictionary setValue:[tempString substringWithRange:NSMakeRange(6, [tempString length]-14)] forKey:@"link"];
                    break;
                default:
                    break;
            }
            innerCount++;
        }
        [finalArray addObject:tempDictionary];
        [tempDictionary release];
        outCount++;
    }
    [eventsArray release];
    eventsArray = nil;
    eventsArray = [[NSArray alloc] initWithArray:finalArray];
}

- (void)allEvents:(NSArray *)eventsString
{

    NSMutableArray *eventInfoArrays = [[NSMutableArray alloc] initWithCapacity:[eventsString count]];
    for (NSString *string in eventsString)
    {
        NSMutableArray *tempArray = [[NSMutableArray alloc] initWithArray:[string componentsSeparatedByString:@"\n\t\t\t"]];
        [tempArray removeObjectAtIndex:0];
        [eventInfoArrays addObject:tempArray];
        [tempArray release];
    }
    [self separateEvents:eventInfoArrays];
    [eventInfoArrays release];
}

- (void)beginParsing
{
    NSString *HTMLCode=[[NSString alloc] initWithBytes:[tempData bytes] length:[tempData length] encoding:NSUTF8StringEncoding];
    NSMutableArray *parsedData = [[NSMutableArray alloc] initWithArray:[HTMLCode componentsSeparatedByString:@"<item>"]];
    if ([parsedData count]>0)
        [parsedData removeObjectAtIndex:0];
    [self allEvents:parsedData];
    [parsedData release];
    [HTMLCode release];
    [self.table reloadData];
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
    self.navigationItem.title = @"Campus Events";
    if (!tempData)
    {
        NSURL *url = [NSURL URLWithString:EventsURL];
        NSURLRequest *requet = [[NSURLRequest alloc] initWithURL:url];
        [[NSURLConnection alloc] initWithRequest:requet delegate:self startImmediately:YES];
        [requet release];
    }
    else
    {
        [self beginParsing];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.currentDate = [[NSDate alloc] initWithTimeInterval:0 sinceDate:[NSDate date]];
}

- (void)releaseOutlets
{
    self.table = nil;
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

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (tempData == nil) {
        tempData = [[NSMutableData alloc] init];
    }
    [tempData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [connection release];
    [self beginParsing];
}

#pragma mark - Table View Data Source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [eventsArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 84.0;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] 
                                  initWithTitle:@"Create To-do"
                                  delegate:self
                                  cancelButtonTitle:@"Cancel"
                                  destructiveButtonTitle:@"Create"
                                  otherButtonTitles: nil];
    actionSheet.tag = indexPath.row;
    [actionSheet showFromTabBar:self.navigationController.tabBarController.tabBar];
    [actionSheet release];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"EventsTableCell";
    EventsTableCell *cell = (EventsTableCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *items = [[NSBundle mainBundle] loadNibNamed:@"EventsTableCell" owner:nil options:nil];
        for (id currentObjects in items)
        {
            if ([currentObjects isKindOfClass:[UITableViewCell class]]) {
                cell = (EventsTableCell *)currentObjects;
                break;
            }
        }
    }
    NSString *title = [[eventsArray objectAtIndex:indexPath.row] valueForKey:@"title"];
    cell.titleLabel.text = [title substringToIndex:[title length] -8];
    cell.dateLabel.text = [[eventsArray objectAtIndex:indexPath.row] valueForKey:@"date"];
    cell.locationLabel.text = [[[eventsArray objectAtIndex:indexPath.row] valueForKey:@"location"] substringFromIndex:13];
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    return cell;
}

#pragma mark - Table View Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *URL = [[NSString alloc] initWithString:[[eventsArray objectAtIndex:indexPath.row] valueForKey:@"link"]];
    EventViewController *eventViewController = [[EventViewController alloc] initWithURL:URL];
    [URL release];
    [self.navigationController pushViewController:eventViewController animated:YES];
    [eventViewController release];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSString *title = [[eventsArray objectAtIndex:actionSheet.tag] valueForKey:@"title"];
        title = [title substringToIndex:[title length] -8];
        [[eventsArray objectAtIndex:actionSheet.tag] setValue:title forKey:@"title"];
        UINavigationController *navCon = [[UINavigationController alloc] init];
        NewTodoItemViewController *newTodo = [[NewTodoItemViewController alloc] initWithMangedObjectContext:managedObjectContext withEvent:[eventsArray objectAtIndex:actionSheet.tag]];
        [navCon pushViewController:newTodo animated:YES];
        [newTodo release];
        [self presentModalViewController:navCon animated:YES];
        [navCon release];
    }
}

@end
