//
//  RestuarantSearchMapViewController.m
//  RestuarantSearch
//
//  Created by Chris D'Angelo on 1/31/14.
//  Copyright (c) 2014 Chris D'Angelo. All rights reserved.
//

#import "RestaurantSearchMapViewController.h"
#import "VenueResult.h"


@interface RestaurantSearchMapViewController ()

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic) CLLocationCoordinate2D userLocation;
@property (nonatomic, strong) NSArray *searchResults;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic) BOOL isLocationServicesAllowed;

@end

@implementation RestaurantSearchMapViewController 

- (void)setUserLocation:(CLLocationCoordinate2D)userLocation
{
    _userLocation = userLocation;
    [self updateMapViewBounds];
}

- (void)setSearchResults:(NSArray *)searchResults
{
    // change searchResults from NSDictionary objecdts to VenueResult objects conforming to Annotations
    NSMutableArray *venueResultsMutable = [[NSMutableArray alloc] init];
    for (NSDictionary *each in searchResults) {
        VenueResult *vr = [[VenueResult alloc] initWithMapManagerDictionary:each];
        [venueResultsMutable addObject:vr];
    }
    
    _searchResults = [venueResultsMutable copy];
    
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView addAnnotations:_searchResults];
}

- (BOOL)isLocationServicesAllowed
{
    BOOL isAllowed = YES;
    // check to see if Location Services is enabled, there are two state possibilities:
    // 1) disabled for entire device, 2) disabled just for this app
    //
    NSString *causeStr = nil;
    
    // check whether location services are enabled on the device
    if ([CLLocationManager locationServicesEnabled] == NO)
    {
        causeStr = @"device";
        isAllowed = NO;
    }
    // check the application’s explicit authorization status:
    else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)
    {
        causeStr = @"app";
        isAllowed = NO;
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
    
    return isAllowed;
}

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
    if (self.isLocationServicesAllowed) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        [self.locationManager startUpdatingLocation];
    }
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
                                 withinRadius:kSearchRadiusMeters
                                     forQuery:searchString
                                    queryType:kSearchQueryType
                             googleMapsAPIKey:kGoogleApiPlacesKey
                             searchCompletion:^(NSMutableArray *results) {
                                 NSLog(@"%@", results);
                                 
                                 [self setSearchResults:results];

                                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                 if (![results count]) {
                                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No results found"
                                                                                    message:nil
                                                                                   delegate:nil
                                                                          cancelButtonTitle:@"OK"
                                                                          otherButtonTitles:nil];
                                    [alert show];
                                 }
                             }];


    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void) updateMapViewBounds
{
    // confine the map search area to the user's current location
    MKCoordinateRegion boundingRegion;
    boundingRegion.center.latitude = self.userLocation.latitude;
    boundingRegion.center.longitude = self.userLocation.longitude;
    
    // setup the area spanned by the map region:
    // we use the delta values to indicate the desired zoom level of the map,
    //      (smaller delta values corresponding to a higher zoom level)
    
    boundingRegion.span.latitudeDelta = 0.112872;
    boundingRegion.span.longitudeDelta = 0.109863;
    
    [self.mapView setRegion:boundingRegion];
}

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
    
    if (self.isLocationServicesAllowed) {
        [self startSearch:searchBar.text];
    }
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:NO animated:YES];
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
