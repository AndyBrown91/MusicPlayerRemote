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
    recievingArt = recievingLibrary = recievingPlaylists = false;
    libraryArrays = [LibraryArrays new];
}

RemoteInterprocessConnection::~RemoteInterprocessConnection()
{
    
}

void RemoteInterprocessConnection::connectionMade()
{
    DBG("Connection # - connection made");
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
    else if (recievingLibrary)
    {
        recievingLibrary = false;
        library = ValueTree::readFromData(message.getData(), message.getSize());
    }
    else if (recievingPlaylists)
    {
        recievingPlaylists = false;
        playlists = ValueTree::readFromData(message.getData(), message.getSize());
        
        populateArrays();
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
        
        else if (stringMessage.startsWith("Playlists"))
        {
            recievingPlaylists = true;
        }
        
        else if (stringMessage.startsWith("Library"))
        {
            recievingLibrary = true;
        }
        
        else if (stringMessage.startsWith("NewTrack"))
        {
            [controller performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
        }
        
    }
    //DBG("Message received " + message.toString());
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

void RemoteInterprocessConnection::populateArrays()
{
    if (playlists.isValid() && library.isValid()) {
        //Check to stop crashes with empty librarys, searching for object at empty index
        if (library.getNumChildren() > 0)
        {
            libraryArrays.completeLibrary = [NSMutableArray new];
            
            for (int i = 0; i < library.getNumChildren(); i++) {
                TrackItem* currentTrack = [TrackItem new];
                currentTrack.artistName = (__bridge NSString*) (library.getChild(i).getProperty("Artist").toString().toCFString());
                currentTrack.trackName = (__bridge NSString*) (library.getChild(i).getProperty("Song").toString().toCFString());
                currentTrack.albumName = (__bridge NSString*) (library.getChild(i).getProperty("Album").toString().toCFString());
                currentTrack.libID = (int) (library.getChild(i).getProperty("LibID"));
                currentTrack.ID = (int) (library.getChild(i).getProperty("ID"));
                [libraryArrays.completeLibrary addObject:currentTrack];
            }
            
            libraryArrays.artistsArray = [NSMutableArray new];
            libraryArrays.albumsArray = [NSMutableArray new];
            libraryArrays.songsArray = [NSMutableArray new];
            
            for (int i = 0; i < [libraryArrays.completeLibrary count]; i++) {
                TrackItem* currentTrack = [libraryArrays.completeLibrary objectAtIndex:i];
                
                NSInteger artistIndex = [libraryArrays.artistsArray indexOfObject:currentTrack.artistName];
                if(NSNotFound == artistIndex) {
                    [libraryArrays.artistsArray addObject:currentTrack.artistName];
                }
                
                NSInteger albumIndex = [libraryArrays.albumsArray indexOfObject:currentTrack.albumName];
                if(NSNotFound == albumIndex) {
                    [libraryArrays.albumsArray addObject:currentTrack.albumName];
                }
                
                [libraryArrays.songsArray addObject:currentTrack.trackName];
            }

            libraryArrays.playlistsArray = [NSMutableArray new];
            
            for (int i = 0; i < playlists.getNumChildren(); i++) {
                ValueTree currentPlaylist = playlists.getChild(i);
                String name = currentPlaylist.getProperty("Name");
                //DBG(name);
                if (name != "Library") {
                    NSString* nsName = (__bridge NSString*) (name.toCFString());
                    [libraryArrays.playlistsArray addObject:nsName];
                }
            }
            
            [libraryArrays.artistsArray sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
            [libraryArrays.albumsArray sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
            [libraryArrays.songsArray sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ValueTreesLoaded" 
                                                                object:nil];
        }
    }
    else
        DBG("NOT loaded valuetree");
}

LibraryArrays* RemoteInterprocessConnection::getArrays()
{
    return libraryArrays;
}

void RemoteInterprocessConnection::getPlaylistTracks(NSString* playlist)
{
    playlistTracks = [NSMutableArray new];
    String playlistToFind = [playlist UTF8String];
    ValueTree currentPlaylist = playlists.getChildWithProperty("Name", playlistToFind);
    
    if (currentPlaylist.isValid()) 
    {
        ValueTree trackInfo = currentPlaylist.getChildWithName("TrackInfo");
        if (trackInfo.isValid())
        {
            for (int i = 0; i < trackInfo.getNumChildren(); i++) {
                ValueTree currentTrack = trackInfo.getChild(i);
                
                NSString* details = (__bridge NSString*)((currentTrack.getProperty("Song").toString()+" - "+currentTrack.getProperty("Artist").toString()).toCFString());
                [playlistTracks addObject:details];
            }
        }
    }
    
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:playlistTracks forKey:@"playlistTracks"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ArrayLoaded" 
                                                        object:nil
                                                      userInfo:userInfo];
}

void RemoteInterprocessConnection::getArtistAlbums (NSString *artist)
{
    artistAlbumsArray = [NSMutableArray new];
    
    for (int i = 0; i < [libraryArrays.completeLibrary count]; i++)
    {
        TrackItem* currentTrack = [libraryArrays.completeLibrary objectAtIndex:i];
        
        if ([currentTrack.artistName isEqualToString:artist])
        {
            NSInteger albumIndex = [artistAlbumsArray indexOfObject:currentTrack.albumName];
            if(NSNotFound == albumIndex) {
                [artistAlbumsArray addObject:currentTrack.albumName];
            }
        }
    }
    
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:artistAlbumsArray forKey:@"artistAlbums"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ArrayLoaded" 
                                                        object:nil
                                                        userInfo:userInfo];
}

void RemoteInterprocessConnection::getAlbumTracks(NSString* album)
{
    albumTracks = [NSMutableArray new];
    
    for (int i = 0; i < [libraryArrays.completeLibrary count]; i++)
    {
        TrackItem* currentTrack = [libraryArrays.completeLibrary objectAtIndex:i];
        
        if ([currentTrack.albumName isEqualToString:album])
        {
            [albumTracks addObject:currentTrack.trackName];
        }
    }
    
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:albumTracks forKey:@"albumTracks"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ArrayLoaded" 
                                                        object:nil
                                                      userInfo:userInfo];
}

void RemoteInterprocessConnection::setProvider(RemoteProvider *incomingProvider)
{
    remoteProvider = incomingProvider;
}

void RemoteInterprocessConnection::setController (BeamMusicPlayerViewController* incomingController)
{
    controller = incomingController;
}
