//
//  AppDelegate.h
//  MusicPlayerRemote
//
//  Created by Andy on 31/12/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RemoteInterprocessConnection.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, UIAlertViewDelegate>
{
    NSString *ipAddress;
    int port;
}
@property (strong, nonatomic) UIWindow *window;
@property (assign, nonatomic) RemoteInterprocessConnection *connection;

- (void) registerDefaultsFromSettingsBundle;
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
- (void) displayIpAlert;

@end
