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

@interface AppDelegate : UIResponder <UIApplicationDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UITabBarController *tabBarController;

//@property (strong, nonatomic) UINavigationController* nav;

//Remote Properties
@property (strong, nonatomic) NSString* ipAddress;
@property (assign, nonatomic) int port;

@property (assign) RemoteInterprocessConnection* connection;

@property (strong, nonatomic) BeamMusicPlayerViewController *nowPlayingController;

@property (strong, nonatomic) id<BeamMusicPlayerDataSource,BeamMusicPlayerDelegate> remoteProvider;

- (void) registerDefaultsFromSettingsBundle;

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
- (void) displayIpAlert;

@end
