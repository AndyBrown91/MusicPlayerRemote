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
//#include "RemoteControl.h"
//#include "Settings.h"
//#include "MusicLibraryHelpers.h"

class RemoteInterprocessConnection  : public InterprocessConnection
{
public:
    RemoteInterprocessConnection ();
    ~RemoteInterprocessConnection();
    
    void connectionMade();
    void connectionLost();
    void messageReceived (const MemoryBlock& message);
    void sendString(String incomingMessage);
    
    String getAlbumTitle();
    String getArtist();
    String getSong();
    float getLength();
    
    int getPosition();
    void setPosition(int incomingPosition);
    
    int getTracksInPlayer();
    int getTrackNum();
    
    float getVolume();
    void setVolume(float incomingVolume);
    
    Image getAlbumArt();
    
private:
    String albumTitle, artist, song;
    int tracksTotal, trackNum, position;
    float length;
    float volume;
    Image albumArt;
    
    bool recievingArt, playState;
};


#endif
