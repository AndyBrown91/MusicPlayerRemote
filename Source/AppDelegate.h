//
//  AppDelegate.h
//  Stuff
//
//  Created by Andy on 08/03/2013.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RemoteInterprocessConnection.h"
#import "BeamMusicPlayerViewController.h"
#import "RemoteProvider.h"

/** Controls the running of the application - Contains the globally used variables */
@interface AppDelegate : UIResponder <UIApplicationDelegate, UIAlertViewDelegate, UITabBarControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UITabBarController *tabBarController;

//@property (strong, nonatomic) UINavigationController* nav;

//Remote Properties
/** The IP address to connect to as a string */
@property (strong, nonatomic) NSString* ipAddress;
/** The port to connect to 8888 */
@property (assign, nonatomic) int port;

/** Whether the app is going into the background */
@property (assign, nonatomic) BOOL enteringBackground;

/** The connection to the desktop application */
@property (assign) RemoteInterprocessConnection* connection;
/** The now playing view controller */
@property (strong, nonatomic) BeamMusicPlayerViewController *nowPlayingController;
/** The data source and delegate for the now playing view controller */
@property (strong, nonatomic) id<BeamMusicPlayerDataSource,BeamMusicPlayerDelegate> remoteProvider;

/** Loads the default values from the settings bundle */
- (void) registerDefaultsFromSettingsBundle;
/** Checks that the connection has been made, if not trys again before displaying the connection alert window - Always called from a NSTimer giving the connection time to be made properly on the phone, not required for the simulator which connects instantly */
- (void)remoteConnectTimeout;
/** Callback for buttons clicked in the ipaddress alert window */
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
/** Displays an alert window asking for the user to input the ip address they wish to connect to. If ok is pressed trys to connect and then calls remoteConnectTimeout on a 1 second timer */
- (void) displayIpAlert;

@end
