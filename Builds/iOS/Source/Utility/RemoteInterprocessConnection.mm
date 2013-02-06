//
//  RemoteInterprocessConnection.cpp
//  MusicPlayer
//
//  Created by Andy on 28/12/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#include "RemoteInterprocessConnection.h"
#include "AppDelegate.h"

RemoteInterprocessConnection::RemoteInterprocessConnection () : InterprocessConnection(false)
{
    //remoteNumConnections++;
}

RemoteInterprocessConnection::~RemoteInterprocessConnection()
{
    
}

void RemoteInterprocessConnection::connectionMade()
{
//    String connectionMade ("ConnectionMade");
//    MemoryBlock messageData (connectionMade.toUTF8(), (size_t) connectionMade.getNumBytesAsUTF8());
//    sendMessage(messageData);
}

void RemoteInterprocessConnection::connectionLost()
{
    DBG("Connection # - connection lost");
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    [appDelegate performSelectorOnMainThread:@selector(displayIpAlert) withObject:nil waitUntilDone:YES];
    
    //remoteNumConnections--;
}

void RemoteInterprocessConnection::messageReceived (const MemoryBlock& message)
{    
    if (recievingArt) {
        //Incoming block is album art
        recievingArt = false;
        artData = [NSMutableData alloc];
        [artData resetBytesInRange:NSMakeRange(0, [artData length])];
        artData = [NSMutableData dataWithBytes:message.getData() length:(NSUInteger)message.getSize()];
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
            controller.currentTrack = trackNum;
            [controller performSelectorOnMainThread:@selector(updateTrackDisplay) withObject:nil waitUntilDone:NO];
        }
        else if (stringMessage.startsWith("Position")) {
            position = (stringMessage.fromFirstOccurrenceOf("Position: ", false, true)).getDoubleValue();
            if (controller != nil)
            {
                controller.currentPlaybackPosition = static_cast<CGFloat>(position);
                [controller performSelectorOnMainThread:@selector(updateSeekUI) withObject:nil waitUntilDone:NO];
            }
        }
        else if (stringMessage.startsWith("Volume")) {
            volume = (stringMessage.fromFirstOccurrenceOf("Volume: ", false, true)).getDoubleValue();
            
            //controller.volume = static_cast<CGFloat>(volume);
            [controller setVolume:static_cast<CGFloat>(volume)];
        }
        else if (stringMessage.startsWith("PlayState")) {
            playState = static_cast<bool>((stringMessage.fromFirstOccurrenceOf("PlayState: ", false, true)).getIntValue());
           
            if (playState)
            {
                remoteProvider.receiving = true;
                [controller performSelectorOnMainThread:@selector(play) withObject:nil waitUntilDone:NO];
                remoteProvider.receiving = false;
            }
            else
            {
                remoteProvider.receiving = true;
                [controller performSelectorOnMainThread:@selector(pause) withObject:nil waitUntilDone:NO];
                remoteProvider.receiving = false;
            }
        }
        else if (stringMessage.startsWith("AlbumArt"))
        {
            String artType = stringMessage.fromFirstOccurrenceOf("AlbumArt: ", false, true);
            
            if (artType.equalsIgnoreCase("jpeg"))
            {
                albumArtType = @"jpeg";
            }
            else if (artType.equalsIgnoreCase("png"))
            {
                albumArtType = @"png";
            }

            recievingArt = true;
        }
        
        else if (stringMessage.startsWith("NewTrack"))
        {
            [controller performSelectorOnMainThread:@selector(updateUI) withObject:nil waitUntilDone:NO];
        }
            
    }
    DBG("Message received " + message.toString());
}

void RemoteInterprocessConnection::sendString(String incomingMessage)
{
    MemoryBlock messageData (incomingMessage.toUTF8(), (size_t) incomingMessage.getNumBytesAsUTF8());
    sendMessage(messageData);
}

//CONTROLS
void RemoteInterprocessConnection::Play()
{
    sendString("Play");
}

void RemoteInterprocessConnection::Pause()
{
    sendString("Pause");
}

void RemoteInterprocessConnection::Next()
{
    sendString("Next");
}

void RemoteInterprocessConnection::Previous()
{
    sendString("Previous");
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

NSMutableData* RemoteInterprocessConnection::getAlbumCover()
{
    return artData;
}

void RemoteInterprocessConnection::setProvider(RemoteProvider *incomingProvider)
{
    remoteProvider = incomingProvider;
}

void RemoteInterprocessConnection::setController (BeamMusicPlayerViewController* incomingController)
{
    controller = incomingController;
}
