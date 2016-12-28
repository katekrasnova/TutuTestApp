//
//  ModelCities.h
//  TutuTestApp
//
//  Created by Ekaterina Krasnova on 09/12/2016.
//  Copyright © 2016 Ekaterina Krasnova. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModelCity.h"
#import "JSONReader.h"

@interface ModelCities : NSObject

@property (nonatomic, readwrite) NSArray<ModelCity *> *citiesFrom;
@property (nonatomic, readwrite) NSArray<ModelCity *> *citiesTo;

+ (instancetype)sharedInstance;
- (void)loadCitiesFrom;
- (void)loadCitiesTo;

@end
