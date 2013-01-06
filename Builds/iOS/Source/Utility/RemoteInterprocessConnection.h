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
    int getLength();
    
    int getPosition();
    void setPosition(int incomingPosition);
    
    int getTracksInPlayer();
    float getVolume();
    Image getAlbumArt();
    
private:
    String albumTitle, artist, song;
    int tracksTotal, length, position;
    float volume;
    Image albumArt;
    
    bool recievingArt, playState;
};


#endif
