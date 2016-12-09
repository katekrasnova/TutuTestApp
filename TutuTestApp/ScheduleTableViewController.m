//
//  ScheduleTableViewController.m
//  TutuTestApp
//
//  Created by Ekaterina Krasnova on 08/12/2016.
//  Copyright © 2016 Ekaterina Krasnova. All rights reserved.
//

#import "ScheduleTableViewController.h"
#import "ModelCities.h"

@interface ScheduleTableViewController ()

@property (weak, nonatomic) IBOutlet UIButton *stationFromButton;
@property (weak, nonatomic) IBOutlet UIButton *stationToButton;
@property (weak, nonatomic) IBOutlet UILabel *firstStationLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondStationLabel;

@property (weak, nonatomic) IBOutlet UIButton *reverseButton;

@end

@implementation ScheduleTableViewController

- (IBAction)reverseButtonTapped:(id)sender {
    
    [UIView animateWithDuration:0.3 animations:^{
        CGPoint cgpoint = self.firstStationLabel.center;
        self.firstStationLabel.center = self.secondStationLabel.center;
        self.secondStationLabel.center = cgpoint;
    }];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[ModelCities sharedInstance] loadCitiesFrom];
    [[ModelCities sharedInstance] loadCitiesTo];
    
    NSLog(@"%@", [ModelCities sharedInstance].citiesFrom[3].cityTitle);
    NSLog(@"%f", [ModelCities sharedInstance].citiesTo[5].point.latitude);
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 0;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
