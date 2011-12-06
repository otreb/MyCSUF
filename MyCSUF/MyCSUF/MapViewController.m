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
    // start off by default middle of Fresno State
    MKCoordinateRegion newRegion;
    newRegion.center.latitude = 36.812946;
    newRegion.center.longitude = -119.746953;
    newRegion.span.latitudeDelta = 0.012872;
    newRegion.span.longitudeDelta = 0.009863;
    
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
- (IBAction)zoomIn:(id)sender
{
    [self gotoLocation];
    MKUserLocation *userLocation = mapView.userLocation;
    MKCoordinateRegion region = 
    MKCoordinateRegionMakeWithDistance(userLocation.location.coordinate, 50, 50);
    [mapView setRegion:region animated:YES];
}

- (IBAction)changeMapType:(id)sender
{
    [self gotoLocation];
    if(mapView.mapType == MKMapTypeStandard)
        mapView.mapType = MKMapTypeHybrid;
    else
        mapView.mapType = MKMapTypeStandard;
}

- (void) backButton: (id)sender
{
    ClassScheduleViewController *classScheduleViewController = [[ClassScheduleViewController alloc] initWithNibName:@"ClassScheduleViewController" bundle:nil];
    // ...
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:classScheduleViewController animated:YES];
    [ClassScheduleViewController release];
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
