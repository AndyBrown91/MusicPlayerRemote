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
        
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        connection = appDelegate.connection;
    }
    
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
    return connection->getLength();
}

-(NSInteger)numberOfTracksInPlayer:(BeamMusicPlayerViewController *)player {
    return connection->getTracksInPlayer();
}

-(void)musicPlayer:(BeamMusicPlayerViewController *)player artworkForTrack:(NSUInteger)trackNumber receivingBlock:(BeamMusicPlayerReceivingBlock)receivingBlock {
    NSString* url = @"http://a3.mzstatic.com/us/r1000/045/Features/7f/50/ee/dj.zygromnm.600x600-75.jpg";
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSData* urlData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        
        UIImage* image = [UIImage imageWithData:urlData];
        receivingBlock(image,nil);
    });
}


-(void)musicPlayerDidStartPlaying:(BeamMusicPlayerViewController*)player
{

}

-(BOOL)musicPlayerShouldStartPlaying:(BeamMusicPlayerViewController*)player
{
    
}

-(void)musicPlayerDidStopPlaying:(BeamMusicPlayerViewController*)player
{
    
}

-(void)musicPlayerDidStopPlayingLastTrack:(BeamMusicPlayerViewController*)player
{
    
}


-(BOOL)musicPlayerShouldStopPlaying:(BeamMusicPlayerViewController*)player
{
    
}

-(void)musicPlayer:(BeamMusicPlayerViewController*)player didSeekToPosition:(CGFloat)position
{
    NSLog(@"Seek changed");
}

-(BOOL)musicPlayer:(BeamMusicPlayerViewController*)player shouldChangeTrack:(NSUInteger)track
{
    
}

-(NSInteger)musicPlayer:(BeamMusicPlayerViewController*)player didChangeTrack:(NSUInteger)track
{
    
}

-(void)musicPlayer:(BeamMusicPlayerViewController*)player didChangeVolume:(CGFloat)volume
{
    
}

-(void)musicPlayer:(BeamMusicPlayerViewController*)player didChangeShuffleState:(BOOL)shuffling
{
    
}

-(void)musicPlayer:(BeamMusicPlayerViewController*)player didChangeRepeatMode:(MPMusicRepeatMode)repeatMode
{
    
}

@end
