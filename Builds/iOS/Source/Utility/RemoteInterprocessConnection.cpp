//
//  RemoteInterprocessConnection.cpp
//  MusicPlayer
//
//  Created by Andy on 28/12/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#include "RemoteInterprocessConnection.h"

RemoteInterprocessConnection::RemoteInterprocessConnection () : InterprocessConnection(false)
{
    //remoteNumConnections++;
}

RemoteInterprocessConnection::~RemoteInterprocessConnection()
{
    
}

void RemoteInterprocessConnection::connectionMade()
{
    String connectionMade ("ConnectionMade");
    MemoryBlock messageData (connectionMade.toUTF8(), (size_t) connectionMade.getNumBytesAsUTF8());
    sendMessage(messageData);
}

void RemoteInterprocessConnection::connectionLost()
{
    DBG("Connection # - connection lost");
    //remoteNumConnections--;
}

void RemoteInterprocessConnection::messageReceived (const MemoryBlock& message)
{    
    if (recievingArt) {
        //Incoming block is album art
        
        recievingArt = false;
    }
    else
    {
        String stringMessage = message.toString();
        
        if (stringMessage.startsWith("Artist")) {
            artist = stringMessage.fromFirstOccurrenceOf("Artist: ", false, true);
        }
        else if (stringMessage.startsWith("AlbumTitle")) {
            albumTitle = stringMessage.fromFirstOccurrenceOf("AlbumTitle: ", false, true);
        }
        else if (stringMessage.startsWith("Song")) {
            song = stringMessage.fromFirstOccurrenceOf("Song: ", false, true);
        }
        else if (stringMessage.startsWith("Length")) {
            length = (stringMessage.fromFirstOccurrenceOf("Length: ", false, true)).getDoubleValue();
        }
        else if (stringMessage.startsWith("TracksTotal")) {
            tracksTotal = (stringMessage.fromFirstOccurrenceOf("TracksTotal: ", false, true)).getIntValue();
        }
        else if (stringMessage.startsWith("TrackNum")) {
            trackNum = (stringMessage.fromFirstOccurrenceOf("TrackNum: ", false, true)).getIntValue();
        }
        else if (stringMessage.startsWith("Position")) {
            position = (stringMessage.fromFirstOccurrenceOf("Position: ", false, true)).getDoubleValue();
        }
        else if (stringMessage.startsWith("Volume")) {
            volume = (stringMessage.fromFirstOccurrenceOf("Volume: ", false, true)).getDoubleValue();
        }
        else if (stringMessage.startsWith("PlayState")) {
            playState = static_cast<bool>((stringMessage.fromFirstOccurrenceOf("PlayState: ", false, true)).getIntValue());
        }
        else if (stringMessage.startsWith("AlbumArt"))
        {
            recievingArt = true;
        }
        else if (stringMessage.startsWith("NewTrack"))
        {
            
        }
            
    }
    DBG("Message received " + message.toString());
}

void RemoteInterprocessConnection::sendString(String incomingMessage)
{
    MemoryBlock messageData (incomingMessage.toUTF8(), (size_t) incomingMessage.getNumBytesAsUTF8());
    sendMessage(messageData);
}

String RemoteInterprocessConnection::getAlbumTitle()
{    
    return albumTitle;
}
String RemoteInterprocessConnection::getArtist()
{    
    return artist;
}
String RemoteInterprocessConnection::getSong()
{    
    return song;
}

double RemoteInterprocessConnection::getLength()
{
    return length;
}
int RemoteInterprocessConnection::getPosition()
{
    return position;
}
void RemoteInterprocessConnection::setPosition(double incomingPosition)
{
    position = incomingPosition;
    sendString("Position: " + String(position));
}
int RemoteInterprocessConnection::getTracksInPlayer()
{
    return tracksTotal;
}
int RemoteInterprocessConnection::getTrackNum()
{
    return trackNum;
}
double RemoteInterprocessConnection::getVolume()
{
    return volume;
}
void RemoteInterprocessConnection::setVolume(double incomingVolume)
{
    volume = incomingVolume;
    sendString("Volume: " + String(volume));
}
Image RemoteInterprocessConnection::getAlbumArt()
{
    return albumArt;
}
