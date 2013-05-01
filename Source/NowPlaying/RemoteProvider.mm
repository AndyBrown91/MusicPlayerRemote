//
//  RemoteProvider.mm
//  MusicPlayerRemote
//
//  Created by Andy on 05/01/2013.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.

#import "RemoteProvider.h"
#import "AppDelegate.h"

/** Data source and delegate for the NowPlayingViewController */
@implementation RemoteProvider

@synthesize receiving = _receiving;
@synthesize connection;

-(id)init {
    self = [super init];
    if ( self ){
        // This HACK hides the volume overlay when changing the volume.
        // It's insipired by http://stackoverflow.com/questions/3845222/iphone-sdk-how-to-disable-the-volume-indicator-view-if-the-hardware-buttons-ar
        MPVolumeView* view = [MPVolumeView new];
        // Put it far offscreen
        view.frame = CGRectMake(1000, 1000, 120, 12);
        [[UIApplication sharedApplication].keyWindow addSubview:view];
    }
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    self.connection = appDelegate.connection;
    
    self.receiving = false;
    
    return self;
}
/** Returns the album for the track currently playing on the desktop application */
-(NSString*)musicPlayer:(BeamMusicPlayerViewController *)player albumForTrack:(NSUInteger)trackNumber {
    NSString* album = (__bridge NSString*)(self.connection->getAlbumTitle().toCFString());
    return album;
}
/** Returns the artist for the track currently playing on the desktop application */
-(NSString*)musicPlayer:(BeamMusicPlayerViewController *)player artistForTrack:(NSUInteger)trackNumber {
    NSString* artist = (__bridge NSString*)(self.connection->getArtist().toCFString());
    return artist;
}
/** Returns the song title for the track currently playing on the desktop application */
-(NSString*)musicPlayer:(BeamMusicPlayerViewController *)player titleForTrack:(NSUInteger)trackNumber {
    NSString* song = (__bridge NSString*)(self.connection->getSong().toCFString());
    return song;
}
/** Returns the length of the track currently playing on the desktop application */
-(CGFloat)musicPlayer:(BeamMusicPlayerViewController *)player lengthForTrack:(NSUInteger)trackNumber {
    return (CGFloat)(self.connection->getLength());
}
/** Returns the volume of the desktop application */
-(CGFloat)providerVolume:(BeamMusicPlayerViewController *)player {
    return (CGFloat)(self.connection->getVolume());
}
/** Returns the number of tracks in the list being played on the desktop */
-(NSInteger)numberOfTracksInPlayer:(BeamMusicPlayerViewController *)player {
    return (NSInteger)(self.connection->getTracksInPlayer());
}
/** Returns the currently playing tracks number in the playing list */
-(NSInteger)currentNumberOfTrackInPlayer:(BeamMusicPlayerViewController *)player {
    return (NSInteger)(self.connection->getTrackNum());
}
/** Loads the album art asynchronously */
-(void)musicPlayer:(BeamMusicPlayerViewController *)player artworkForTrack:(NSUInteger)trackNumber receivingBlock:(BeamMusicPlayerReceivingBlock)receivingBlock {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{     
        UIImage* image = [UIImage imageWithData:self.connection->getAlbumCover()];
        receivingBlock(image,nil);
    });
}

/** Called when the nowPlayingViewController begins playing */
-(void)musicPlayerDidStartPlaying:(BeamMusicPlayerViewController*)player
{
    if(!self.receiving)
    {
       //if(!player.playing)
           self.connection->Play();
    }
}
/** Called when the user presses pause on the NowPlayingViewController */
-(void)musicPlayerDidStopPlaying:(BeamMusicPlayerViewController*)player
{
    if (!self.receiving)
        self.connection->Pause();
}
/** Called when the user moves the position slider on the NowPlayingViewController */
-(void)musicPlayer:(BeamMusicPlayerViewController*)player didSeekToPosition:(CGFloat)position
{
    self.connection->setPosition((float)position);
}

/** Called when the user presses next or previous on the NowPlayingViewController */
-(NSInteger)musicPlayer:(BeamMusicPlayerViewController*)player didChangeTrack:(NSUInteger)track
{
    if (track > [self currentNumberOfTrackInPlayer:player]) {
        self.connection->Next();
    }
    else
        self.connection->Previous();
    return track;
}
/** Called when the user moves the volume slider on the NowPlayingViewController */
-(void)musicPlayer:(BeamMusicPlayerViewController*)player didChangeVolume:(CGFloat)volume
{
    self.connection->setVolume((float)volume); 
}


@end
