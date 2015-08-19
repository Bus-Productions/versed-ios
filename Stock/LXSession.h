//
//  LXSession.h
//  CityApp
//
//  Created by Will Schreiber on 4/23/14.
//  Copyright (c) 2014 LXV. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;
#import <CoreLocation/CoreLocation.h>

@interface LXSession : NSObject <CLLocationManagerDelegate>

+(LXSession*) thisSession;
- (NSMutableDictionary*) user;
- (NSMutableDictionary*) userFromDefaults;
- (void) setUser:(NSMutableDictionary*)u;
- (void) setUser:(NSMutableDictionary*)u success:(void (^)(id responseObject))successCallback failure:(void (^)(NSError* error))failureCallback;

//users
@property (strong, nonatomic) NSMutableDictionary *cachedUser;
+ (void) storeLocalUserKey:(NSString *)key;

//saving
+ (NSString*) documentsPathForFileName:(NSString*) name;
+ (NSString*) writeImageToDocumentsFolder:(UIImage*)image;


//locations
@property (strong, nonatomic) CLLocationManager* locationManager;
+ (CLLocation*) currentLocation;
- (BOOL) hasLocation;
+ (BOOL) locationPermissionDetermined;
- (void) startLocationUpdates;

@end
