//
//  RemoteProvider.h
//  MusicPlayerRemote
//
//  Created by Andy on 05/01/2013.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "BeamMusicPlayerViewController.h"
#import "../JuceLibraryCode/JuceHeader.h"

//#import "RemoteInterprocessConnection.h"

class RemoteInterprocessConnection;

@interface RemoteProvider : NSObject<BeamMusicPlayerDelegate, BeamMusicPlayerDataSource>
{
    RemoteInterprocessConnection* connection;
}
@property (nonatomic, assign) bool receiving;
@property (nonatomic,strong) MPMusicPlayerController* musicPlayer; // An instance of an ipod music player
@property (nonatomic,strong) BeamMusicPlayerViewController* controller; // the BeamMusicPlayerViewController
//@property (nonatomic,copy) NSArray *mediaItems;

@end
