//
//  LoginViewController.m
//  MyCSUF
//
//  Created by Nick on 10/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#define UserURL @"https://cmsweb.csufresno.edu/psc/HFRRPT/EMPLOYEE/HRMS/q/?ICAction=ICQryNameURL=PUBLIC.FR_SR_CLASS_SCHED_MOBILE"
@implementation ViewController

@synthesize usernameField;
@synthesize passwordField;
@synthesize loginIndicator;
@synthesize delegate;
//@synthesize table;
//@synthesize receivedData;
//@synthesize term, termName, classNumber, classDescriptionA, scheduleNumber, section, component, instructor, meetingDays, time, room, start_end;

/*
 - (IBAction) login: (id) sender
 NSURL *url = [NSURL URLWithString:@"https://my.csufresno.edu/psp/mfs/?cmd=login&languageCd=ENG"];
 ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
 [request setUsername:@"usernameField"];
 [request setPassword:@"passwordField"];
 [request setUseSessionPersistence:YES]; //Shouldn't be needed as this is the default
 
 //Should reuse our username and password
 request = [ASIHTTPRequest requestWithURL:url];
 */

/*
 - (void)requestFinished:(ASIHTTPRequest *)request
 {
 // Use when fetching text data
 NSString *responseString = [request responseString];
 
 // Use when fetching binary data
 NSData *responseData = [request responseData];
 }
 
 - (void)requestFailed:(ASIHTTPRequest *)request
 {
 NSError *error = [request error];
 }
 */

/*
 - (IBAction)grabURLInBackground:(id)sender:(id)sender
 {
 }
 */
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //    self.usernameField.frame = CGRectMake(111, 20, 90, 31);
    //    self.passwordField.frame = CGRectMake(111, 50, 90, 31);
    //    self.loginButton.frame = CGRectMake(111, 60, 50, 50);
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
    return YES;
}

- (IBAction) login: (id) sender
{
   // NSURL *url = [NSURL URLWithString:@"https://my.csufresno.edu/psp/mfs/?cmd=login&languageCd=ENG"];
    
    //Data URL : https://cmsweb.csufresno.edu/psc/HFRRPT/EMPLOYEE/HRMS/q/?ICAction=ICQryNameURL=PUBLIC.FR_SR_CLASS_SCHED_MOBILE
    //NSConnection *request = 
    NSHTTPCookieStorage *cookieStorage=[NSHTTPCookieStorage sharedHTTPCookieStorage];
    //get the cookies
    NSArray *cookies=[cookieStorage cookies];
    
    //iterate through them, and remove them
    for(int i=0; i<[cookies count]; i++)
    {
        NSHTTPCookie *currentCookie=[cookies objectAtIndex:i];
        [cookieStorage deleteCookie:currentCookie];
    }

    
    NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:
                                     [NSURL URLWithString:@"https://my.csufresno.edu/psp/mfs/?cmd=login&languageCd=ENG"]
                                                            cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                        timeoutInterval:60.0];
	[theRequest setHTTPMethod:@"POST"];
	
	//create the post data for the request
	NSString *post =[NSString stringWithFormat:@"userid=%@&pwd=%@&timezoneOffset=-8",usernameField.text, passwordField.text];
	NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
	NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
	

	[theRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
	[theRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	[theRequest setHTTPBody:postData];	
//    [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    loginIndicator.hidden = FALSE;
    [loginIndicator startAnimating];
    NSURLConnection *theConnection=[[[NSURLConnection alloc] initWithRequest:theRequest delegate:self] autorelease];
	if(theConnection){
		//Create the NSMutableData to hold the received data
		//received data is an instance variable declared elsewhere
		//self.receivedData=[NSMutableData alloc];
	}
	
    
    //load user data from csuf
    
}
- (void)requestFailed:(NSMutableURLRequest *)request {
    NSLog(@"Request failed: %@",[request error]);
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
    

- (void)releaseOutlets
{
    //self.table = nil;
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


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
        NSLog(@"Succeeded! Received %d bytes of data",[receivedData length]);
    NSHTTPCookieStorage *cookieStorage=[NSHTTPCookieStorage sharedHTTPCookieStorage];
    //get the cookies
    NSArray *cookies=[cookieStorage cookies];
    //iterate over them, and see if you're authorized.
    bool authorized=false;
    NSHTTPCookie *currentCookie;
    for(int i=0; i<[cookies count]; i++)
    {
        currentCookie=[cookies objectAtIndex:i];
        NSLog(@"Currently analyzing cookie named %@", [currentCookie name]);
        if ([[currentCookie name] isEqualToString:[NSString stringWithFormat:@"csuf_auth"]]) {
            NSLog(@"Authenticated!");
            authorized=true;
        }
    }
    
//    [connection release];
   // self.receivedData=nil;
    
    if(authorized){
        NSLog(@"Authorized");
        [self.delegate authentication:authorized];
    }
    
}




@end
