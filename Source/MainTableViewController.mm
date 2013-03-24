//
//  MasterViewController.m
//  stuff
//
//  Created by Andy on 10/03/2013.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "MainTableViewController.h"

#import "DetailViewController.h"

@implementation MainTableViewController

@synthesize detailViewController = _detailViewController;
@synthesize tableData = _tableData;

@synthesize currentTable;
@synthesize libraryArrays;

@synthesize type = _type;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *nowPlayingButton = [[UIBarButtonItem alloc] initWithTitle:@"Now Playing" style:UIBarButtonItemStylePlain target:self action:@selector(showNowPlaying)]; 
    
    self.navigationItem.rightBarButtonItem = nowPlayingButton;

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
    if (self.title == @"Playlists") {
        [self.tableData performSelectorOnMainThread:@selector(setArray:) withObject:libraryArrays.playlistsArray waitUntilDone:NO];
    }
    else if (self.title == @"Artists")
    {
        [self.tableData performSelectorOnMainThread:@selector(setArray:) withObject:libraryArrays.artistsArray waitUntilDone:NO];
    }
    else if (self.title == @"Albums")
    {
        [self.tableData performSelectorOnMainThread:@selector(setArray:) withObject:libraryArrays.albumsArray waitUntilDone:NO];
    }
    else if (self.title == @"Songs")
    {
        [self.tableData performSelectorOnMainThread:@selector(setArray:) withObject:libraryArrays.songsArray waitUntilDone:NO];
    }
    
    [currentTable performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    
    [super viewWillAppear:animated];
    
    NSLog(@"Title = %@", self.title);
    NSLog(@"Type = %@", self.type);
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    currentTable = tableView;
    
    return [self.tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *tableIdentifier = @"TableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableIdentifier];
    }
    
    cell.textLabel.text = [self.tableData objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    NSString* selectedRow = [self.tableData objectAtIndex:[indexPath row]];
    
    if (self.type == @"Tracks" || self.type == @"Playlist")
    {
        NSString* playString = @"PlayTrack ";
        NSString* sendString;
        
        if (self.type == @"Playlist") {
            NSScanner* scanner = [NSScanner scannerWithString:selectedRow];
            [scanner scanUpToString:@" -" intoString:&selectedRow];
            playString = [NSString stringWithFormat:@"PlaylistTrack %@ ID=", self.title];
        }
        
        for (int i = 0; i < [libraryArrays.completeLibrary count]; i++)
        {
            TrackItem* checkSong = [libraryArrays.completeLibrary objectAtIndex:i];
            
            if ([checkSong.trackName isEqualToString:selectedRow])
            {
                NSString* trackID;
                if (self.type == @"Playlist")
                    trackID = [NSString stringWithFormat:@"%d", checkSong.ID];
                else
                    trackID = [NSString stringWithFormat:@"%d", checkSong.libID];
                sendString = [playString stringByAppendingString:trackID];
            }
        }

        app.connection->sendString([sendString UTF8String]);
        NSLog(@"%@", sendString);
        [self showNowPlaying];
    }
    else
    {   
        if (self.detailViewController == nil)
        {
            self.detailViewController = [[MainTableViewController alloc] initWithNibName:@"FirstViewController" bundle:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self.detailViewController
                                                     selector:@selector(receiveNotification:) 
                                                         name:nil
                                                       object:nil];
        }
        
        self.detailViewController.title = selectedRow;
        //    }
        
        if (self.type == @"Artists")
        {
            self.detailViewController.type = @"Albums";
            app.connection->getArtistAlbums(selectedRow);
        }
        else if (self.type == @"Albums")
        {
            self.detailViewController.type = @"Tracks";
            app.connection->getAlbumTracks(selectedRow);
        }
        
        else if (self.type == @"Playlists")
        {
            self.detailViewController.type = @"Playlist";
            app.connection->getPlaylistTracks(selectedRow);
        }
    }
}

- (void)showNowPlaying
{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    //[app.nav pushViewController:app.nowPlayingController animated:YES];
    [app.nowPlayingController setVolume:static_cast<CGFloat>(app.connection->getVolume())];
    
    app.nowPlayingController.shouldHideNextTrackButtonAtBoundary = YES;
    app.nowPlayingController.shouldHidePreviousTrackButtonAtBoundary = YES;
    
    app.nowPlayingController.dataSource = app.remoteProvider;
    app.nowPlayingController.delegate = app.remoteProvider;
    
    [app.nowPlayingController performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    //[app.nowPlayingController adjustPlayButtonState];
    [app.nowPlayingController performSelectorOnMainThread:@selector(adjustPlayButtonState) withObject:nil waitUntilDone:NO];
    
    app.window.rootViewController = app.nowPlayingController;
}



- (void)receiveNotification:(NSNotification*) notification
{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    self.libraryArrays = app.connection->getArrays();
    
    if ([[notification name] isEqualToString:@"ValueTreesLoaded"])
    {
        self.tableData = [NSMutableArray new];
        
        if (self.title == @"Playlists") {
            [self.tableData performSelectorOnMainThread:@selector(setArray:) withObject:libraryArrays.playlistsArray waitUntilDone:NO];
        }
        else if (self.title == @"Artists")
        {
            NSLog(@"Loading artist info on %@ of type %@", self.title, self.type);
            [self.tableData performSelectorOnMainThread:@selector(setArray:) withObject:libraryArrays.artistsArray waitUntilDone:NO];
        }
        else if (self.title == @"Albums")
        {
            [self.tableData performSelectorOnMainThread:@selector(setArray:) withObject:libraryArrays.albumsArray waitUntilDone:NO];
        }
        else if (self.title == @"Songs")
        {
            [self.tableData performSelectorOnMainThread:@selector(setArray:) withObject:libraryArrays.songsArray waitUntilDone:NO];
        }

        [currentTable performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    }
    
    if ([[notification name] isEqualToString:@"ArrayLoaded"])
    {
        //Makes sure all objects of type MainTableViewController can recieve the same notification but they will only do something if the correct array is coming in
        NSDictionary* userInfo = notification.userInfo;
        NSArray* keyArray = [userInfo allKeys];
        NSString* key = [keyArray objectAtIndex:0];

        NSMutableArray* incomingArray = [userInfo objectForKey:key];
        
        if (key == @"artistAlbums" && self.type == @"Artists")
        {
            [self displayDetailView:incomingArray];
        }
        else if (key == @"albumTracks" && self.type == @"Albums")
        {
            [self displayDetailView:incomingArray];
        }
        else if (key == @"playlistTracks" && self.type == @"Playlists")
        {
            [self displayDetailView:incomingArray];
        }
    }
}

- (void) displayDetailView:(NSMutableArray*) incomingArray
{
    self.detailViewController.tableData = [NSMutableArray new];
    self.detailViewController.libraryArrays = self.libraryArrays;
    [self.detailViewController.tableData setArray:incomingArray];
    [self.navigationController pushViewController:self.detailViewController animated:YES];
}

@end
