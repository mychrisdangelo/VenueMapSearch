//
//  VenueSearchResultsModelSingleton.h
//  VenueMapSearch
//
//  Created by Chris D'Angelo on 3/13/14.
//  Copyright (c) 2014 Chris D'Angelo. All rights reserved.
//
//  Clean singleton implmentation from: http://www.codigator.com/snippets/how-to-make-a-singleton-class-in-ios-objectivec-snippet/

#import <Foundation/Foundation.h>

extern NSString * const kSearchResultsDidChangeNotification;

@interface VenueSearchResultsModelSingleton : NSObject

@property (nonatomic, strong) NSArray *searchResults;
+ (id)sharedModel;

@end
