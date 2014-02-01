//
//  RestuarantSearchMapViewController.m
//  RestuarantSearch
//
//  Created by Chris D'Angelo on 1/31/14.
//  Copyright (c) 2014 Chris D'Angelo. All rights reserved.
//

#import "RestaurantSearchMapViewController.h"


@interface RestaurantSearchMapViewController ()

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic) CLLocationCoordinate2D userLocation;

@end

@implementation RestaurantSearchMapViewController 

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // position searchBar. not interested in search result functionality so remove the delegation
    [self.searchDisplayController setDisplaysSearchBarInNavigationBar:YES];
    [self.searchDisplayController setSearchResultsDataSource:nil];
    [self.searchDisplayController setSearchResultsDelegate:nil];
    
    // start by locating user's current position
	self.locationManager = [[CLLocationManager alloc] init];
	self.locationManager.delegate = self;
	[self.locationManager startUpdatingLocation];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)startSearch:(NSString *)searchString
{
    // search 1 km
    [GoogleMapManager nearestVenuesForLatLong:self.userLocation
                                 withinRadius:1000
                                     forQuery:searchString
                                    queryType:@"restaurant"
                             googleMapsAPIKey:kGoogleApiPlacesKey
                             searchCompletion:^(NSMutableArray *results) {
                                 NSLog(@"%@", results);
                                 [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                             }];

    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

//// confine the map search area to the user's current location
//MKCoordinateRegion newRegion;
//newRegion.center.latitude = self.userLocation.latitude;
//newRegion.center.longitude = self.userLocation.longitude;
//
//// setup the area spanned by the map region:
//// we use the delta values to indicate the desired zoom level of the map,
////      (smaller delta values corresponding to a higher zoom level)
////
//newRegion.span.latitudeDelta = 0.112872;
//newRegion.span.longitudeDelta = 0.109863;
//
//MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
//
//request.naturalLanguageQuery = searchString;
//request.region = newRegion;
//
//
//
//if (self.localSearch != nil)
//{
//    self.localSearch = nil;
//}
//self.localSearch = [[MKLocalSearch alloc] initWithRequest:request];
//
//[self.localSearch startWithCompletionHandler:completionHandler];

//MKLocalSearchCompletionHandler completionHandler = ^(MKLocalSearchResponse *response, NSError *error)
//{
//    if (error != nil)
//    {
//        NSString *errorStr = [[error userInfo] valueForKey:NSLocalizedDescriptionKey];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Could not find places"
//                                                        message:errorStr
//                                                       delegate:nil
//                                              cancelButtonTitle:@"OK"
//                                              otherButtonTitles:nil];
//        [alert show];
//    }
//    else
//    {
//        self.places = [response mapItems];
//        
//        // used for later when setting the map's region in "prepareForSegue"
//        self.boundingRegion = response.boundingRegion;
//        
//        self.viewAllButton.enabled = self.places != nil ? YES : NO;
//        
//        [self.tableView reloadData];
//    }
//    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//};

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    
    // check to see if Location Services is enabled, there are two state possibilities:
    // 1) disabled for entire device, 2) disabled just for this app
    //
    NSString *causeStr = nil;
    
    // check whether location services are enabled on the device
    if ([CLLocationManager locationServicesEnabled] == NO)
    {
        causeStr = @"device";
    }
    // check the application’s explicit authorization status:
    else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)
    {
        causeStr = @"app";
    }
    else
    {
        // we are good to go, start the search
        [self startSearch:searchBar.text];
    }
    
    if (causeStr != nil)
    {
        NSString *alertMessage = [NSString stringWithFormat:@"You currently have location services disabled for this %@. Please refer to \"Settings\" app to turn on Location Services.", causeStr];
        
        UIAlertView *servicesDisabledAlert = [[UIAlertView alloc] initWithTitle:@"Location Services Disabled"
                                                                        message:alertMessage
                                                                       delegate:nil
                                                              cancelButtonTitle:@"OK"
                                                              otherButtonTitles:nil];
        [servicesDisabledAlert show];
    }
}

#pragma mark - UISearchDisplayControllerDelegate

// called when table is shown/hidden
- (void)searchDisplayController:(UISearchDisplayController *)controller didShowSearchResultsTableView:(UITableView *)tableView
{
    [tableView setHidden:YES];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    // remember for later the user's current location
    self.userLocation = newLocation.coordinate;
    
	[manager stopUpdatingLocation]; // we only want one update
    
    manager.delegate = nil;         // we might be called again here, even though we
                                    // called "stopUpdatingLocation", remove us as the delegate to be sure
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    // report any errors returned back from Location Services
    NSLog(@"Error! %s", __PRETTY_FUNCTION__);
}

@end
