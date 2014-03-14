//
//  VenueResult.m
//  RestuarantSearch
//
//  Created by Chris D'Angelo on 1/31/14.
//  Copyright (c) 2014 Chris D'Angelo. All rights reserved.
//

#import "VenueResult.h"

@implementation VenueResult

// Warning: this is not robust
- (id)initWithMapManagerDictionary:(NSDictionary *)MapManagerDictionary withCurrentLocation:(CLLocationCoordinate2D)currentLocation
{
    self = [super init];
    if (self) {
		
        self.name = MapManagerDictionary[kVenueResultName];
        
        CLLocationCoordinate2D tmpLocation;
        tmpLocation.latitude = (CLLocationDegrees)[MapManagerDictionary[kVenueResultGeometry][kVenueResultGeometryLocation][kVenueResultGeometryLocationLatitude] doubleValue];
        tmpLocation.longitude = (CLLocationDegrees)[MapManagerDictionary[kVenueResultGeometry][kVenueResultGeometryLocation][kVenueResultGeometryLocationLongitude] doubleValue];
        self.location = tmpLocation;
        
        self.vicinity = MapManagerDictionary[kVenueResultVicinity];
        self.rating = [MapManagerDictionary[kVenueResultRating] floatValue];
        self.priceLevel = [MapManagerDictionary[kVenueResultPriceLevel] integerValue];
        self.googlePlacesID = MapManagerDictionary[kVenueResultId];
        
        CLLocation *userLocation = [[CLLocation alloc] initWithLatitude:currentLocation.latitude longitude:currentLocation.longitude];
        CLLocation *venueLocation = [[CLLocation alloc] initWithLatitude:tmpLocation.latitude longitude:tmpLocation.longitude];
        self.distanceFromUser = [userLocation distanceFromLocation:venueLocation];
	}
	return self;
}

- (NSString *)title
{
    return self.name;
}

- (NSString *)subtitle
{
    return self.vicinity;
}

- (CLLocationCoordinate2D)coordinate;
{
    return self.location;
}

@end
