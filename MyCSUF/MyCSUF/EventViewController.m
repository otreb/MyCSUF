//
//  EventViewController.m
//  MyCSUF
//
//  Created by Ismael Martinez on 11/16/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "EventViewController.h"

@implementation EventViewController

@synthesize whenLabel, whereLabel, eventTypeLabel, organizationLabel, expectedLabel, registeredLabel, eventStateLabel, moreInfo;
@synthesize noteView;
@synthesize web;

- initWithURL:(NSString *)sender
{
    if ((self = [super init])) {
        URL = [[NSURL alloc] initWithString:sender];
    }
    return self;
}

- (void)separateData:(NSArray *)data
{
//    int count = 0;
//    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
//    for (NSString *tempString in data)
//    {
//        if (count == 11) {
//            NSMutableString *cutString = [[NSMutableString alloc] initWithString:[tempString substringFromIndex:20]];
//            [cutString replaceOccurrencesOfString:@"&nbsp;" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [cutString length])];
//            [cutString replaceOccurrencesOfString:@"&ndash;" withString:@"-" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [cutString length])];
//            [cutString replaceOccurrencesOfString:@"</p><p" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [cutString length])];
//            [tempArray addObject:cutString];
//            [cutString release];
//        }
//        else if (count == 12)
//        {
//            NSMutableString *cutString = [[NSMutableString alloc] initWithString:[tempString substringFromIndex:20]];
//            [cutString replaceOccurrencesOfString:@"&nbsp;" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [cutString length])];
//            [cutString replaceOccurrencesOfString:@"&ndash;" withString:@"-" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [cutString length])];
//            [cutString replaceOccurrencesOfString:@"</p></td></tr><tr><td" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [cutString length])];
//            [tempArray addObject:cutString];
//            [cutString release];
//        }
//        else if (count !=1) {
//            NSMutableString *cutString = [[NSMutableString alloc] initWithString:[tempString substringFromIndex:20]];
//            [cutString replaceOccurrencesOfString:@"&nbsp;" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [cutString length])];
//            [cutString replaceOccurrencesOfString:@"&ndash;" withString:@"-" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [cutString length])];
//            [cutString replaceOccurrencesOfString:@"</td></tr><tr><td" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [cutString length])];
//            [tempArray addObject:cutString];
//            [cutString release];
//        }
//        else
//        {
//            NSMutableString *cutString = [[NSMutableString alloc] initWithString:[tempString substringFromIndex:20]];
//            [cutString replaceOccurrencesOfString:@"twEventDetailData\">" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [cutString length])];
//            [cutString replaceOccurrencesOfString:@"&nbsp;" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [cutString length])];
//            [cutString replaceOccurrencesOfString:@"&ndash;" withString:@"-" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [cutString length])];
//            [cutString replaceOccurrencesOfString:@"</td></tr><tr" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [cutString length])];
//            [tempArray addObject:cutString];
//            [cutString release];
//        }
//        count++;
//    }
//    self.whenLabel.text = [tempArray objectAtIndex:0];
//    self.whereLabel.text = [tempArray objectAtIndex:1];
//    self.eventTypeLabel.text = [tempArray objectAtIndex:2];
//    self.organizationLabel.text = [tempArray objectAtIndex:4];
//    self.expectedLabel.text = [tempArray objectAtIndex:7];
//    self.registeredLabel.text = [tempArray objectAtIndex:8];
//    self.eventStateLabel.text = [tempArray objectAtIndex:10];
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
    NSURLRequest *requet = [[NSURLRequest alloc] initWithURL:URL];
    [self.web loadRequest:requet];
    [self.web setContentStretch:CGRectMake(300, 300, 320, 400)];
//    [[NSURLConnection alloc] initWithRequest:requet delegate:self startImmediately:YES];
    [requet release];
    // Do any additional setup after loading the view from its nib.
}

- (void)releaseOutlets
{
    self.whenLabel = nil;
    self.whereLabel = nil;
    self.eventTypeLabel = nil;
    self.organizationLabel = nil;
    self.expectedLabel = nil;
    self.registeredLabel = nil;
    self.eventStateLabel = nil;
    self.noteView = nil;
    self.moreInfo = nil;
    self.web =nil;
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

#pragma mark - Connection Delegate
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
    NSString *HTMLCode=[[NSString alloc] initWithBytes:[tempData bytes] length:[tempData length] encoding:NSUTF8StringEncoding];
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    for (NSString *html in [HTMLCode componentsSeparatedByString:@"class=\\\""])
    {
        if ([html hasPrefix:@"twEventDetailData"]) {
            [tempArray addObject:html];
        }
    }
    [HTMLCode release];
    [self separateData:tempArray];
    [tempArray release];
}

@end
