//
//  DetailViewController.h
//  stuff
//
//  Created by Andy on 10/03/2013.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "AppDelegate.h"

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

- (void)showNowPlaying;

@end
