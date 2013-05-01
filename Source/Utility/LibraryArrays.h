//
//  LibraryArrays.h
//  RemoteStuff
//
//  Created by Andy on 10/03/2013.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
/** TrackItem information class, struct like container for the important information about each track */
@interface TrackItem : NSObject

@property (strong, nonatomic) NSString* trackName;
@property (strong, nonatomic) NSString* artistName;
@property (strong, nonatomic) NSString* albumName;
@property (assign, nonatomic) int libID;
@property (assign, nonatomic) int ID;

@end

/** Struct like container for the Arrays used throughout the application, since they don't change unless the desktop application is updated, they are not deleted until the application closes */
@interface LibraryArrays : NSObject

@property (strong, nonatomic) NSMutableArray* completeLibrary;

@property (strong, nonatomic) NSMutableArray* artistsArray;
@property (strong, nonatomic) NSMutableArray* playlistsArray;
@property (strong, nonatomic) NSMutableArray* albumsArray;
@property (strong, nonatomic) NSMutableArray* songsArray;


@end
