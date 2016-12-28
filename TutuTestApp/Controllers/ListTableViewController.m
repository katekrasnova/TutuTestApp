//
//  ListTableViewController.m
//  TutuTestApp
//
//  Created by Ekaterina Krasnova on 09/12/2016.
//  Copyright © 2016 Ekaterina Krasnova. All rights reserved.
//

#import "ListTableViewController.h"
#import "ModelCities.h"
#import "StationsListTableViewCell.h"
#import "DetailsViewController.h"
#import "Constants.h"

@interface ListTableViewController () <UISearchResultsUpdating>

@property (nonatomic)BOOL isFromDirection;
@property (strong, nonatomic) NSArray<ModelCity *> *cities;
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) NSArray<ModelCity *> *searchResults;

@end

@implementation ListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Set array of sities
    self.cities = [NSArray new];
    self.isFromDirection = [[NSUserDefaults standardUserDefaults]boolForKey:kIsFromDirection];
    if (self.isFromDirection) {
        self.cities = [ModelCities sharedInstance].citiesFrom;
        self.navigationItem.title = [NSString stringWithFormat:@"Откуда"];
    } else {
        self.cities = [ModelCities sharedInstance].citiesTo;
        self.navigationItem.title = [NSString stringWithFormat:@"Куда"];
    }
    
    //Init search controller
    self.searchController = [[UISearchController alloc]initWithSearchResultsController:nil];
    [self.searchController setSearchResultsUpdater:self];
    [self.searchController setDimsBackgroundDuringPresentation:NO];
    self.definesPresentationContext = YES;
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
}

#pragma mark - IBActions
- (IBAction)cancelTapped:(id)sender {
    [self performSegueWithIdentifier:@"unwindToSchedule" sender:self];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.searchController.isActive && ![self.searchController.searchBar.text isEqualToString:[NSString stringWithFormat:@""]]) {
        return self.searchResults.count;
    }
    return self.cities.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.searchController.isActive && ![self.searchController.searchBar.text isEqualToString:[NSString stringWithFormat:@""]]) {
        return self.searchResults[section].stations.count;
    }
    return self.cities[section].stations.count;
}


- (StationsListTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StationsListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StationCell" forIndexPath:indexPath];
    if (self.searchController.isActive && ![self.searchController.searchBar.text isEqualToString:[NSString stringWithFormat:@""]]) {
        cell.stationLabel.text = self.searchResults[indexPath.section].stations[indexPath.row].stationTitle;
    } else {
        cell.stationLabel.text = self.cities[indexPath.section].stations[indexPath.row].stationTitle;
    }
    cell.stationLabel.textColor = [UIColor blackColor];
    cell.stationLabel.font = [UIFont systemFontOfSize:17];
    cell.stationLabel.numberOfLines = 0;
    [self makeDetailDisclosureButtonForCell:cell];
    return cell;
}

- (UIButton *) makeDetailDisclosureButtonForCell:(StationsListTableViewCell *)cell {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"arrow.png"] forState:UIControlStateNormal];
    [button setFrame:CGRectMake(cell.frame.origin.x + self.view.frame.size.width - 47, 2, 40, 40)];
    [button addTarget: self
               action: @selector(accessoryButtonTapped:withEvent:)
     forControlEvents: UIControlEventTouchUpInside];
    [cell addSubview:button];
    
    return ( button );
}

- (void) accessoryButtonTapped: (UIControl *) button withEvent: (UIEvent *) event {
    NSIndexPath * indexPath = [self.tableView indexPathForRowAtPoint: [[[event touchesForView: button] anyObject] locationInView: self.tableView]];
    if ( indexPath == nil )
        return;
    
    [self.tableView.delegate tableView: self.tableView accessoryButtonTappedForRowWithIndexPath: indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 34;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1.0];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, 0, 0)];
    if (self.searchController.isActive && ![self.searchController.searchBar.text isEqualToString:[NSString stringWithFormat:@""]]) {
        label.text = [NSString stringWithFormat:@"%@, %@", self.searchResults[section].countryTitle, self.searchResults[section].cityTitle];
    } else {
        label.text = [NSString stringWithFormat:@"%@, %@", self.cities[section].countryTitle, self.cities[section].cityTitle];
    }
    label.font = [UIFont systemFontOfSize:19];
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor clearColor];
    [label sizeToFit];
    [view addSubview:label];
    return view;
}
     
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    void (^setStandardUserDefaults)() = ^(NSArray<ModelCity *> *array) {
        [[NSUserDefaults standardUserDefaults]setValue:array[indexPath.section].stations[indexPath.row].stationTitle forKey:kSelectedStationTitle];
        [[NSUserDefaults standardUserDefaults]setValue:array[indexPath.section].stations[indexPath.row].cityTitle forKey:kSelectedCityTitle];
        [[NSUserDefaults standardUserDefaults]setValue:array[indexPath.section].stations[indexPath.row].districtTitle forKey:kSelectedDistrictTitle];
        [[NSUserDefaults standardUserDefaults]setValue:array[indexPath.section].stations[indexPath.row].regionTitle forKey:kSelectedRegionTitle];
        [[NSUserDefaults standardUserDefaults]setValue:array[indexPath.section].stations[indexPath.row].countryTitle forKey:kSelectedCountryTitle];
        [[NSUserDefaults standardUserDefaults]setDouble:array[indexPath.section].stations[indexPath.row].point.longitude forKey:kSelectedLongitude];
        [[NSUserDefaults standardUserDefaults]setDouble:array[indexPath.section].stations[indexPath.row].point.latitude forKey:kSelectedLatitude];
    };
    
    if (self.searchController.isActive && ![self.searchController.searchBar.text isEqualToString:[NSString stringWithFormat:@""]]) {
        setStandardUserDefaults(self.searchResults);
    } else {
        setStandardUserDefaults(self.cities);
    }
        [self performSegueWithIdentifier:@"showDetails" sender:self];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    void (^setStandardUserDefaults)() = ^(NSArray<ModelCity *> *array) {
        if (self.isFromDirection) {
            [[NSUserDefaults standardUserDefaults] setValue:array[indexPath.section].stations[indexPath.row].stationTitle forKey:kStationFrom];
        } else {
            [[NSUserDefaults standardUserDefaults] setValue:array[indexPath.section].stations[indexPath.row].stationTitle forKey:kStationTo];
        }
    };
    if (self.searchController.isActive && ![self.searchController.searchBar.text isEqualToString:[NSString stringWithFormat:@""]]) {
        setStandardUserDefaults(self.searchResults);
    } else {
        setStandardUserDefaults(self.cities);
    }
    
    [self performSegueWithIdentifier:@"unwindToSchedule" sender:self];
}

#pragma mark - UISearchControllerDelegate & UISearchResultsDelegate

- (void)filterContentForSearchText:(NSString *)searchText {
    
    NSMutableArray *result = [NSMutableArray new];
    for (ModelCity *city in self.cities) {
        NSMutableArray<ModelStation *> *tempStations = [NSMutableArray new];
        for (ModelStation *station in city.stations) {
            if ([station.stationTitle rangeOfString:searchText options:NSCaseInsensitiveSearch].length != 0 || [station.cityTitle rangeOfString:searchText options:NSCaseInsensitiveSearch].length != 0) {
                [tempStations addObject:station];
            }
        }
        if (tempStations.count != 0) {
            ModelCity *tempCity = [ModelCity initWithCityTitle:city.cityTitle districtTitle:city.districtTitle regionTitle:city.regionTitle countryTitle:city.countryTitle point:city.point andStations:tempStations];
            [result addObject:tempCity];
        }
    }
    self.searchResults = result;
    [self.tableView reloadData];
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    [self filterContentForSearchText:searchController.searchBar.text];
}

@end
