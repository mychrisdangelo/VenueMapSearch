//
//  GoogleMapManager.h
//  COMSMapManager
//
//  Created by William Falcon on 1/24/14.
//  Copyright (c) 2014 ColumbiaU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocation.h>
@interface GoogleMapManager : NSObject

/*
 Returns an array of Venue Objects for a 2d lat lon, a radius (in meters) for a search query
 The result of this query will be provided in the completion block
 
 Example query params:
 query = Mexican+food+in+New+York
 queryType = Restaurants
 */
+(void)nearestVenuesForLatLong:(CLLocationCoordinate2D)latLong withinRadius:(double)radius forQuery:(NSString *)query queryType:(NSString *)type googleMapsAPIKey:(NSString *)apiKey searchCompletion:(void (^)(NSMutableArray *results))completionHandler;

@end

// API details