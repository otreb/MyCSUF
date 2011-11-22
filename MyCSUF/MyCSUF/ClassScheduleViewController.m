//
//  ClassScheduleViewController.m
//  MyCSUF
//
//  Created by Bert Aguilar on 10/5/11.
//  Copyright 2011 Apple Inc. All rights reserved.
//

#import "ClassScheduleViewController.h"
#import "ClassScheduleViewCell.h"
#import "MapViewController.h"
#import "OptionsViewController.h"

@implementation ClassScheduleViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

    //
- (void)optionsButton
{
    OptionsViewController *optionsViewController = [[OptionsViewController alloc] init];
    UINavigationController *oButton = [[UINavigationController alloc] init];
    [oButton pushViewController:optionsViewController animated:YES];
    [optionsViewController release];
    oButton.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentModalViewController:oButton animated:YES];
    [oButton release];
    
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.rowHeight=95;
    self.tableView.allowsSelection=YES;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor=[UIColor colorWithRed:.90 green:.90 blue:.90 alpha:1];
    self.view.backgroundColor=[UIColor colorWithRed:250 green:247 blue:247 alpha:1];

    // Puts button on top right corner to select a different semester
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector
        (optionsButton)] autorelease];
    
// this is where the core data info will be loaded
    
    courseName = [[NSArray alloc] initWithObjects:@"course1", @"course2", @"course3",nil];
    courseNumber = [[NSArray alloc] initWithObjects:@"ECE 118",@"ECE 124", @"ECE 176", nil];
    classTime = [[NSArray alloc] initWithObjects:@"11-12", @"2-3", @"5-6", nil];
    room = [[NSArray alloc] initWithObjects:@"EE 120", @"EE 120", @"EE 120", nil];
    teacher = [[NSArray alloc] initWithObjects:@"teacher1", @"teacher2", @"teacher3", nil];    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [room count]; 
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ClassScheduleViewCell";
    
    ClassScheduleViewCell *cell = (ClassScheduleViewCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ClassScheduleViewCell" owner:self options:nil];
        
        for (id currentObject in topLevelObjects){
            if([currentObject isKindOfClass:[UITableViewCell class]]){
                cell = (ClassScheduleViewCell *) currentObject;
                break;
            }
        }
    }
    cell.courseName.text = [courseName objectAtIndex:indexPath.row];
    cell.courseNumber.text = [courseNumber objectAtIndex:indexPath.row];
    cell.classTime.text = [classTime objectAtIndex:indexPath.row];
    cell.room.text = [room objectAtIndex:indexPath.row];
    cell.teacher.text = [teacher objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    
     MapViewController *mapViewController = [[MapViewController alloc] initWithNibName:@"MapViewController" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:mapViewController animated:YES];
     [MapViewController release];
}

// allows for alternationg colors when viewing cells
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row%2==0) {
        cell.backgroundColor=[UIColor colorWithRed:250 green:247 blue:247 alpha:1];
    }
    else
        cell.backgroundColor=[UIColor colorWithRed:166 green:164 blue:164 alpha:1];
}

/* //refresh table with new data
-(void)refreshScheduleDataWithArray:(NSArray *)semesterData
{
    self.currentSemesterClassArray=semesterData;
    [self.tableView reloadData];
}
*/
@end
