//
//  BeamMinimalExampleProvider.m
//  Part of BeamMusicPlayerViewController (license: New BSD)
//  -> https://github.com/BeamApp/MusicPlayerViewController
//
//  Created by Moritz Haarmann on 01.06.12.
//  Copyright (c) 2012 BeamApp UG. All rights reserved.
//

#import "BeamMinimalExampleProvider.h"

@implementation BeamMinimalExampleProvider

-(NSString*)musicPlayer:(BeamMusicPlayerViewController *)player albumForTrack:(NSUInteger)trackNumber {
    return @"Example Album that is very long and therefore needs scrolling";
}

-(NSString*)musicPlayer:(BeamMusicPlayerViewController *)player artistForTrack:(NSUInteger)trackNumber {
    return @"Cim Tooks and the Pineapples";
}

-(NSString*)musicPlayer:(BeamMusicPlayerViewController *)player titleForTrack:(NSUInteger)trackNumber {
    return @"If the Foo sings bar, it makes me wanna baz.";
}

-(CGFloat)musicPlayer:(BeamMusicPlayerViewController *)player lengthForTrack:(NSUInteger)trackNumber {
    return 125;
}

-(NSInteger)numberOfTracksInPlayer:(BeamMusicPlayerViewController *)player {
    return 3;
}

-(void)musicPlayer:(BeamMusicPlayerViewController *)player artworkForTrack:(NSUInteger)trackNumber receivingBlock:(BeamMusicPlayerReceivingBlock)receivingBlock {
    NSString* url = @"http://1.bp.blogspot.com/_Vz80r4vjf_I/TK3xU5WGx1I/AAAAAAAAAgc/nH65fgeum3k/s1600/master-of-puppets.jpg";
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSData* urlData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        
        UIImage* image = [UIImage imageWithData:urlData];
        receivingBlock(image,nil);
    });
}

@end
