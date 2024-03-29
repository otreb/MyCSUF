//
//  MapViewController.h
//  MyCSUF
//
//  Created by Bert Aguilar on 10/11/11.
//  Copyright (c) 2011 Apple Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/Mapkit.h>
#import <MapKit/MKAnnotation.h>

#define METERS_PER_MILE 1609.344


@interface MapViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate> {
    MKMapView *_mapView;
    CLLocationManager *locationManager;
    
}
@property (retain, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) CLLocationManager *locationManager;

- (IBAction)zoomIn:(id)sender;
- (IBAction)changeMapType:(id)sender;

@end
