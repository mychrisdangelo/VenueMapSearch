//
//  RestuarantSearchMapViewController.h
//  RestuarantSearch
//
//  Created by Chris D'Angelo on 1/31/14.
//  Copyright (c) 2014 Chris D'Angelo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <COMSMapManager/COMSMapManager.h>
#import <MapKit/MapKit.h>
#import "Constants.h"


@interface VenueSearchMapViewController : UIViewController <UISearchDisplayDelegate, UISearchBarDelegate, CLLocationManagerDelegate, MKMapViewDelegate>

@property (nonatomic, strong) NSString *searchCategory;

@end
