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
@property (nonatomic) BOOL isFirstLabelForStationFrom;

@property (weak, nonatomic) IBOutlet UIButton *reverseButton;

@end

@implementation ScheduleTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    void (^setStationLabelText)() = ^(UILabel *label, NSString *stationDirection) {
        NSString *strDirection = [[NSUserDefaults standardUserDefaults]valueForKey:stationDirection];
        if (strDirection != nil) {
            label.textColor = [UIColor blackColor];
            label.text = strDirection;
        }
    };
    setStationLabelText(self.firstStationLabel, @"stationFrom");
    setStationLabelText(self.secondStationLabel, @"stationTo");
    
    [self.tableView reloadData];
    self.tableView.tableFooterView = [UIView new];  //hide separator for empty rows
}

#pragma mark - IBActions

- (IBAction)reverseButtonTapped:(id)sender {
    
    //If the user has not selected any station exit method
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"stationFrom"] == nil && [[NSUserDefaults standardUserDefaults] valueForKey:@"stationTo"] == nil) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Выберите станцию" message:@"Вы не выбрали станцию отправления и/или прибытия" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *acOK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:acOK];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    //Change stationFrom to stationTo, stationTo to stationFrom and, accordingly, their labels with animation
    NSString *stationFrom = [[NSUserDefaults standardUserDefaults]valueForKey:@"stationFrom"];
    [[NSUserDefaults standardUserDefaults]setValue:[[NSUserDefaults standardUserDefaults]valueForKey:@"stationTo"] forKey:@"stationFrom"];
    [[NSUserDefaults standardUserDefaults]setValue:stationFrom forKey:@"stationTo"];

    void (^changeStationLabelText)() = ^(UILabel *label) {
        if ([label.text isEqualToString:@"Откуда"]) {
            label.text = [NSString stringWithFormat:@"Куда"];
        } else if ([label.text isEqualToString:@"Куда"]) {
            label.text = [NSString stringWithFormat:@"Откуда"];
        }
    };
    changeStationLabelText(self.firstStationLabel);
    changeStationLabelText(self.secondStationLabel);
    
    [UIView animateWithDuration:0.3 animations:^{
        CGPoint cgpoint = self.firstStationLabel.center;
        self.firstStationLabel.center = self.secondStationLabel.center;
        self.secondStationLabel.center = cgpoint;
        //rotate reverse button
        self.reverseButton.imageView.transform = CGAffineTransformMakeRotation(180 * M_PI/180);
    }];
    self.reverseButton.imageView.transform = CGAffineTransformMakeRotation(0);
    
    [self.tableView reloadData];
}

- (IBAction)stationFromButtonTapped:(id)sender {
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isFromDirection"];
}

- (IBAction)stationToButtonTapped:(id)sender {
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"isFromDirection"];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ScheduleCell" forIndexPath:indexPath];
    cell.textLabel.numberOfLines = 0;
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"stationFrom"] == nil || [[NSUserDefaults standardUserDefaults]valueForKey:@"stationTo"] == nil) {
        cell.textLabel.text = @"";
    } else {
        cell.textLabel.text = [NSString stringWithFormat:@"%@ - %@", [[NSUserDefaults standardUserDefaults]valueForKey:@"stationFrom"], [[NSUserDefaults standardUserDefaults]valueForKey:@"stationTo"]];
    }
    return cell;
}

- (IBAction)unwindToSchedule:(UIStoryboardSegue *)segue {
    [self viewDidLoad];
}

@end
