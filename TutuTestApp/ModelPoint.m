//
//  ModelPoint.m
//  TutuTestApp
//
//  Created by Ekaterina Krasnova on 09/12/2016.
//  Copyright © 2016 Ekaterina Krasnova. All rights reserved.
//

#import "ModelPoint.h"

@implementation ModelPoint

+ (ModelPoint *)initWithLongitude:(double)longitude andLatitude:(double)latitude {
    ModelPoint *point = [[ModelPoint alloc]init];
    point.longitude = longitude;
    point.latitude = latitude;
    return point;
}

@end
