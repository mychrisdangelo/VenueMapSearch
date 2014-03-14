//
//  VenueResultsTableViewCell.h
//  VenueMapSearch
//
//  Created by Chris D'Angelo on 3/13/14.
//  Copyright (c) 2014 Chris D'Angelo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VenueResultsTableViewCell;

@protocol VenueResultsTableViewCellDelegate <NSObject>
- (void)venueResultsTableViewCellPressedFavoriteButton:(VenueResultsTableViewCell *)sender;
@end

@interface VenueResultsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) id <VenueResultsTableViewCellDelegate> delegate;

@end

