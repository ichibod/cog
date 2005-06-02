//
//  PlaylistEntry.h
//  Cog
//
//  Created by Vincent Spader on 3/14/05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SoundFile.h"

@interface PlaylistEntry : NSObject {
	NSString *filename;
	NSString *display;

	NSString *artist;
	NSString *album;
	NSString *title;
	NSString *genre;

	unsigned int year;
	unsigned int track;	
	
	NSString *lengthString;
	
	double length;
	int bitRate;
	int channels;
	int bitsPerSample;
	float sampleRate;
	
	BOOL current;
	
	int idx;
}

-(void)setIndex:(int)i;
-(int)index;
-(void)setFilename:(NSString *)f;
-(NSString *)filename;
-(void)setDisplay:(NSString *)d;
-(NSString *)display;
-(void)setCurrent:(BOOL) b;
-(BOOL)current;

- (void)setArtist:(NSString *)s;
- (NSString *)artist;
- (void)setAlbum:(NSString *)s;
- (NSString *)album;
- (void)setTitle:(NSString *)s;
- (NSString *)title;
- (void)setGenre:(NSString *)s;
- (NSString *)genre;

- (NSString *)lengthString;
- (void)setLengthString:(double)l;

- (double)length;
- (int)bitRate;
- (int)channels;
- (int)bitsPerSample;
- (float)sampleRate;

- (void)readTags;
- (void)readInfo;

@end
