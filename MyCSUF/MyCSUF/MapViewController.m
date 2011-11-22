//
//  MapViewController.m
//  MyCSUF
//
//  Created by Bert Aguilar on 10/11/11.
//  Copyright (c) 2011 Apple Inc. All rights reserved.
//

#import "MapViewController.h"
#import "ClassScheduleViewController.h"

@implementation MapViewController
@synthesize mapView;
@synthesize locationManager;

- (void)gotoLocation
{
    // start off by default in San Francisco
    MKCoordinateRegion newRegion;
    newRegion.center.latitude = 36.81337;
    newRegion.center.longitude = -119.74527;
    newRegion.span.latitudeDelta = 0.112872;
    newRegion.span.longitudeDelta = 0.109863;
    
    [self.mapView setRegion:newRegion animated:YES];
}

/*
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"New latitude: %f", newLocation.coordinate.latitude);
    NSLog(@"New longitude: %f", newLocation.coordinate.longitude);
}
*/

// Button Actions

// Moves to the users current location on the map
- (void) zoomIn: (id)sender
{
    MKUserLocation *userLocation = mapView.userLocation;
    MKCoordinateRegion region = 
    MKCoordinateRegionMakeWithDistance(userLocation.location.coordinate, 50, 50);
    [mapView setRegion:region animated:YES];
}

- (void) changeMapType: (id)sender
{
    if(mapView.mapType == MKMapTypeStandard)
        mapView.mapType = MKMapTypeHybrid;
    else
        mapView.mapType = MKMapTypeStandard;
}

- (void) backButton
{
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    self.mapView.centerCoordinate = userLocation.location.coordinate;
}


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
    
    _mapView.showsUserLocation = YES;
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithtitle: @"Back"
                                   style:UIBarButtonItemStylePlain
                                   target: self
                                   action: @selector(backButton:)];
    
    
    UIBarButtonItem *zoomButton = [[UIBarButtonItem alloc] 
                                   initWithTitle: @"Zoom"
                                   style:UIBarButtonItemStylePlain
                                   target: self
                                   action:@selector(zoomIn:)];
    
    self.navigationItem.rightBarButtonItem = zoomButton;
    [zoomButton release];
    
    UIBarButtonItem *typeButton = [[UIBarButtonItem alloc]
                                   initWithTitle: @"Type"
                                   style:UIBarButtonItemStylePlain
                                   target: self
                                   action:@selector(changeMapType:)];
    
    self.navigationItem.leftBarButtonItem = typeButton;
    [typeButton release];
    
// centers view on users location    
//    mapView.delegate = self;

/*
    self.locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
*/
 
    CLLocationCoordinate2D annotationCoord;
    
    annotationCoord.latitude = 36.81337;
    annotationCoord.longitude = -119.74527;
    
    MKPointAnnotation *annotationPoint = [[MKPointAnnotation alloc] init];
    annotationPoint.coordinate = annotationCoord;
    annotationPoint.title = @"Satellite Student Union";
    annotationPoint.subtitle = @"Fresno State Campus";
    [mapView addAnnotation:annotationPoint]; 
  
    // Do any additional setup after loading the view from its nib.
    
    [self gotoLocation];
}

- (void)viewDidUnload
{
//    [self setMapView:nil];
    [self setMapView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
//    [mapView release];
    [mapView release];
    [super dealloc];
}
@end
