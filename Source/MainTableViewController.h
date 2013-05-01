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
/** The table view controller, allows the user to select the song they wish to play */
@interface MainTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) MainTableViewController *detailViewController;

@property (strong, nonatomic) NSMutableArray* tableData;

@property (assign) UITableView* currentTable;
@property (assign) LibraryArrays* libraryArrays;

@property (strong, nonatomic) NSString* type;
/** Show the now playing view controller when the button is pressed */
- (void) showNowPlaying;
/** Loads the correct data into the table when the data has been received and loaded by the RemoteInterprocessConnection class */
- (void) receiveNotification:(NSNotification*) notification;
/** Shows another MainTableViewController class with the next information down the chain. Artist -> albums, albums -> songs etc. */
- (void) displayDetailView:(NSMutableArray*) incomingArray;
@end
