//
//  VenueDetailTableViewController.h
//  VenueMapSearch
//
//  Created by Chris D'Angelo on 2/1/14.
//  Copyright (c) 2014 Chris D'Angelo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VenueResult.h"

@interface VenueDetailTableViewController : UITableViewController

@property (nonatomic, strong) VenueResult *venue;

@end
