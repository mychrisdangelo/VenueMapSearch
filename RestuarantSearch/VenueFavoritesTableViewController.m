//
//  VenueFavoritesTableViewController.m
//  VenueMapSearch
//
//  Created by Chris D'Angelo on 3/13/14.
//  Copyright (c) 2014 Chris D'Angelo. All rights reserved.
//

#import "VenueFavoritesTableViewController.h"
#import "VenueMapSearchAppDelegate.h"
#import "Venue+ToggleAddRemove.h"
#import "VenueDetailTableViewController.h"
#import "VenueResult.h"

NSString * const kFavoritesDidChangeFromFavoritesViewNotification = @"kFavoritesDidChangeFromFavoritesViewNotification";

@interface VenueFavoritesTableViewController () <NSFetchedResultsControllerDelegate, VenueResultsTableViewCellDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end

@implementation VenueFavoritesTableViewController

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    VenueMapSearchAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *moc = delegate.managedObjectContext;
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Venue" inManagedObjectContext:moc];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    [fetchRequest setSortDescriptors:sortDescriptors];
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                    managedObjectContext:moc
                                                                      sectionNameKeyPath:nil
                                                                               cacheName:nil];
    
    [_fetchedResultsController setDelegate:self];
    
    NSError *error = nil;
    if (![_fetchedResultsController performFetch:&error]) {
        NSLog(@"Error performing fetch: %@", error);
    }
    
    return _fetchedResultsController;
}

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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([[self.fetchedResultsController sections] count] > 0) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
        return [sectionInfo numberOfObjects];
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"VenueListTableViewControllerCell";
    VenueResultsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if ([[self.fetchedResultsController sections] count] > 0) {
        Venue *venue = [self.fetchedResultsController objectAtIndexPath:indexPath];
        cell.textLabel.text = venue.name;
        cell.detailTextLabel.text = venue.vicinity;
        cell.favoriteButton.hidden = NO;
        cell.favorited = YES;
    } else {
        cell.textLabel.text = @"No Favorites.";
        cell.detailTextLabel.text = @"";
        cell.favoriteButton.hidden = YES;
    }
    
    cell.delegate = self;
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowVenueDetail"]) {
        if ([segue.destinationViewController isKindOfClass:[VenueDetailTableViewController class]]) {
            VenueDetailTableViewController *vdtvc = (VenueDetailTableViewController *)segue.destinationViewController;
            
            if ([sender isKindOfClass:[UITableViewCell class]]) {
                UITableViewCell *tvc = (UITableViewCell *)sender;
                NSIndexPath *indexPath = [self.tableView indexPathForCell:tvc];
                Venue *venue = [self.fetchedResultsController objectAtIndexPath:indexPath];
                
                // package expected type VenueResult
                VenueResult *vr = [[VenueResult alloc] init];
                vr.name = venue.name;
                vr.vicinity = venue.vicinity;
                vr.rating = [venue.rating longValue];
                vr.priceLevel = [venue.priceLevel longValue];
                
                vdtvc.venue = vr;
            }
        }
    }
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)theIndexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:theIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

#pragma mark - VenueResultsTableViewCellDelegate

- (void)venueResultsTableViewCellPressedFavoriteButton:(VenueResultsTableViewCell *)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    Venue *venue = [self.fetchedResultsController objectAtIndexPath:indexPath];
    VenueMapSearchAppDelegate *delegate = [UIApplication sharedApplication].delegate;
    
    // only googlePlacesID required by callee
    VenueResult *vr = [[VenueResult alloc] init];
    vr.googlePlacesID = venue.googlePlacesID;
    [Venue addRemoveVenueWithVenueResult:vr inManagedObjectContext:delegate.managedObjectContext];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kFavoritesDidChangeFromFavoritesViewNotification object:nil userInfo:nil];
}

@end
