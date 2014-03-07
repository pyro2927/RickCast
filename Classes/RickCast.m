//
//  RickCast.m
//  Pods
//
//  Created by Joseph Pintozzi on 3/7/14.
//
//

#import "RickCast.h"

@interface RickCast ()

@property GCKMediaControlChannel *mediaControlChannel;
@property GCKApplicationMetadata *applicationMetadata;
@property GCKDevice *selectedDevice;
@property(nonatomic, strong) GCKDeviceScanner *deviceScanner;
@property(nonatomic, strong) GCKDeviceManager *deviceManager;
@property(nonatomic, readonly) GCKMediaInformation *mediaInformation;

@end

@implementation RickCast

+(void)load
{
    @autoreleasepool {
        [RickCast sharedInstance];
    }
}

+ (RickCast*)sharedInstance
{
    static dispatch_once_t once;
    static RickCast *sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id)init{
    self = [super init];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidFinishLaunching:)
                                                 name:UIApplicationDidFinishLaunchingNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidBecomeActive:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidEnterBackground:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    return self;
}

- (void)applicationDidFinishLaunching:(NSNotification*)notification {
    [self.deviceScanner addListener:self];
    [self.deviceScanner startScan];
}

- (void)applicationDidBecomeActive:(NSNotification*)notification {
    
}

- (void)applicationDidEnterBackground:(NSNotification*)notification {
    
}

#pragma mark - GCKDeviceScannerListener
- (void)deviceDidComeOnline:(GCKDevice *)device {
    if (self.deviceScanner.devices > 0) {
        [self connectToDevice:device];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //Here your non-main thread.
            [NSThread sleepForTimeInterval:5.0f];
            dispatch_async(dispatch_get_main_queue(), ^{
                //Here you returns to main thread.
                [self castVideo];
            });
        });
    }
}

- (void)deviceDidGoOffline:(GCKDevice *)device {
}

#pragma mark - GCKDeviceManagerDelegate
- (void)deviceManagerDidConnect:(GCKDeviceManager *)deviceManager {
    [self.deviceManager launchApplication:kGCKMediaDefaultReceiverApplicationID];
}

- (void)connectToDevice:(GCKDevice*)device {
    if (self.selectedDevice == nil)
        return;
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    self.deviceManager = [[GCKDeviceManager alloc] initWithDevice:device
                           clientPackageName:[info objectForKey:@"CFBundleIdentifier"]];
    self.deviceManager.delegate = self;
    [self.deviceManager connect];
    
}

- (IBAction)castVideo {
    //Show alert if not connected
    if (!self.deviceManager || !self.deviceManager.isConnected) {
        return;
    }
    
    //Define Media metadata
    GCKMediaMetadata *metadata = [[GCKMediaMetadata alloc] init];
    
    [metadata setString:@"Never Gonna Give You Up" forKey:kGCKMetadataKeyTitle];
    
    [metadata setString:@"" forKey:kGCKMetadataKeySubtitle];
    
    /*
    [metadata addImage:[[GCKImage alloc]
                        initWithURL:[[NSURL alloc] initWithString:@"http://www.http-web-proxy.eu/download/12409v4/55134921/3rdparty/1c123daaef.480.mp4/Rick%20Roll%20%E2%80%94%20Never%20Gonna%20Give%20You%20Up.mp4"]
                        width:480
                        height:360]];
    */
    //define Media information
    GCKMediaInformation *mediaInformation =
    [[GCKMediaInformation alloc] initWithContentID:
     @"http://www.http-web-proxy.eu/download/12409v4/55134921/3rdparty/1c123daaef.480.mp4/Rick%20Roll%20%E2%80%94%20Never%20Gonna%20Give%20You%20Up.mp4"
                                        streamType:GCKMediaStreamTypeNone
                                       contentType:@"video/mp4"
                                          metadata:metadata
                                    streamDuration:0
                                        customData:nil];
    
    //cast video
    [_mediaControlChannel loadMedia:mediaInformation autoplay:TRUE playPosition:0];
}

@end
