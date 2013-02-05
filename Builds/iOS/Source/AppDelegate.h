//
//  AppDelegate.h
//  MusicPlayerRemote
//
//  Created by Andy on 31/12/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RemoteInterprocessConnection.h"
#import "RemoteProvider.h"
#import "BeamMusicPlayerViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, UIAlertViewDelegate>
{
    NSString *ipAddress;
    int port;
    NSString *connectionMade;
}
@property (strong, nonatomic) UIWindow *window;
@property (readonly, nonatomic) RemoteInterprocessConnection *connection;
@property (strong, nonatomic) RemoteProvider *provider;
@property (strong, nonatomic) BeamMusicPlayerViewController *viewController;

- (void) registerDefaultsFromSettingsBundle;
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
- (void) displayIpAlert;

@end
