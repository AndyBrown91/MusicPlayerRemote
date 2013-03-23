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
#include "LibraryArrays.h"


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
    
    ValueTree getPlaylists();
    ValueTree getLibrary();
    
    NSMutableData* getAlbumCover();

    void getPlaylistTracks(NSString* playlist);
    void getArtistAlbums(NSString* artist);
    void getAlbumTracks(NSString* album);
    
    void populateArrays();
    LibraryArrays* getArrays();
    
private:
    String albumTitle, artist;
    char dummy1[4096];
    String song;
    char dummy2[4096];
    int tracksTotal, trackNum;
    double length, volume, position;
    
    ValueTree playlists, library;
    
    NSString* albumArtType;
    NSMutableData* artData;
    
    NSMutableArray* playlistTracks;
    NSMutableArray* artistAlbumsArray;
    NSMutableArray* albumTracks;
    
    LibraryArrays* libraryArrays;
    
    bool recievingArt, recievingPlaylists, recievingLibrary, playState;
    
    RemoteProvider* remoteProvider;
    BeamMusicPlayerViewController* controller;
};


#endif
