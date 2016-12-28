//
//  ModelCities.m
//  TutuTestApp
//
//  Created by Ekaterina Krasnova on 09/12/2016.
//  Copyright © 2016 Ekaterina Krasnova. All rights reserved.
//

#import "ModelCities.h"

@implementation ModelCities

+ (instancetype)sharedInstance {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ModelCities alloc]init];
    });
    return sharedInstance;
}

- (void)loadCitiesFrom {
    self.citiesFrom = [[JSONReader sharedInstance] citiesFromJSON:@"citiesFrom"];
}

- (void)loadCitiesTo{
    self.citiesTo = [[JSONReader sharedInstance] citiesFromJSON:@"citiesTo"];
}

@end
