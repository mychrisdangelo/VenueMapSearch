//
//  Venue+Create.m
//  VenueMapSearch
//
//  Created by Chris D'Angelo on 3/13/14.
//  Copyright (c) 2014 Chris D'Angelo. All rights reserved.
//

#import "Venue+ToggleAddRemove.h"

@implementation Venue (ToggleAddRemove)

+ (Venue *)addRemoveVenueWithVenueResult:(VenueResult *)venueResult inManagedObjectContext:(NSManagedObjectContext *)context
{
    Venue *venue;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Venue"];
    request.predicate = [NSPredicate predicateWithFormat:@"googlePlacesID = %@", venueResult.googlePlacesID];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"googlePlacesID" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || ([matches count] > 1)) {
        // sanity check
        NSLog(@"favorite exists twice");
    } else if ([matches count] == 0) {
        venue = [NSEntityDescription insertNewObjectForEntityForName:@"Venue" inManagedObjectContext:context];
        venue.name = venueResult.name;
        venue.googlePlacesID = venueResult.googlePlacesID;
        venue.priceLevel = [NSNumber numberWithLong:venueResult.priceLevel];
        venue.rating = [NSNumber numberWithLong:venueResult.rating];
        venue.vicinity = venueResult.vicinity;
        
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"error saving");
        }
    } else {
        // only one object
        venue = [matches lastObject];
        [context deleteObject:venue];
    }
    
    return venue;
}

@end
