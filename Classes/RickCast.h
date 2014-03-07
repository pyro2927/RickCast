//
//  RickCast.h
//  Pods
//
//  Created by Joseph Pintozzi on 3/7/14.
//
//

#import <Foundation/Foundation.h>
#import <GoogleCast/GoogleCast.h>

@interface RickCast : NSObject<GCKDeviceScannerListener, GCKDeviceManagerDelegate, GCKMediaControlChannelDelegate>

@end
