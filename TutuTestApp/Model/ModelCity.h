//
//  ModelCity.h
//  TutuTestApp
//
//  Created by Ekaterina Krasnova on 09/12/2016.
//  Copyright © 2016 Ekaterina Krasnova. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModelPoint.h"
#import "ModelStation.h"

@interface ModelCity : NSObject

@property (nonatomic, readwrite) NSString *countryTitle;
@property (nonatomic, readwrite) ModelPoint *point;
@property (nonatomic, readwrite) NSString *districtTitle;
@property (nonatomic, readwrite) NSString *cityTitle;
@property (nonatomic, readwrite) NSString *regionTitle;
@property (nonatomic, readwrite) NSArray<ModelStation *> *stations;

+ (ModelCity *)initWithCityTitle:(NSString *)cityTitle
                   districtTitle:(NSString *)districtTitle
                     regionTitle:(NSString *)regionTitle
                    countryTitle:(NSString *)countryTitle
                           point:(ModelPoint *)point
                     andStations:(NSArray<ModelStation *> *)stations;

@end
