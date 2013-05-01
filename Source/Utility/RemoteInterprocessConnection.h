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

/** C++ implementation of the JUCE InterprocessConnection class - Controls connection between the remote and the desktop application */
class RemoteInterprocessConnection  : public InterprocessConnection
{
public:
    /** Constructor */
    RemoteInterprocessConnection ();
    /** Destructor */
    ~RemoteInterprocessConnection();
    
    /** Called when a connection is made */
    void connectionMade();
    /** Displays the IpAlertView when the connection is lost, asking the user to reconnect */
    void connectionLost();
    /** Called when messages are received from the desktop application. Deals with the message updating where required */
    void messageReceived (const MemoryBlock& message);
    /** Wrapper around the sendMessage function that allows a JUCE style string to be sent */
    void sendString(String incomingMessage);
    
    /** Tells the desktop application to play - Called by the nowPlayingViewController */
    void Play();
    /** Tells the desktop application to pause - Called by the nowPlayingViewController */ 
    void Pause();
    /** Tells the desktop application to play the next song - Called by the nowPlayingViewController */
    void Next();
    /** Tells the desktop application to play the previous song - Called by the nowPlayingViewController */
    void Previous();
    
    /** Gets the current album title of the loaded song - Called by RemoteProvider */
    String getAlbumTitle();
    /** Gets the current artist of the loaded song - Called by RemoteProvider */
    String getArtist();
    /** Gets the current song title of the loaded song - Called by RemoteProvider */
    String getSong();
    /** Gets the current length of the loaded song - Called by RemoteProvider */
    double getLength();
    
    /** Changing the playback position being displayed in the NowPlayingViewController */
    void setPosition(double incomingPosition);
    
    /** Returns the number of tracks being displayed in the MusicLibraryTable on the desktop application */
    int getTracksInPlayer();
    /** Returns the number of the currently playing track amongst the tracks being displayed in the MusicLibraryTable on the desktop application */
    int getTrackNum();
    
    /** Gets the volume that has been set by the desktop application */
    double getVolume();
    /** Sets the volume on the desktop application when the volume slider in NowPlayingViewController is moved */
    void setVolume(double incomingVolume);
    
    /** Sets the RemoteProvider class */
    void setProvider (RemoteProvider* incomingProvider);
    /** Sets the NowPlayingViewController */
    void setController (BeamMusicPlayerViewController* viewController);
    
    /** Gets the playlists ValueTree */
    ValueTree getPlaylists();
    /** Gets the library ValueTree */
    ValueTree getLibrary();
    
    /** Gets the currently loaded album cover as a NSMutableData object */
    NSMutableData* getAlbumCover();

    /** Loads the tracks from a named playlist - Though the return is void a NSNotificationCenter notification is sent containing the newly loaded array */
    void getPlaylistTracks(NSString* playlist);
    /** Loads the tracks from a named artist - Though the return is void a NSNotificationCenter notification is sent containing the newly loaded array */
    void getArtistAlbums(NSString* artist);
    /** Loads the tracks from a named album - Though the return is void a NSNotificationCenter notification is sent containing the newly loaded array */
    void getAlbumTracks(NSString* album);
    
    /** Populates the LibraryArrays from the ValueTrees sent by the desktop application */
    void populateArrays();
    /** Returns a pointer to the LibraryArrays */
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
