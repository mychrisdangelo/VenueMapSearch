//
//  RestuarantSearchDetailViewController.h
//  RestuarantSearch
//
//  Created by Chris D'Angelo on 1/30/14.
//  Copyright (c) 2014 Chris D'Angelo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RestuarantSearchDetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
