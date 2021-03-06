//
//  PreferencesController.m
//  Preferences
//
//  Created by Vincent Spader on 9/4/06.
//  Copyright 2006 Vincent Spader. All rights reserved.
//

#import "GeneralPreferencesPlugin.h"

@implementation GeneralPreferencesPlugin

+ (NSArray *)preferencePanes
{
	GeneralPreferencesPlugin *plugin = [[[GeneralPreferencesPlugin alloc] init] autorelease];
#if 0
	NSBundle *bundle  = [NSBundle mainBundle];
	NSArray  *objects = [NSArray arrayWithObjects:
						 [plugin playlistPane],
						 [plugin hotKeyPane],
						 [plugin remotePane],
						 [plugin updatesPane],
						 [plugin outputPane],
						 [plugin scrobblerPane],
						 [plugin growlPane],
						 [plugin appearancePane],
						 nil];

	[bundle loadNibNamed:@"Preferences" owner:plugin topLevelObjects:&objects];
#else
	[NSBundle loadNibNamed:@"Preferences" owner:plugin];
#endif
	return [NSArray arrayWithObjects:
			[plugin playlistPane],
			[plugin hotKeyPane],
			[plugin remotePane],
			[plugin updatesPane],
			[plugin outputPane],
			[plugin scrobblerPane],
            [plugin growlPane],
            [plugin appearancePane],
			nil];
}	

- (HotKeyPane *)hotKeyPane
{
	return hotKeyPane;
}

- (OutputPane *)outputPane
{
	return outputPane;
}

- (GeneralPreferencePane *)remotePane
{
	return [GeneralPreferencePane preferencePaneWithView:remoteView title:NSLocalizedStringFromTableInBundle(@"Remote", nil, [NSBundle bundleForClass:[self class]],  @"")  iconNamed:@"apple_remote"];
}

- (GeneralPreferencePane *)updatesPane
{
	return [GeneralPreferencePane preferencePaneWithView:updatesView title:NSLocalizedStringFromTableInBundle(@"Updates", nil, [NSBundle bundleForClass:[self class]], @"")  iconNamed:@"updates"];
}

- (GeneralPreferencePane *)scrobblerPane
{
	return [GeneralPreferencePane preferencePaneWithView:scrobblerView title:NSLocalizedStringFromTableInBundle(@"Last.fm", nil, [NSBundle bundleForClass:[self class]], @"")  iconNamed:@"lastfm"];
}

- (GeneralPreferencePane *)playlistPane
{
	return [GeneralPreferencePane preferencePaneWithView:playlistView title:NSLocalizedStringFromTableInBundle(@"Playlist", nil, [NSBundle bundleForClass:[self class]], @"")  iconNamed:@"playlist"];
}

- (GeneralPreferencePane *)growlPane
{
	return [GeneralPreferencePane preferencePaneWithView:growlView title:NSLocalizedStringFromTableInBundle(@"Growl", nil, [NSBundle bundleForClass:[self class]], @"")  iconNamed:@"growl"];
}

- (GeneralPreferencePane *)appearancePane
{
	return [GeneralPreferencePane preferencePaneWithView:appearanceView title:NSLocalizedStringFromTableInBundle(@"Appearance", nil, [NSBundle bundleForClass:[self class]], @"")  iconNamed:@"appearance"];
}

@end
