//
//  ModelPoint.h
//  TutuTestApp
//
//  Created by Ekaterina Krasnova on 09/12/2016.
//  Copyright © 2016 Ekaterina Krasnova. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelPoint : NSObject

@property (nonatomic, readwrite) double longitude;
@property (nonatomic, readwrite) double latitude;

+ (ModelPoint *)initWithLongitude:(double)longitude andLatitude:(double)latitude;

@end
