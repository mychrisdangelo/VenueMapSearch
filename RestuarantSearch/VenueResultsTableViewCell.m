//
//  VenueResultsTableViewCell.m
//  VenueMapSearch
//
//  Created by Chris D'Angelo on 3/13/14.
//  Copyright (c) 2014 Chris D'Angelo. All rights reserved.
//

#import "VenueResultsTableViewCell.h"

@implementation VenueResultsTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setFavorited:(BOOL)favorited
{
    if (_favorited == favorited) {
        return;
    }
    
    if (favorited) {
        [self.favoriteButton setImage:[UIImage imageNamed:@"FavoriteIconFilled"] forState:UIControlStateNormal];
    } else {
        [self.favoriteButton setImage:[UIImage imageNamed:@"FavoriteIcon"] forState:UIControlStateNormal];
    }
    
}

- (IBAction)favoriteButtonSelected:(UIButton *)sender {
    if ([sender.imageView.image isEqual:[UIImage imageNamed:@"FavoriteIcon"]]) {
        [sender setImage:[UIImage imageNamed:@"FavoriteIconFilled"] forState:UIControlStateNormal];
    } else {
        [sender setImage:[UIImage imageNamed:@"FavoriteIcon"] forState:UIControlStateNormal];
    }
    
    [self.delegate venueResultsTableViewCellPressedFavoriteButton:self];
}


@end
