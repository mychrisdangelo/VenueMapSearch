//
//  Venue.h
//  VenueMapSearch
//
//  Created by Chris D'Angelo on 3/13/14.
//  Copyright (c) 2014 Chris D'Angelo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Venue : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * googlePlacesID;
@property (nonatomic, retain) NSNumber * priceLevel;
@property (nonatomic, retain) NSNumber * rating;
@property (nonatomic, retain) NSString * vicinity;

@end
