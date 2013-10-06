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
@synthesize spots;

- (id)initWithLocation:(CLLocationCoordinate2D)coord
{
    self = [super init];
    if (self)
    {
        coordinate = coord;
    }
    return self;
}

- (UIImage*)chooseImage
{
    UIImage* image;
    switch (spots) {
        case 1:
            image = [UIImage imageNamed:@"1.png"];
            break;
        case 2:
            image = [UIImage imageNamed:@"2.png"];
            break;
        case 3:
            image = [UIImage imageNamed:@"3p.png"];
            break;
            
        default:
            image = [UIImage imageNamed:@"0.png"];
            break;
    }
    return image;
}

@end
