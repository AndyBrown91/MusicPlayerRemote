//
//  AppDelegate.m
//  MusicPlayerRemote
//
//  Created by Andy on 31/12/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize connection;
@synthesize provider;
@synthesize viewController;

- (void)registerDefaultsFromSettingsBundle
{
    //NSLog(@"Registering default values from Settings.bundle");
    NSUserDefaults * defs = [NSUserDefaults standardUserDefaults];
    [defs synchronize];
    
    NSString *settingsBundle = [[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"bundle"];
    
    if(!settingsBundle)
    {
        NSLog(@"Could not find Settings.bundle");
        return;
    }
    
    NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:[settingsBundle stringByAppendingPathComponent:@"Root.plist"]];
    NSArray *preferences = [settings objectForKey:@"PreferenceSpecifiers"];
    NSMutableDictionary *defaultsToRegister = [[NSMutableDictionary alloc] initWithCapacity:[preferences count]];
    
    for (NSDictionary *prefSpecification in preferences)
    {
        NSString *key = [prefSpecification objectForKey:@"Key"];
        if (key)
        {
            // check if value readable in userDefaults
            id currentObject = [defs objectForKey:key];
            if (currentObject == nil)
            {
                // not readable: set value from Settings.bundle
                id objectToSet = [prefSpecification objectForKey:@"DefaultValue"];
                [defaultsToRegister setObject:objectToSet forKey:key];
                //NSLog(@"Setting object %@ for key %@", objectToSet, key);
            }
            else
            {
                // already readable: don't touch
                //NSLog(@"Key %@ is readable (value: %@), nothing written to defaults.", key, currentObject);
            }
        }
    }
    
    [defs registerDefaults:defaultsToRegister];
    [defaultsToRegister release];
    [defs synchronize];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [self registerDefaultsFromSettingsBundle];

    ipAddress = [[NSUserDefaults standardUserDefaults] stringForKey:@"ipAddress"];
    port = [[NSUserDefaults standardUserDefaults] integerForKey:@"portNum"];
    connection = new RemoteInterprocessConnection();

    if (!connection->connectToSocket([ipAddress UTF8String], port, 100)) {
        [self displayIpAlert];
    }
    
    provider = [RemoteProvider new];
    viewController = [BeamMusicPlayerViewController new];
    connection->setProvider(provider);
    connection->setController(viewController);
    connectionMade = @"ConnectionMade";
    connection->sendString([connectionMade UTF8String]);
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
    connection->disconnect();
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
    [self registerDefaultsFromSettingsBundle];
    ipAddress = [[NSUserDefaults standardUserDefaults] stringForKey:@"ipAddress"];
    port = [[NSUserDefaults standardUserDefaults] integerForKey:@"portNum"];

    if (!connection->connectToSocket([ipAddress UTF8String], port, 100)) {
        [self displayIpAlert];
    }
    connection->sendString([connectionMade UTF8String]);
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
    connection->disconnect();
    delete connection;
    
}

- (void) displayIpAlert
{
   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ip Address Required" message:@"Please enter the Ip Address of the computer running MusicPlayer" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
    
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;

    UITextField* ipText = [alert textFieldAtIndex:0];
    ipText.text = ipAddress;
    
    [alert addButtonWithTitle:@"Ok"];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"Cancel"])
    {
        [self displayIpAlert];
    }
    else if([title isEqualToString:@"Ok"])
    {
        UITextField* ipText = [alertView textFieldAtIndex:0];
        ipAddress = ipText.text;
        
        if (!connection->connectToSocket([ipAddress UTF8String], port, 100)) {
            [self displayIpAlert];
        }
        
        connection->sendString([connectionMade UTF8String]);
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs setObject:ipAddress forKey:@"ipAddress"];
        [prefs synchronize];
    }
}


@end
