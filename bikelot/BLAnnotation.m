//
//  BLAnnotation.m
//  bikelot
//
//  Created by Paul Padier on 5/10/13.
//  Copyright (c) 2013 hack4good. All rights reserved.
//

#import "BLAnnotation.h"

@implementation BLAnnotation
@synthesize coordinate;

- (id)initWithLocation:(CLLocationCoordinate2D)coord
{
    self = [super init];
    if (self)
    {
        coordinate = coord;
    }
    return self;
}

@end
