//
//  VenueListTableViewController.m
//  VenueMapSearch
//
//  Created by Chris D'Angelo on 2/1/14.
//  Copyright (c) 2014 Chris D'Angelo. All rights reserved.
//

#import "VenueListTableViewController.h"
#import "VenueDetailTableViewController.h"

@interface VenueListTableViewController ()

@end

@implementation VenueListTableViewController

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

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowVenueDetail"]) {
        if ([segue.destinationViewController isKindOfClass:[VenueDetailTableViewController class]]) {
            VenueDetailTableViewController *vdtvc = (VenueDetailTableViewController *)segue.destinationViewController;

            if ([sender isKindOfClass:[UITableViewCell class]]) {
                UITableViewCell *tvc = (UITableViewCell *)sender;
                NSIndexPath *indexPath = [self.tableView indexPathForCell:tvc];
                vdtvc.venue = self.searchResults[indexPath.row];
            }
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.searchResults count] ? [self.searchResults count] : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"VenueListTableViewControllerCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    
    
    if ([self.searchResults count]) {
        VenueResult *vr = (VenueResult *)self.searchResults[indexPath.row];
        cell.textLabel.text = vr.name;
        cell.detailTextLabel.text = vr.vicinity;
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    } else {
        cell.textLabel.text = @"No Results.";
        cell.detailTextLabel.text = @"";
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }

    
    return cell;
}

@end
