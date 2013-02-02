//
//  RemoteProvider.mm
//  MusicPlayerRemote
//
//  Created by Andy on 05/01/2013.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.

#import "RemoteProvider.h"
#import "AppDelegate.h"

@implementation RemoteProvider

@synthesize musicPlayer;
@synthesize controller;
@synthesize receiving;
//@synthesize mediaItems;

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
    connection = appDelegate.connection;
    
    receiving = false;
    
    return self;
}

-(NSString*)musicPlayer:(BeamMusicPlayerViewController *)player albumForTrack:(NSUInteger)trackNumber {
    NSString* album = (NSString*)(connection->getAlbumTitle().toCFString());
    return album;
}

-(NSString*)musicPlayer:(BeamMusicPlayerViewController *)player artistForTrack:(NSUInteger)trackNumber {
    NSString* artist = (NSString*)(connection->getArtist().toCFString());
    return artist;
}

-(NSString*)musicPlayer:(BeamMusicPlayerViewController *)player titleForTrack:(NSUInteger)trackNumber {
    NSString* song = (NSString*)(connection->getSong().toCFString());
    return song;
}

-(CGFloat)musicPlayer:(BeamMusicPlayerViewController *)player lengthForTrack:(NSUInteger)trackNumber {
    return (CGFloat)(connection->getLength());
}

-(NSInteger)numberOfTracksInPlayer:(BeamMusicPlayerViewController *)player {
    return (NSInteger)(connection->getTracksInPlayer());
}

-(NSInteger)currentNumberOfTrackInPlayer:(BeamMusicPlayerViewController *)player {
    return (NSInteger)(connection->getTrackNum());
}

-(void)musicPlayer:(BeamMusicPlayerViewController *)player artworkForTrack:(NSUInteger)trackNumber receivingBlock:(BeamMusicPlayerReceivingBlock)receivingBlock {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{     
        UIImage* image = [UIImage imageWithData:connection->getAlbumCover()];
        receivingBlock(image,nil);
    });
}


-(void)musicPlayerDidStartPlaying:(BeamMusicPlayerViewController*)player
{
    if(!receiving)
    {
       if(!controller.playing)
       connection->Play();
    }
}

-(BOOL)musicPlayerShouldStartPlaying:(BeamMusicPlayerViewController*)player
{

}

-(void)musicPlayerDidStopPlaying:(BeamMusicPlayerViewController*)player
{
    if (!receiving)
    connection->Pause();
}

-(void)musicPlayerDidStopPlayingLastTrack:(BeamMusicPlayerViewController*)player
{
    NSLog(@"Did stop Final");
}

-(BOOL)musicPlayerShouldStopPlaying:(BeamMusicPlayerViewController*)player
{
    NSLog(@"should stop");
}

-(void)musicPlayer:(BeamMusicPlayerViewController*)player didSeekToPosition:(CGFloat)position
{
    connection->setPosition((float)position);
}

-(BOOL)musicPlayer:(BeamMusicPlayerViewController*)player shouldChangeTrack:(NSUInteger)track
{
    //
}

-(NSInteger)musicPlayer:(BeamMusicPlayerViewController*)player didChangeTrack:(NSUInteger)track
{
    if (track > [self currentNumberOfTrackInPlayer:controller]) {
        connection->Next();
    }
    else
        connection->Previous();
    return track;
}

-(void)musicPlayer:(BeamMusicPlayerViewController*)player didChangeVolume:(CGFloat)volume
{
    connection->setVolume((float)volume); 
}

-(void)musicPlayer:(BeamMusicPlayerViewController*)player didChangeShuffleState:(BOOL)shuffling
{
    
}

-(void)musicPlayer:(BeamMusicPlayerViewController*)player didChangeRepeatMode:(MPMusicRepeatMode)repeatMode
{
    
}

@end
