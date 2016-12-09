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
    NSString* path  = [[NSBundle mainBundle] pathForResource:@"allStations" ofType:@"json"];
    NSString* jsonString = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSData* jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
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
        NSString *countryTitle = tempCity[@"countryTitle"];
        NSString *districtTitle = tempCity[@"districtTitle"];
        NSString *cityTitle = tempCity[@"cityTitle"];
        NSString *regionTitle = tempCity[@"regionTitle"];
        
        //parse and init point
        ModelPoint *point;
        NSDictionary *tempPoint = tempCity[@"point"];
        if (tempPoint != nil) {
            double longitude = [tempPoint[@"longitude"] doubleValue];
            double latitude = [tempPoint[@"latitude"] doubleValue];
            point = [ModelPoint initWithLongitude:longitude andLatitude:latitude];
        }
        
        //pars and init stations
        NSMutableArray<ModelStation *> *stations = [NSMutableArray new];
        NSDictionary *tempStations = tempCity[@"stations"];
        for (NSDictionary *tempStation in tempStations) {

            //parse station titles
            NSString *countryTitle = tempStation[@"countryTitle"];
            NSString *districtTitle = tempStation[@"districtTitle"];
            NSString *cityTitle = tempStation[@"cityTitle"];
            NSString *regionTitle = tempStation[@"regionTitle"];
            NSString *stationTitle = tempStation[@"stationTitle"];

            //parse and init point
            ModelPoint *point;
            tempPoint = tempStation[@"point"];
            if (tempPoint != nil) {
                double longitude = [tempPoint[@"longitude"] doubleValue];
                double latitude = [tempPoint[@"latitude"] doubleValue];
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
