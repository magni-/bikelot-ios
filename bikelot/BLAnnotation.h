//
//  BLAnnotation.h
//  bikelot
//
//  Created by Paul Padier on 5/10/13.
//  Copyright (c) 2013 hack4good. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface BLAnnotation : NSObject <MKAnnotation> {
    CLLocationCoordinate2D coordinate;
    int spots;
}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
- (id)initWithLocation:(CLLocationCoordinate2D)coord;
- (UIImage*)chooseImage;
@property (nonatomic) int spots;

@end
