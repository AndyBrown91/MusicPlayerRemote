//
//  SecondViewController.m
//  Stuff
//
//  Created by Andy on 08/03/2013.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "SecondViewController.h"
#import "AppDelegate.h"

@implementation SecondViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Detail", @"Detail");
    }
    return self;
}
							
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
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)showNowPlaying:(id)sender {
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    //[app.nav pushViewController:app.nowPlayingController animated:YES];
    [app.nowPlayingController setVolume:static_cast<CGFloat>(app.connection->getVolume())];
    
    app.nowPlayingController.shouldHideNextTrackButtonAtBoundary = YES;
    app.nowPlayingController.shouldHidePreviousTrackButtonAtBoundary = YES;
    
    //    [self.viewController play];
    app.nowPlayingController.dataSource = app.remoteProvider;
    app.nowPlayingController.delegate = app.remoteProvider;
    [app.nowPlayingController adjustPlayButtonState];
    
    [app.nowPlayingController performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    
    app.window.rootViewController = app.nowPlayingController;
}

@end
