//
//  DetailsViewController.m
//  TutuTestApp
//
//  Created by Ekaterina Krasnova on 09/12/2016.
//  Copyright © 2016 Ekaterina Krasnova. All rights reserved.
//

#import "DetailsViewController.h"
@import MapKit;

@interface DetailsViewController () <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *stationTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *districtTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *regionTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *countryTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *stationLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *countryLabel;
@property (weak, nonatomic) IBOutlet UILabel *regionLabel;
@property (weak, nonatomic) IBOutlet UILabel *districtLabel;

@property(nonatomic)double stationLongitude;
@property(nonatomic)double stationLatitude;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setProperties];
    self.mapView.delegate = self;
    
    CLLocationCoordinate2D initialLocation = CLLocationCoordinate2DMake(self.stationLatitude, self.stationLongitude);
    [self centerMapOnLocation:initialLocation];
    
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc]init];
    annotation.coordinate = initialLocation;
    annotation.title = self.stationTitleLabel.text;
    [self.mapView addAnnotation:annotation];
}

- (void)setProperties {
    NSUserDefaults *data = [NSUserDefaults standardUserDefaults];
    self.stationTitleLabel.text = [data valueForKey:@"selectedStationTitle"];
    self.cityTitleLabel.text = [data valueForKey:@"selectedCityTitle"];
    self.districtTitleLabel.text = [data valueForKey:@"selectedDistrictTitle"];
    self.regionTitleLabel.text = [data valueForKey:@"selectedRegionTitle"];
    self.countryTitleLabel.text = [data valueForKey:@"selectedCountryTitle"];
    self.stationLongitude = [data doubleForKey:@"selectedLongitude"];
    self.stationLatitude = [data doubleForKey:@"selectedLatitude"];
}

#pragma mark - MapKit

CLLocationDistance regionRadius = 1000.0;
- (void)centerMapOnLocation:(CLLocationCoordinate2D)location {
    MKCoordinateRegion coordinateRegion = MKCoordinateRegionMakeWithDistance(location, regionRadius * 1.5, regionRadius * 1.5);
    [self.mapView setRegion:coordinateRegion animated:YES];
}

//- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
//    [self.mapView addAnnotation:<#(nonnull id<MKAnnotation>)#>]
//}

@end
