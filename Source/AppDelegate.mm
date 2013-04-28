//
//  AppDelegate.m
//  Stuff
//
//  Created by Andy on 08/03/2013.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

#import "MainTableViewController.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize tabBarController = _tabBarController;
@synthesize port = _port;
@synthesize ipAddress = _ipAddress;

@synthesize connection;
@synthesize nowPlayingController = _nowPlayingController;
@synthesize remoteProvider = _remoteProvider;

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
                //NSLog(@"Key %@;is readable (value: %@), nothing written to defauults.", key, currentObject);
            }
        }
    }
    
    [defs registerDefaults:defaultsToRegister];
    [defs synchronize];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    [self registerDefaultsFromSettingsBundle];
    
    //Connection/nowplaying
    self.ipAddress = [[NSUserDefaults standardUserDefaults] stringForKey:@"ipAddress"];
    self.port = [[NSUserDefaults standardUserDefaults] integerForKey:@"portNum"];
    
    self.connection = new RemoteInterprocessConnection();

    if (!self.connection->connectToSocket([self.ipAddress UTF8String], self.port, 100)) {
        if (!self.connection->isConnected())
        {
            NSTimer* timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                      target:self
                                                    selector:@selector(remoteConnectTimeout)
                                                    userInfo:nil
                                                     repeats:NO];
            [timer fire];
        }
    }
    
    self.remoteProvider = [RemoteProvider new];
    self.nowPlayingController = [BeamMusicPlayerViewController new];
    connection->setProvider(self.remoteProvider);
    connection->setController(self.nowPlayingController);
    NSString* connectionMade = @"ConnectionMade";
    connection->sendString([connectionMade UTF8String]);
    
    //INIT tab bar
    MainTableViewController *playlistsController = [[MainTableViewController alloc] initWithNibName:@"FirstViewController" bundle:nil];
    playlistsController.title = NSLocalizedString(@"Playlists", @"Playlists");
    playlistsController.type = @"Playlists";
    playlistsController.tabBarItem.image = [UIImage imageNamed:@"id-card"];
    //Add notification listener
    [[NSNotificationCenter defaultCenter] addObserver:playlistsController
                                             selector:@selector(receiveNotification:) 
                                                 name:nil
                                               object:nil];
    UINavigationController* playlistsWrapper = [[UINavigationController alloc] initWithRootViewController:playlistsController]; 
    [playlistsWrapper.navigationBar setBarStyle:UIBarStyleBlackOpaque];
    
    
    MainTableViewController *artistsController = [[MainTableViewController alloc] initWithNibName:@"FirstViewController" bundle:nil];
    artistsController.title = NSLocalizedString(@"Artists", @"Artists");
    artistsController.type = @"Artists";
    artistsController.tabBarItem.image = [UIImage imageNamed:@"folder"];
    //Add notification listener
    [[NSNotificationCenter defaultCenter] addObserver:artistsController
                                             selector:@selector(receiveNotification:) 
                                                 name:nil
                                               object:nil];
    UINavigationController* artistsWrapper = [[UINavigationController alloc] initWithRootViewController:artistsController];
    [artistsWrapper.navigationBar setBarStyle:UIBarStyleBlackOpaque];
    
    MainTableViewController *albumsController = [[MainTableViewController alloc] initWithNibName:@"FirstViewController" bundle:nil];
    albumsController.title = NSLocalizedString(@"Albums", @"Albums");
    albumsController.type = @"Albums";
    albumsController.tabBarItem.image = [UIImage imageNamed:@"document"];
    //Add notification listener
    [[NSNotificationCenter defaultCenter] addObserver:albumsController
                                             selector:@selector(receiveNotification:) 
                                                 name:nil
                                               object:nil];
    UINavigationController* albumsWrapper = [[UINavigationController alloc] initWithRootViewController:albumsController];
    [albumsWrapper.navigationBar setBarStyle:UIBarStyleBlackOpaque];
    
    MainTableViewController *songsController = [[MainTableViewController alloc] initWithNibName:@"FirstViewController" bundle:nil];
    songsController.title = NSLocalizedString(@"Songs", @"Songs");
    songsController.type = @"Tracks";
    songsController.tabBarItem.image = [UIImage imageNamed:@"guitar"];
    //Add notification listener
    [[NSNotificationCenter defaultCenter] addObserver:songsController
                                             selector:@selector(receiveNotification:) 
                                                 name:nil
                                               object:nil];
    UINavigationController* songsWrapper = [[UINavigationController alloc] initWithRootViewController:songsController];
    [songsWrapper.navigationBar setBarStyle:UIBarStyleBlackOpaque];
    
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.delegate = self;
    self.tabBarController.viewControllers = [NSArray arrayWithObjects:playlistsWrapper, artistsWrapper, albumsWrapper, songsWrapper, nil];
    
    //Now playing button callbacks
    self.nowPlayingController.backBlock = ^{
        self.window.rootViewController = self.tabBarController;
    };
    self.nowPlayingController.actionBlock = ^{
        [[[UIAlertView alloc] initWithTitle:@"Action" message:@"The Player's action button was pressed." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil] show];
    };
    
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    
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
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
//    if (self.connection != nullptr)
//    {
//        if (!self.connection->isConnected())
//        {
//            if (!self.connection->connectToSocket([self.ipAddress UTF8String], self.port, 100)) {
//                [self displayIpAlert];
//            }
//        }
//    }
}

- (void)remoteConnectTimeout
{
    if (!self.connection->isConnected())
    {
        if (!self.connection->connectToSocket([self.ipAddress UTF8String], self.port, 100)) {
            if (!self.connection->isConnected())
                [self displayIpAlert];
        }
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
    
    delete connection;
}


 // Optional UITabBarControllerDelegate method.
 - (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
 {
     for (int i = 0; i < [self.tabBarController.toolbarItems count]; i++)
     {
         UINavigationController* current = self.tabBarController.toolbarItems[i];
         [current popToRootViewControllerAnimated:TRUE];
     }
 }
 


 // Optional UITabBarControllerDelegate method.
 - (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
 {
     
 }
 

- (void) displayIpAlert
{
//    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"IP Address Required" message:@"Please enter the IP address of the computer running MusicPlayer\n\n\n" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
//    UITextField *ipText;
//    ipText = [[UITextField alloc] init];
//    [ipText setBackgroundColor:[UIColor whiteColor]];
//    ipText.borderStyle = UITextBorderStyleLine;
//    ipText.frame = CGRectMake(30, 95, 220, 30);
//    ipText.font = [UIFont fontWithName:@"ArialMT" size:20];
//    ipText.placeholder = @"Ip Address";
//    ipText.tag = 123;
//    ipText.textAlignment = UITextAlignmentCenter;
//    ipText.keyboardAppearance = UIKeyboardAppearanceAlert;
//    ipText.text = self.ipAddress;
//    [alert addSubview:ipText];
    
// iOS 5.0 only    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ip Address Required" message:@"Please enter the Ip Address of the computer running MusicPlayer" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
    
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    UITextField* ipText = [alert textFieldAtIndex:0];
    ipText.text = self.ipAddress;
    
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
//iOS 4
//        UITextField* ipText = (UITextField*)[alertView viewWithTag:123];
        self.ipAddress = [ipText.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        if (!self.connection->connectToSocket([self.ipAddress UTF8String], self.port, 100)) {
            if (!self.connection->isConnected())
            {
                NSTimer* timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                 target:self
                                               selector:@selector(remoteConnectTimeout)
                                               userInfo:nil
                                                repeats:NO];
                [timer fire];
            }
        }

        
        NSString* connectionMade = @"ConnectionMade";
        self.connection->sendString([connectionMade UTF8String]);
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs setObject:self.ipAddress forKey:@"ipAddress"];
        [prefs synchronize];
    }
}


@end
