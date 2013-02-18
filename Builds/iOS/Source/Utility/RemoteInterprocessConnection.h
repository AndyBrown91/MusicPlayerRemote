//
//  RemoteInterprocessConnection.h
//  MusicPlayer
//
//  Created by Andy on 28/12/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#ifndef REMOTEINTERPROCESSCONNECTION
#define REMOTEINTERPROCESSCONNECTION 

#include "../JuceLibraryCode/JuceHeader.h"
//
#include "RemoteProvider.h"
#include "BeamMusicPlayerViewController.h"

class RemoteInterprocessConnection  : public InterprocessConnection
{
public:
    RemoteInterprocessConnection ();
    ~RemoteInterprocessConnection();
    
    void connectionMade();
    void connectionLost();
    void messageReceived (const MemoryBlock& message);
    void sendString(String incomingMessage);
    
    void Play();
    void Pause();
    void Next();
    void Previous();
    
    String getAlbumTitle();
    String getArtist();
    String getSong();
    double getLength();
    
    void setPosition(double incomingPosition);
    
    int getTracksInPlayer();
    int getTrackNum();
    
    double getVolume();
    void setVolume(double incomingVolume);
    
    void setProvider (RemoteProvider* incomingProvider);
    void setController (BeamMusicPlayerViewController* viewController);
    
    NSMutableData* getAlbumCover();
//    void setRemoteProvider(RemoteProvider provider);
    
private:
    String albumTitle, artist;
    char dummy1[4096];
    String song;
    char dummy2[4096];
    int tracksTotal, trackNum;
    double length, volume, position;
    
    NSString* albumArtType;
    NSMutableData* artData;
    
    bool recievingArt, playState;
    
    RemoteProvider* remoteProvider;
    BeamMusicPlayerViewController* controller;
};


#endif
