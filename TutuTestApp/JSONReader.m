//
//  JSONParser.m
//  TutuTestApp
//
//  Created by Ekaterina Krasnova on 09/12/2016.
//  Copyright © 2016 Ekaterina Krasnova. All rights reserved.
//

#import "JSONReader.h"
#import "ModelCity.h"
#import "ModelPoint.h"
#import "ModelStation.h"
#import "AppDelegate.h"

static NSString * const kCountryTitle = @"countryTitle";
static NSString * const kDistrictTitle = @"districtTitle";
static NSString * const kCityTitle = @"cityTitle";
static NSString * const kRegionTitle = @"regionTitle";
static NSString * const kPoint = @"point";
static NSString * const kLongitude = @"longitude";
static NSString * const kLatitude = @"latitude";
static NSString * const kStations = @"stations";
static NSString * const kStationTitle = @"stationTitle";

@interface JSONReader()

@property (nonatomic, strong, readwrite)NSDictionary *parcedJSONObject;

@end

@implementation JSONReader

+ (instancetype)sharedInstance {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[JSONReader alloc]init];
    });
    return sharedInstance;
}

- (void)readJSON {
    NSError *localError = nil;
    //Get JSON data from https://raw.githubusercontent.com/tutu-ru/hire_ios-test/master/allStations.json, but if there is no Internet connection - from file "allStations.json" in project
    //Get json data from url
    NSString *urlString = [NSString stringWithFormat:@"https://raw.githubusercontent.com/tutu-ru/hire_ios-test/master/allStations.json"];
    NSData *jsonData = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
    if (jsonData == NULL) {
        //Get json data from file in project
        NSString *path  = [[NSBundle mainBundle] pathForResource:@"allStations" ofType:@"json"];
        NSString *jsonString = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    }
    self.parcedJSONObject = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&localError];

}

- (NSArray<ModelCity *> *)citiesFromJSON:(NSString *)direction {
    if (self.parcedJSONObject == nil) {
        [self readJSON];
    }
    NSMutableArray<ModelCity *> *cities = [NSMutableArray new];
    NSArray *results = [NSMutableArray new];
    results = self.parcedJSONObject[direction];
    for (NSDictionary *tempCity in results) {
        
        //parse titles
        NSString *countryTitle = tempCity[kCountryTitle];
        NSString *districtTitle = tempCity[kDistrictTitle];
        NSString *cityTitle = tempCity[kCityTitle];
        NSString *regionTitle = tempCity[kRegionTitle];
        
        //parse and init point
        ModelPoint *point;
        NSDictionary *tempPoint = tempCity[kPoint];
        if (tempPoint != nil) {
            double longitude = [tempPoint[kLongitude] doubleValue];
            double latitude = [tempPoint[kLatitude] doubleValue];
            point = [ModelPoint initWithLongitude:longitude andLatitude:latitude];
        }
        
        //pars and init stations
        NSMutableArray<ModelStation *> *stations = [NSMutableArray new];
        NSDictionary *tempStations = tempCity[kStations];
        for (NSDictionary *tempStation in tempStations) {

            //parse station titles
            NSString *countryTitle = tempStation[kCountryTitle];
            NSString *districtTitle = tempStation[kDistrictTitle];
            NSString *cityTitle = tempStation[kCityTitle];
            NSString *regionTitle = tempStation[kRegionTitle];
            NSString *stationTitle = tempStation[kStationTitle];

            //parse and init point
            ModelPoint *point;
            tempPoint = tempStation[kPoint];
            if (tempPoint != nil) {
                double longitude = [tempPoint[kLongitude] doubleValue];
                double latitude = [tempPoint[kLatitude] doubleValue];
                point = [ModelPoint initWithLongitude:longitude andLatitude:latitude];
            }
            ModelStation *station = [ModelStation initWithStationTitle:stationTitle cityTitle:cityTitle districtTitle:districtTitle regionTitle:regionTitle countryTitle:countryTitle andPoint:point];
            [stations addObject:station];
        }
        ModelCity *city = [ModelCity initWithCityTitle:cityTitle districtTitle:districtTitle regionTitle:regionTitle countryTitle:countryTitle point:point andStations:stations];
        [cities addObject:city];
    }
    return cities;
}

@end
