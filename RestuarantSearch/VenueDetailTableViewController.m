//
//  VenueDetailTableViewController.m
//  VenueMapSearch
//
//  Created by Chris D'Angelo on 2/1/14.
//  Copyright (c) 2014 Chris D'Angelo. All rights reserved.
//

#import "VenueDetailTableViewController.h"

@interface VenueDetailTableViewController ()

enum kCellMapping
{
    kVenueName,
    kVenueVicinity,
    kVenueRating,
    kVenuePrice,
    kVenueCount
};

@end

@implementation VenueDetailTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.title = self.venue.name;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (NSString *)stringFromString:(NSString *)aString toRepeat:(long)numberOfTimes
{
    NSMutableString *retString = [[NSMutableString alloc] init];
    for (int i = 0; i < numberOfTimes; i++) {
        [retString appendString:aString];
    }
    return retString;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return kVenueCount;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Information";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"VenueDetailTableViewControllerCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    switch (indexPath.row) {
        case kVenueName:
            cell.textLabel.text = @"Name";
            cell.detailTextLabel.text = self.venue.name;
            break;
        case kVenueVicinity:
            cell.textLabel.text = @"Vicinity";
            cell.detailTextLabel.text = self.venue.vicinity;
            break;
        case kVenueRating:
            cell.textLabel.text = @"Rating";
            [cell.detailTextLabel setFont:[UIFont fontWithName:@"FontAwesome" size:14.0]];
            [cell.detailTextLabel setText:[VenueDetailTableViewController stringFromString:@"\uf005" toRepeat:self.venue.rating]];
            break;
        case kVenuePrice:
            cell.textLabel.text = @"Price";
            cell.detailTextLabel.text = [VenueDetailTableViewController stringFromString:@"$" toRepeat:self.venue.priceLevel];
    }
    
    return cell;
}



@end
