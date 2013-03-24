//
//  FirstViewController.h
//  Stuff
//
//  Created by Andy on 08/03/2013.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "LibraryArrays.h"

@class DetailViewController;

@interface MainTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) MainTableViewController *detailViewController;

@property (strong, nonatomic) NSMutableArray* tableData;

@property (assign) UITableView* currentTable;
@property (assign) LibraryArrays* libraryArrays;

@property (strong, nonatomic) NSString* type;

- (void) showNowPlaying;
- (void) receiveNotification:(NSNotification*) notification;
- (void) displayDetailView:(NSMutableArray*) incomingArray;
@end
