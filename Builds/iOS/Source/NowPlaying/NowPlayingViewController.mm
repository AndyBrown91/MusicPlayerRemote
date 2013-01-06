//
//  NowPlayingViewController.m
//  MusicPlayerRemote
//
//  Created by Andy on 31/12/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NowPlayingViewController.h"

@implementation NowPlayingViewController

@synthesize window = _window;
@synthesize viewController = _viewController;
@synthesize exampleProvider;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.viewController = [BeamMusicPlayerViewController new];
    self.viewController.backBlock = ^{
        NSLog(@"Back Pressed");
        //self.window.rootViewController = nil;
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
        UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"TabBarController"];
        vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        //[self presentViewController:vc animated:YES completion:NULL];
        self.window.rootViewController = vc;
        [self.window makeKeyAndVisible];

    };
    
    self.viewController.actionBlock = ^{
        [[[UIAlertView alloc] initWithTitle:@"Action" message:@"The Player's action button was pressed." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil] show];
    };
    
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    
#if TARGET_IPHONE_SIMULATOR
    self.exampleProvider = [BeamMinimalExampleProvider new];
    
    self.viewController.dataSource = self.exampleProvider;
    self.viewController.delegate = self.exampleProvider;
    [self.viewController reloadData];
#else
    BeamMPMusicPlayerProvider *mpMusicPlayerProvider = [BeamMPMusicPlayerProvider new];
    mpMusicPlayerProvider.controller = self.viewController;
    NSAssert(self.viewController.delegate == mpMusicPlayerProvider, @"setController: sets itself as delegate");
    NSAssert(self.viewController.dataSource == mpMusicPlayerProvider, @"setController: sets itself as datasource");
    
    mpMusicPlayerProvider.musicPlayer = [MPMusicPlayerController iPodMusicPlayer];
    
    MPMediaQuery *mq = [MPMediaQuery songsQuery];
    [MPMusicPlayerController.iPodMusicPlayer setQueueWithQuery:mq];
    mpMusicPlayerProvider.mediaItems = mq.items;
    self.exampleProvider = mpMusicPlayerProvider;
    //    mpMusicPlayerProvider.musicPlayer.nowPlayingItem = [mpMusicPlayerProvider.mediaItems objectAtIndex:mpMusicPlayerProvider.mediaItems.count-3];
    mpMusicPlayerProvider.musicPlayer.nowPlayingItem = [mpMusicPlayerProvider.mediaItems objectAtIndex:2];
    
#endif
    
    self.viewController.shouldHideNextTrackButtonAtBoundary = YES;
    self.viewController.shouldHidePreviousTrackButtonAtBoundary = YES;
    
    [self.viewController play];
//    return YES;

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

@end
