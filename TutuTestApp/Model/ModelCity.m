//
//  ModelCity.m
//  TutuTestApp
//
//  Created by Ekaterina Krasnova on 09/12/2016.
//  Copyright © 2016 Ekaterina Krasnova. All rights reserved.
//

#import "ModelCity.h"

@implementation ModelCity

+ (ModelCity *)initWithCityTitle:(NSString *)cityTitle districtTitle:(NSString *)districtTitle regionTitle:(NSString *)regionTitle countryTitle:(NSString *)countryTitle point:(ModelPoint *)point andStations:(NSArray<ModelStation *> *)stations {
    ModelCity *city = [[ModelCity alloc]init];
    city.cityTitle = cityTitle;
    city.districtTitle = districtTitle;
    city.regionTitle = regionTitle;
    city.countryTitle = countryTitle;
    city.point = point;
    city.stations = stations;

    return city;
}

@end
