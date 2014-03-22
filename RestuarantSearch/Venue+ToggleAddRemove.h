//
//  Venue+Create.h
//  VenueMapSearch
//
//  Created by Chris D'Angelo on 3/13/14.
//  Copyright (c) 2014 Chris D'Angelo. All rights reserved.
//

#import "Venue.h"
#import "VenueResult.h"

@interface Venue (ToggleAddRemove)

+ (Venue *)addRemoveVenueWithVenueResult:(VenueResult *)venueResult inManagedObjectContext:(NSManagedObjectContext *)context;

@end
