//
//  ModelStation.h
//  TutuTestApp
//
//  Created by Ekaterina Krasnova on 09/12/2016.
//  Copyright © 2016 Ekaterina Krasnova. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModelPoint.h"

@interface ModelStation : NSObject

@property (nonatomic, readwrite) NSString *countryTitle;
@property (nonatomic, readwrite) ModelPoint *point;
@property (nonatomic, readwrite) NSString *districtTitle;
@property (nonatomic, readwrite) NSString *cityTitle;
@property (nonatomic, readwrite) NSString *regionTitle;
@property (nonatomic, readwrite) NSString *stationTitle;

+ (ModelStation *)initWithStationTitle:(NSString *)stationTitle
                             cityTitle:(NSString *)cityTitle
                         districtTitle:(NSString *)districtTitle
                           regionTitle:(NSString *)regionTitle
                          countryTitle:(NSString *)countryTitle
                              andPoint:(ModelPoint *)point;

@end
