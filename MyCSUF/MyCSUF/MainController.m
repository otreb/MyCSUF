//
//  MainController.m
//  Test
//
//  Created by Nicky on 12/7/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MainController.h"
#import "ViewController.h"

@implementation MainController

@synthesize table;
@synthesize receivedData;
//@synthesize dicarray;

// Will dismiss the modal the controller is currently in.
- (void)closeView
{
    [self dismissModalViewControllerAnimated:YES];
}

// Creates the Category once you are finished inputing your information.
- (void)donePressed
{
    
    [self closeView];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) authentication: (BOOL) authenticated{

        self.receivedData=[NSMutableData alloc];
    
    
    
    NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:
                                     [NSURL URLWithString:@"https://cmsweb.csufresno.edu/psc/HFRRPT/EMPLOYEE/HRMS/q/?ICAction=ICQryNameURL=PUBLIC.FR_SR_CLASS_SCHED_MOBILE&&"]
                                                            cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                        timeoutInterval:60.0];
    NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    if(theConnection){
        //Create the NSMutableData to hold the received data
        //received data is an instance variable declared elsewhere
        self.receivedData=[NSMutableData alloc];
    }




NSString *HTMLCode=[[NSString alloc] initWithBytes:[tempData bytes] length:[tempData length] encoding:NSUTF8StringEncoding];
//    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:tempData];
//    parser.delegate = self;
NSMutableArray *parsedData = [[NSMutableArray alloc] initWithArray:[HTMLCode componentsSeparatedByString:@"<item>"]];
if ([parsedData count]>0)
[parsedData removeObjectAtIndex:0];

//    [parser setShouldProcessNamespaces:YES];
//    [parser parse];
[HTMLCode release];
[self.table reloadData];

    
}

- (IBAction)login:(id)sender{
    ViewController *viewController = [[ViewController alloc] init];
    viewController.delegate = self;
    [self presentModalViewController:viewController animated:YES];
    [viewController release];
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
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]
                                               initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                               target:self
                                               action:@selector(donePressed)] autorelease];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void) receivedString:(NSString *) theString
{
    NSError *RegExError;
	NSArray *matchesArray;
    //NSMutableArray *schoolClassArray=[[NSMutableArray array] init];
    //NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    //copy the string into a mutable array
	NSMutableString *textToExtract=[NSMutableString
									stringWithString: theString];
	//define the RegEx
	NSRegularExpression *extractionRegEx=[NSRegularExpression
										  regularExpressionWithPattern:@"<td class='PSQRYRESULT.*>(.*?)</td>"//@"<td class='PSQRY.*>(.*?)</td>"//<[^>.]*>
										  options:0
										  error:&RegExError];
    
    //Make sure the reg ex exists
    if (extractionRegEx!=nil) {
        matchesArray=[[extractionRegEx 
                       matchesInString:textToExtract
                       options:0
                       range:NSMakeRange(0, [textToExtract length])] retain]; 
		
		//Now take the matches, generate strings and place in classes.
        NSMutableArray *dicarray = [[NSMutableArray alloc] init];
        NSLog(@"Matches Array count:%i", [matchesArray count]);
        for (int i=0; i<([matchesArray count]/13); i++) {
            NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
            [dictionary setValue:[textToExtract substringWithRange:[[matchesArray objectAtIndex:i*13+1] rangeAtIndex:1]] forKey:@"Term"];
            [dictionary setValue:[textToExtract substringWithRange:[[matchesArray objectAtIndex:i*13+2] rangeAtIndex:1]] forKey:@"TermName"];
            [dictionary setValue:[textToExtract substringWithRange:[[matchesArray objectAtIndex:i*13+3] rangeAtIndex:1]] forKey:@"ClassNumber"];
            [dictionary setValue:[textToExtract substringWithRange:[[matchesArray objectAtIndex:i*13+4] rangeAtIndex:1]] forKey:@"ClassDescription"];
            [dictionary setValue:[textToExtract substringWithRange:[[matchesArray objectAtIndex:i*13+5] rangeAtIndex:1]] forKey:@"ScheduleNumber"];
            [dictionary setValue:[textToExtract substringWithRange:[[matchesArray objectAtIndex:i*13+6] rangeAtIndex:1]] forKey:@"Section"];
            [dictionary setValue:[textToExtract substringWithRange:[[matchesArray objectAtIndex:i*13+7] rangeAtIndex:1]] forKey:@"Component"];
            [dictionary setValue:[textToExtract substringWithRange:[[matchesArray objectAtIndex:i*13+8] rangeAtIndex:1]] forKey:@"Instructor"];
            [dictionary setValue:[textToExtract substringWithRange:[[matchesArray objectAtIndex:i*13+9] rangeAtIndex:1]] forKey:@"MeetingDays"];
            [dictionary setValue:[textToExtract substringWithRange:[[matchesArray objectAtIndex:i*13+10] rangeAtIndex:1]] forKey:@"Time"];
            [dictionary setValue:[textToExtract substringWithRange:[[matchesArray objectAtIndex:i*13+11] rangeAtIndex:1]] forKey:@"Room"];
            [dictionary setValue:[textToExtract substringWithRange:[[matchesArray objectAtIndex:i*13+12] rangeAtIndex:1]] forKey:@"Start_End"];
            [dicarray addObject:dictionary];
            [dictionary release];
        }

        NSTimer *theTimer=[NSTimer timerWithTimeInterval:3.0 target:self selector:@selector(timerFired:) userInfo:nil repeats:NO];
        [[NSRunLoop currentRunLoop] addTimer:theTimer forMode:[[NSRunLoop currentRunLoop] currentMode]];
        
        NSLog(@"Schedule succesfully downloaded!");

    }
    [matchesArray release];
//    [self.ScheduleDelegate dictionaryschedule:dicarray];
}

-(void) connection:(NSURLConnection *) connection didReceiveResponse:(NSURLResponse *) response
{
    // This method is called when the server has determined that it
    // has enough information to create the NSURLResponse.
    
    // It can be called multiple times, for example in the case of a
    // redirect, so each time we reset the data.
    
    // receivedData is an instance variable declared elsewhere.
    NSLog(@"Connection did receive response!");
    [receivedData setLength:0];
}
- (void)requestFailed:(NSMutableURLRequest *)request {
    NSLog(@"Request failed: %@",[request error]);
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"Succeeded! Received %d bytes of data",[receivedData length]);
       //    [connection release];
     //self.receivedData=nil;
    NSLog(@"%@",[[NSString alloc] initWithBytes:[receivedData bytes] length:[receivedData length] encoding:NSUTF8StringEncoding]);
    [self receivedString:[[NSString alloc] initWithBytes:[receivedData bytes] length:[receivedData length] encoding:NSUTF8StringEncoding]];
        
    
}


-(void) connection:(NSURLConnection *) connection didReceiveData:(NSData *) data
{
    // Append the new data to receivedData.
    // receivedData is an instance variable declared elsewhere.
    NSLog(@"Connection didReceiveData!");
    [receivedData appendData:data];
}

-(void) connection:(NSURLConnection *) connection didFailWithError: (NSError *) error
{
    NSLog(@"Connection didFailWithError!");
    //There was an error, so release the connection and it's data.
    NSLog(@"There was an error while authorizing your request");
    [connection release];
    [receivedData release];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
