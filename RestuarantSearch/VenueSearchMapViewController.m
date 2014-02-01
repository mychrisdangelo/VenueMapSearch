//
//  RestuarantSearchMapViewController.m
//  RestuarantSearch
//
//  Created by Chris D'Angelo on 1/31/14.
//  Copyright (c) 2014 Chris D'Angelo. All rights reserved.
//

#import "VenueSearchMapViewController.h"
#import "VenueResult.h"

@interface VenueSearchMapViewController ()

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic) CLLocationCoordinate2D userLocation;
@property (nonatomic, strong) NSArray *searchResults;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic) BOOL isLocationServicesAllowed;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation VenueSearchMapViewController 

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
    [self updateRegion];
}

// from Stanford Fall '13
// a bit of a hack. the annotations will not refresh unless there is reason to
// so this serves the purpose of forcing a redraw of the pins
- (void)updateRegion
{
    CGRect boundingRect;
    BOOL started = NO;
    for (id <MKAnnotation> annotation in self.mapView.annotations) {
        CGRect annotationRect = CGRectMake(annotation.coordinate.latitude, annotation.coordinate.longitude, 0, 0);
        if (!started) {
            started = YES;
            boundingRect = annotationRect;
        } else {
            boundingRect = CGRectUnion(boundingRect, annotationRect);
        }
    }
    if (started) {
        boundingRect = CGRectInset(boundingRect, -0.02, -0.02);
        if ((boundingRect.size.width < 20) && (boundingRect.size.height < 20)) {
            MKCoordinateRegion region;
            region.center.latitude = boundingRect.origin.x + boundingRect.size.width / 2;
            region.center.longitude = boundingRect.origin.y + boundingRect.size.height / 2;
            region.span.latitudeDelta = boundingRect.size.width;
            region.span.longitudeDelta = boundingRect.size.height;
            [self.mapView setRegion:region animated:YES];
        }
    }
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
    
    [self setupSearchBar];
    
    // start by locating user's current position
    if (self.isLocationServicesAllowed) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        [self.locationManager startUpdatingLocation];
    }
    
    [self.mapView setDelegate:self];
}

- (void)setupSearchBar
{
    // position searchBar. not interested in search result functionality so remove the delegation
    //    [self.searchDisplayController setDisplaysSearchBarInNavigationBar:YES];
    //    [self.searchDisplayController setSearchResultsDataSource:nil];
    //    [self.searchDisplayController setSearchResultsDelegate:nil];
    
    // this is a hack. would prefer to use searchDisplayController but
    // it requires tableivew
    [self.searchBar sizeToFit];
    UIView *barWrapper = [[UIView alloc]initWithFrame:self.searchBar.frame];
    [barWrapper setBackgroundColor:[UIColor clearColor]];
    [barWrapper addSubview:self.searchBar];
    self.navigationItem.titleView = barWrapper;
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
                                 
                                 [self setSearchResults:results];
                                 [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                 
                                 if (![results count]) {
                                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No results found"
                                                                                    message:nil
                                                                                   delegate:nil
                                                                          cancelButtonTitle:@"OK"
                                                                          otherButtonTitles:nil];
                                    [alert show];
#warning TODO this alert is blocking the main thread!
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
    
    boundingRegion.span.latitudeDelta = 0.082872;
    boundingRegion.span.longitudeDelta = 0.090863;
    
    [self.mapView setRegion:boundingRegion animated:YES];
}

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

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    [searchBar resignFirstResponder];
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
    NSLog(@"%s: %@", __PRETTY_FUNCTION__, [error userInfo]);
}

#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
	MKPinAnnotationView *annotationView = nil;
	if ([annotation isKindOfClass:[VenueResult class]])
	{
		annotationView = (MKPinAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:@"Pin"];
		if (annotationView == nil)
		{
			annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Pin"];
			annotationView.canShowCallout = YES;
			annotationView.animatesDrop = YES;
		}
	}
	return annotationView;
}

@end
