//
//  ViewController.m
//  bikelot
//
//  Created by Paul Padier on 5/10/13.
//  Copyright (c) 2013 hack4good. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController {
    CLLocationManager *locationManager;
    CLLocation *location;
    CLLocationCoordinate2D neCoord;
    CLLocationCoordinate2D swCoord;
    NSString *host;
}

- (void)updateLabel {
    switch ((int)_valueStepper.value) {
        case -1:
            _dataLabel.text = @"No bike lot here";
            break;
        case 0:
            _dataLabel.text = @"No spots available";
            break;
        case 1:
            _dataLabel.text = @"1 spot available";
            break;
        case 2:
            _dataLabel.text = @"2 spots available";
            break;
        case 3:
            _dataLabel.text = @"3+ spots available";
            break;
            
        default:
            break;
    }
}

- (void)displayLocations
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"min_lat": [NSString stringWithFormat:@"%f", swCoord.latitude], @"min_long": [NSString stringWithFormat:@"%f", swCoord.longitude], @"max_lat": [NSString stringWithFormat:@"%f", neCoord.latitude], @"max_long": [NSString stringWithFormat:@"%f", neCoord.longitude]};
    [manager GET:[NSString stringWithFormat:@"http://%@/locations", host] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        for (id loc in responseObject)
        {
            BLAnnotation *annotationPoint = [[BLAnnotation alloc] initWithLocation:CLLocationCoordinate2DMake([[loc objectForKey:@"latitude"] floatValue], [[loc objectForKey:@"longitude"] floatValue])];
            annotationPoint.spots = [[loc objectForKey:@"spots"] intValue];
            [annotationPoint chooseImage];
            
            [_mapView addAnnotation:annotationPoint];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id)annotation{
    if ([annotation isKindOfClass:[BLAnnotation class]])
    {
        NSString *annotationIdentifier=[NSString stringWithFormat:@"annotationIdentifier%d", [(BLAnnotation*) annotation spots]];
        MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:annotationIdentifier];
        if (!annotationView)
        {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationIdentifier];
            annotationView.image = [annotation chooseImage];
        }
        return annotationView;
    }
    return nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    host = @"localhost:3000"; // bikelot.herokuapp.com
    [self updateLabel];
    locationManager = [[CLLocationManager alloc] init];
    _mapView.delegate = self;
    
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [locationManager startUpdatingLocation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 250, 250);
    [mapView setRegion:[mapView regionThatFits:region] animated: YES];
}

- (void)mapViewWillStartRenderingMap:(MKMapView *)mapView
{
    // http://stackoverflow.com/a/2082247/1612744
    // To calculate the search bounds...
    // First we need to calculate the corners of the map so we get the points
    CGPoint nePoint = CGPointMake(_mapView.bounds.origin.x + _mapView.bounds.size.width, _mapView.bounds.origin.y);
    CGPoint swPoint = CGPointMake(_mapView.bounds.origin.x, _mapView.bounds.origin.y + _mapView.bounds.size.height);
    
    // Then transform those point into lat,lng values
    neCoord = [mapView convertPoint:nePoint toCoordinateFromView:mapView];
    swCoord = [mapView convertPoint:swPoint toCoordinateFromView:mapView];
    
    NSLog(@"min (%f, %f)\nmax (%f, %f)", swCoord.latitude, swCoord.longitude, neCoord.latitude, neCoord.longitude);

    [self displayLocations];
}

- (IBAction)valueChanged:(id)sender
{
    _sendDataButton.enabled = true;
    [self updateLabel];
}

- (IBAction)sendData:(id)sender {
    _sendDataButton.enabled = false;

    AFHTTPRequestOperationManager *ROManager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"location[latitude]": [NSString stringWithFormat:@"%f", location.coordinate.latitude], @"location[longitude]": [NSString stringWithFormat:@"%f", location.coordinate.longitude], @"location[spots]": [NSString stringWithFormat:@"%f", _valueStepper.value]};
    [ROManager POST:[NSString stringWithFormat:@"http://%@/locations", host] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

#pragma mark CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    _sendDataButton.enabled = false;
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    if (location.coordinate.latitude != [[locations lastObject] coordinate].latitude && location.coordinate.longitude != [[locations lastObject] coordinate].longitude)
    {
        _sendDataButton.enabled = true;
        location = [locations lastObject];
    }
}

@end
