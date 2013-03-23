//
//  RemoteProvider.h
//  MusicPlayerRemote
//
//  Created by Andy on 05/01/2013.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "BeamMusicPlayerViewController.h"

class RemoteInterprocessConnection;

@interface RemoteProvider : NSObject<BeamMusicPlayerDelegate, BeamMusicPlayerDataSource>

@property (nonatomic, assign) bool receiving;

@property (nonatomic, assign) RemoteInterprocessConnection* connection;

@end
