#import "OutputsArrayController.h"

@implementation OutputsArrayController

#if 0
- (void)awakeFromNib
{
	NSLog(@"OUTPUT: Enumaerting Devices");
	
	
	[self removeObjects:[self arrangedObjects]];
	
	[self setSelectsInsertedObjects:NO];
			
	UInt32 propsize;
	verify_noerr(AudioHardwareGetPropertyInfo(kAudioHardwarePropertyDevices, &propsize, NULL));
	int nDevices = propsize / sizeof(AudioDeviceID);	
	AudioDeviceID *devids = malloc(propsize);
	verify_noerr(AudioHardwareGetProperty(kAudioHardwarePropertyDevices, &propsize, devids));
	int i;
	
	NSDictionary *defaultDevice = [[[NSUserDefaultsController sharedUserDefaultsController] defaults] objectForKey:@"outputDevice"];
	
	for (i = 0; i < nDevices; ++i) {
		char name[256];
		UInt32 maxlen = 256;
		verify_noerr(AudioDeviceGetProperty(devids[i], 0, false, kAudioDevicePropertyDeviceName, &maxlen, name));
		
		// Ignore devices that have no output channels:
		// This tells us the size of the buffer required to hold the information about the channels
		UInt32 propSize;
		verify_noerr(AudioDeviceGetPropertyInfo(devids[i], 0, false, kAudioDevicePropertyStreamConfiguration, &propSize, NULL));
		// Knowing the size of the required buffer, we can determine how many channels there are
		// without actually allocating a buffer and requesting the information.
		// (we don't care about the exact number of channels, only if there are more than zero or not)
		if (propSize <= sizeof(UInt32)) continue;

		NSDictionary *deviceInfo = [NSDictionary dictionaryWithObjectsAndKeys:
			[NSString stringWithUTF8String:name], @"name",
			[NSNumber numberWithLong:devids[i]], @"deviceID",
			nil];
		
		NSLog(@"Device name: %s DeviceID: %i", name, [NSNumber numberWithLong:devids[i]]);
		
		[self addObject:deviceInfo];
		
		if (defaultDevice) {
			if ([[defaultDevice objectForKey:@"deviceID"] isEqualToNumber:[deviceInfo objectForKey:@"deviceID"]]) {
				[self setSelectedObjects:[NSArray arrayWithObject:deviceInfo]];
			}
		}

		[deviceInfo release];
	}
	free(devids);
	
		
	if (!defaultDevice)
		[self setSelectionIndex:0];
}
#else

- (void)awakeFromNib
{
	NSLog(@"OUTPUT: Enumaerting Devices");
	
	AudioObjectPropertyAddress  propertyAddress;
	AudioObjectID               *deviceIDs;
	UInt32                      propertySize;
	NSInteger                   numDevices;
	
	propertyAddress.mSelector = kAudioHardwarePropertyDevices;
	propertyAddress.mScope = kAudioObjectPropertyScopeOutput;
	propertyAddress.mElement = kAudioObjectPropertyElementMaster;
	
	if (AudioObjectGetPropertyDataSize(kAudioObjectSystemObject, &propertyAddress, 0, NULL, &propertySize) == noErr)
	{
		numDevices = propertySize / sizeof(AudioDeviceID);
		deviceIDs = (AudioDeviceID *)calloc(numDevices, sizeof(AudioDeviceID));
		
		if (AudioObjectGetPropertyData(kAudioObjectSystemObject, &propertyAddress, 0, NULL, &propertySize, deviceIDs) == noErr) {
			AudioObjectPropertyAddress      deviceAddress;
			char                            deviceName[64];
			char                            manufacturerName[64];
			
			for (NSInteger idx=0; idx<numDevices; idx++) {
				propertySize = sizeof(deviceName);
				deviceAddress.mSelector = kAudioDevicePropertyDeviceName;
				deviceAddress.mScope = kAudioObjectPropertyScopeOutput;
				deviceAddress.mElement = kAudioObjectPropertyElementMaster;
				if (AudioObjectGetPropertyData(deviceIDs[idx], &deviceAddress, 0, NULL, &propertySize, deviceName) == noErr) {
					propertySize = sizeof(manufacturerName);
					deviceAddress.mSelector = kAudioDevicePropertyDeviceManufacturer;
					//deviceAddress.mScope = kAudioObjectPropertyScopeGlobal;
					deviceAddress.mScope = kAudioObjectPropertyScopeOutput;
					deviceAddress.mElement = kAudioObjectPropertyElementMaster;
					if (AudioObjectGetPropertyData(deviceIDs[idx], &deviceAddress, 0, NULL, &propertySize, manufacturerName) == noErr) {
						CFStringRef     uidString;
						
						propertySize = sizeof(uidString);
						deviceAddress.mSelector = kAudioDevicePropertyDeviceUID;
						//deviceAddress.mScope = kAudioObjectPropertyScopeGlobal;
						deviceAddress.mScope = kAudioObjectPropertyScopeOutput;
						deviceAddress.mElement = kAudioObjectPropertyElementMaster;
						if (AudioObjectGetPropertyData(deviceIDs[idx], &deviceAddress, 0, NULL, &propertySize, &uidString) == noErr)
						{
							NSLog(@"device %s by %s id %i = %@", deviceName, manufacturerName, (UInt32) deviceIDs[idx], uidString);

							NSDictionary *deviceInfo = [NSDictionary dictionaryWithObjectsAndKeys:
														[NSString stringWithUTF8String:deviceName], @"name",
														[NSNumber numberWithLong:deviceIDs[idx]], @"deviceID",
														nil];
	
							[self addObject:deviceInfo];
							
							[deviceInfo release];
							
							
							CFRelease(uidString);
						}
					}
				}
			}
		}
		
		free(deviceIDs);
	}
}

#endif

@end
