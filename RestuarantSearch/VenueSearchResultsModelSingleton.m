//
//  VenueSearchResultsModelSingleton.m
//  VenueMapSearch
//
//  Created by Chris D'Angelo on 3/13/14.
//  Copyright (c) 2014 Chris D'Angelo. All rights reserved.
//

#import "VenueSearchResultsModelSingleton.h"

NSString * const kSearchResultsDidChangeNotification = @"kSearchResultsDidChangeNotification";

@implementation VenueSearchResultsModelSingleton

@synthesize searchResults = _searchResults;

- (void)setSearchResults:(NSArray *)searchResults
{
    if (_searchResults == searchResults) {
        return;
    }
    
    _searchResults = searchResults;
    [[NSNotificationCenter defaultCenter] postNotificationName:kSearchResultsDidChangeNotification object:nil userInfo:nil];
}

+ (id)sharedModel
{
    static VenueSearchResultsModelSingleton *sharedModel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedModel = [[self alloc] init];
    });
    return sharedModel;
}

@end
