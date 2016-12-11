//
//  ScheduleTableViewController.m
//  TutuTestApp
//
//  Created by Ekaterina Krasnova on 08/12/2016.
//  Copyright © 2016 Ekaterina Krasnova. All rights reserved.
//

#import "ScheduleTableViewController.h"
#import "ModelCities.h"
#import "CalendarViewController.h"
#import "Constants.h"

@interface ScheduleTableViewController ()

@property (weak, nonatomic) IBOutlet UIButton *stationFromButton;
@property (weak, nonatomic) IBOutlet UIButton *stationToButton;
@property (weak, nonatomic) IBOutlet UILabel *firstStationLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondStationLabel;
@property (nonatomic) BOOL isFirstLabelForStationFrom;

@property (weak, nonatomic) IBOutlet UIButton *reverseButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedController;

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
    NSLog(@"%f, %f, %f, %f", self.secondStationLabel.frame.origin.x, self.secondStationLabel.frame.origin.y, self.secondStationLabel.frame.size.width, self.secondStationLabel.frame.size.height);
    
    //Return labels for init places
    self.firstStationLabel.frame = CGRectMake(52.0, 40.0, self.view.frame.size.width - 72, 20.0);
    self.secondStationLabel.frame = CGRectMake(52.0, 81.0, self.view.frame.size.width - 72, 20.0);

    setStationLabelText(self.firstStationLabel, kStationFrom);
    setStationLabelText(self.secondStationLabel, kStationTo);
    
    [self setSegmentedControllerTitles];
    
    self.tableView.tableFooterView = [UIView new];  //hide separator for empty rows
    [self.tableView reloadData];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(setSegmentedControllerTitles) name:@"reloadSegmentedController" object:nil];
}

- (void)setSegmentedControllerTitles {
    //If user select date from calendar add new segment to segmentedController and save this date for key 'kPickedDate'
    if ([[NSUserDefaults standardUserDefaults] valueForKey:kPickedDate] != nil) {
        if (self.segmentedController.numberOfSegments <= 3) {
            [self.segmentedController removeSegmentAtIndex:2 animated:NO];
            [self.segmentedController insertSegmentWithTitle:@"" atIndex:2 animated:YES];
            [self.segmentedController insertSegmentWithTitle:@"Выбрать день" atIndex:3 animated:NO];
            self.segmentedController.selectedSegmentIndex = 3;
        }
        [self.segmentedController setTitle:[[NSUserDefaults standardUserDefaults] valueForKey:kPickedDate] forSegmentAtIndex:2];
    }
    if (self.segmentedController.selectedSegmentIndex == 3) {
        self.segmentedController.selectedSegmentIndex = 2;
    }
}

#pragma mark - IBActions

- (IBAction)reverseButtonTapped:(id)sender {
    
    //If the user has not selected any station show alert and exit
    if ([[NSUserDefaults standardUserDefaults] valueForKey:kStationFrom] == nil && [[NSUserDefaults standardUserDefaults] valueForKey:kStationTo] == nil) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Выберите станцию" message:@"Вы не выбрали станцию отправления и/или прибытия." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *acOK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:acOK];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    //Change stationFrom to stationTo, stationTo to stationFrom and, accordingly, their labels with animation
    NSString *stationFrom = [[NSUserDefaults standardUserDefaults]valueForKey:kStationFrom];
    [[NSUserDefaults standardUserDefaults]setValue:[[NSUserDefaults standardUserDefaults]valueForKey:kStationTo] forKey:kStationFrom];
    [[NSUserDefaults standardUserDefaults]setValue:stationFrom forKey:kStationTo];

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
    //Set mark 'kIsFromDirection' for direction (from or to)
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:kIsFromDirection];
}

- (IBAction)stationToButtonTapped:(id)sender {
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:kIsFromDirection];
}

- (IBAction)segmentedControllerTapped:(id)sender {
    //If user select 'Выбрать дату' present CalendarViewController
    if (self.segmentedController.numberOfSegments == 4 && self.segmentedController.selectedSegmentIndex == 3) {
        [self performSegueWithIdentifier:@"showCalendar" sender:self];
    } else if (self.segmentedController.numberOfSegments == 3 && self.segmentedController.selectedSegmentIndex == 2) {
        [self performSegueWithIdentifier:@"showCalendar" sender:self];
    }
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
    //If the stations is not selected or selected the same stations the route is missing
    if ([[NSUserDefaults standardUserDefaults]valueForKey:kStationFrom] == nil ||
        [[NSUserDefaults standardUserDefaults]valueForKey:kStationTo] == nil ||
        [[[NSUserDefaults standardUserDefaults]valueForKey:kStationFrom] isEqualToString:[[NSUserDefaults standardUserDefaults]valueForKey:kStationTo]]) {
        cell.textLabel.text = @"";
        
        //If user selected the same stations show alert
        if ([[[NSUserDefaults standardUserDefaults]valueForKey:kStationFrom] isEqualToString:[[NSUserDefaults standardUserDefaults]valueForKey:kStationTo]]) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Выберите станцию" message:@"Станция отправления и прибытия совпадают. Выберите другую станцию" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *acOK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:acOK];
            [self presentViewController:alert animated:YES completion:nil];
        }
        
    } else {
        //Set route
        cell.textLabel.text = [NSString stringWithFormat:@"%@ - %@", [[NSUserDefaults standardUserDefaults]valueForKey:kStationFrom], [[NSUserDefaults standardUserDefaults]valueForKey:kStationTo]];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //If the stations is selected and it's a different stations show alert with message about route
    if ([[NSUserDefaults standardUserDefaults]valueForKey:kStationFrom] != nil &&
        [[NSUserDefaults standardUserDefaults]valueForKey:kStationTo] != nil &&
        ![[[NSUserDefaults standardUserDefaults]valueForKey:kStationFrom] isEqualToString:[[NSUserDefaults standardUserDefaults]valueForKey:kStationTo]]) {
        NSString *route = [NSString stringWithFormat:@"%@ - %@", [[NSUserDefaults standardUserDefaults]valueForKey:kStationFrom], [[NSUserDefaults standardUserDefaults]valueForKey:kStationTo]];
        NSString *date;
        if (self.segmentedController.selectedSegmentIndex == 0) {
            date = [NSString stringWithFormat:@"Сегодня"];
        } else if (self.segmentedController.selectedSegmentIndex == 1) {
            date = [NSString stringWithFormat:@"Завтра"];
        } else if (self.segmentedController.selectedSegmentIndex == 2) {
            date = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults]valueForKey:kPickedDate]];
        }
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Расписание" message:[NSString stringWithFormat:@"Поезд по маршруту '%@' отправляется %@. Счастливого пути!", route, date]  preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (IBAction)unwindToSchedule:(UIStoryboardSegue *)segue {
    [self viewDidLoad];
}

@end
