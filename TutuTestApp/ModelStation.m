//
//  ModelStation.m
//  TutuTestApp
//
//  Created by Ekaterina Krasnova on 09/12/2016.
//  Copyright © 2016 Ekaterina Krasnova. All rights reserved.
//

#import "ModelStation.h"

@implementation ModelStation

+ (ModelStation *)initWithStationTitle:(NSString *)stationTitle cityTitle:(NSString *)cityTitle districtTitle:(NSString *)districtTitle regionTitle:(NSString *)regionTitle countryTitle:(NSString *)countryTitle andPoint:(ModelPoint *)point {
    
    ModelStation *station = [[ModelStation alloc]init];
    station.stationTitle = stationTitle;
    station.cityTitle = cityTitle;
    station.districtTitle = districtTitle;
    station.regionTitle = regionTitle;
    station.countryTitle = countryTitle;
    station.point = point;
    
    return station;
}

@end
