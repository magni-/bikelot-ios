//
//  ViewController.h
//  bikelot
//
//  Created by Paul Padier on 5/10/13.
//  Copyright (c) 2013 hack4good. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <AFHTTPRequestOperationManager.h>
#import "BLAnnotation.h"

@interface ViewController : UIViewController <CLLocationManagerDelegate,MKMapViewDelegate>

@property (nonatomic, strong) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *dataLabel;
@property (weak, nonatomic) IBOutlet UIStepper *valueStepper;
- (IBAction)valueChanged:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *sendDataButton;
- (IBAction)sendData:(id)sender;

@end
