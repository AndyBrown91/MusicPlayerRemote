//
//  NowPlayingViewController.h
//  MusicPlayerRemote
//
//  Created by Andy on 31/12/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BeamMusicPlayerViewController.h"
#import "BeamMPMusicPlayerProvider.h"
#import "BeamMinimalExampleProvider.h"
#import "RemoteProvider.h"

class RemoteInterprocessConnection;

@class BeamMusicPlayerViewController;

@interface NowPlayingViewController : UIViewController <BeamMusicPlayerDelegate>
{
    RemoteInterprocessConnection* connection;
    BeamMusicPlayerViewController *viewController;
}
@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) BeamMusicPlayerViewController *viewController;
@property (strong, nonatomic) id<BeamMusicPlayerDataSource,BeamMusicPlayerDelegate> exampleProvider;


@end
