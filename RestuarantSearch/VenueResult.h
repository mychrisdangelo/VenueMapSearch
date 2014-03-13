//
//  VenueResult.h
//  RestuarantSearch
//
//  Created by Chris D'Angelo on 1/31/14.
//  Copyright (c) 2014 Chris D'Angelo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

#define kVenueResultGeometry @"geometry"
#define kVenueResultGeometryLocation @"location"
#define kVenueResultGeometryLocationLatitude @"lat"
#define kVenueResultGeometryLocationLongitude @"lng"
#define kVenueResultIcon @"icon"
#define kVenueResultId @"id"
#define kVenueResultName @"name"
#define kVenueResultRating @"rating"
#define kVenueResultVicinity @"vicinity"
#define kVenueResultPriceLevel @"price_level"

@interface VenueResult : NSObject <MKAnnotation>

- (id)initWithMapManagerDictionary:(NSDictionary *)MapManagerDictionary;

@property (nonatomic) CLLocationCoordinate2D location;
@property (nonatomic, strong) NSString *iconURLString;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *venueResultId;
@property (nonatomic) float rating;
@property (nonatomic, strong) NSString *vicinity;
@property (nonatomic) long priceLevel;

@end

// Example Google Places API returned object
//{
//    geometry =         {
//        location =             {
//            lat = "37.338942";
//            lng = "-122.041508";
//        };
//    };
//    icon = "http://maps.gstatic.com/mapfiles/place_api/icons/restaurant-71.png";
//    id = ed46d2afa166c773dd0fd2bc1fc7314232a770f1;
//    name = "Round Table Pizza";
//    "opening_hours" =         {
//        "open_now" = 1;
//    };
//    "price_level" = 2;
//    rating = "2.6";
//    reference = "CoQBcgAAACQhlhVjBpASWX9jFMkjzb_94EdqfGxilpsHt0PpybDKc9OlG4gOH7wUKFAVvGDccq95GBRa5M6KCcWCTDqR7oA9WuhACDPIGXnvm5tsU5pd7PTggJwfOvdqvEzF-SO75pqtOfVNj7niPPc5eimrZG5K31WLZ_jXuL_mRgmzsL1AEhBSdiKpC_vf5-m7YVjTgJRMGhTUtDUt4A0bwkPQe_nOO6U5ixcD2A";
//    types =         (
//                     restaurant,
//                     food,
//                     establishment
//                     );
//    vicinity = "1663 Hollenbeck Ave, Sunnyvale";
//}
