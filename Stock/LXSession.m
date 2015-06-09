//
//  LXSession.m
//  CityApp
//
//  Created by Will Schreiber on 4/23/14.
//  Copyright (c) 2014 LXV. All rights reserved.
//

#import "LXSession.h"

#define NULL_TO_NIL(obj) ({ __typeof__ (obj) __obj = (obj); __obj == [NSNull null] ? nil : obj; })

static LXSession* thisSession = nil;

@implementation LXSession

@synthesize locationManager, cachedUser;

//constructor
-(id) init
{
    if (thisSession) {
        return thisSession;
    }
    self = [super init];
    return self;
}


//singleton instance
+(LXSession*) thisSession
{
    if (!thisSession) {
        thisSession = [[super allocWithZone:NULL] init];
    }
    return thisSession;
}


//prevent creation of additional instances
+(id)allocWithZone:(NSZone *)zone
{
    return [self thisSession];
}

//users
- (NSMutableDictionary*) user
{
    if (self.cachedUser) {
        return self.cachedUser;
    } else {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if ([defaults objectForKey:@"localUserKey"]) {
            NSMutableDictionary *u = [LXServer objectWithLocalKey:[defaults objectForKey:@"localUserKey"]];
            [self setCachedUser:u];
            return u;
        } else {
            return nil;
        }
    }
}

- (void) setUser:(NSMutableDictionary*)u
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [u saveLocalWithKey:[defaults objectForKey:@"localUserKey"]];
    [defaults synchronize];
    [self setCachedUser:u];
}

- (void) setUser:(NSMutableDictionary*)u success:(void (^)(id responseObject))successCallback failure:(void (^)(NSError* error))failureCallback
{
    [self setUser:u];
    if (successCallback) {
        successCallback(@{});
    }
}

- (NSMutableDictionary*) userFromDefaults
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"localUserKey"]) {
        NSMutableDictionary *u = [LXServer objectWithLocalKey:[defaults objectForKey:@"localUserKey"]];
        [self setCachedUser:u];
        return u;
    } else {
        return nil;
    }
}

+ (void) storeLocalUserKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:key forKey:@"localUserKey"];
    [defaults synchronize]; 
}

//saving
+ (NSString*) documentsPathForFileName:(NSString*) name
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    
    return [documentsPath stringByAppendingPathComponent:name];
}

+ (NSString*) writeImageToDocumentsFolder:(UIImage *)image
{
    // Get image data. Here you can use UIImagePNGRepresentation if you need transparency
    NSData *imageData = UIImageJPEGRepresentation(image, 1);
    // Get image path in user's folder and store file with name image_CurrentTimestamp.jpg (see documentsPathForFileName below)
    NSString *imagePath = [self documentsPathForFileName:[NSString stringWithFormat:@"image_%f.jpg", [NSDate timeIntervalSinceReferenceDate]]];
    // Write image data to user's folder
    [imageData writeToFile:imagePath atomically:YES];
    return imagePath;
}




+ (CLLocation*) currentLocation
{
    if ([[LXSession thisSession] locationManager]) {
        return [[[LXSession thisSession] locationManager] location];
    }
    return nil;
}

- (BOOL) hasLocation
{
    return ([self locationManager] && [[self locationManager] location]);
}

+ (BOOL) locationPermissionDetermined
{
    if ([CLLocationManager locationServicesEnabled]) {
        NSLog(@"Location Services Enabled");
        if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied) {
            NSLog(@"locationDenied!");
        } else if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorized) {
            NSLog(@"location authorized!");
        } else if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorizedAlways || [CLLocationManager authorizationStatus] ==kCLAuthorizationStatusAuthorizedWhenInUse) {
            NSLog(@"new location authorized!");
        } else {
            NSLog(@"indeterminate!");
            return NO;
        }
    }
    return YES;
}

- (void) startLocationUpdates
{
    if (nil == locationManager)
        locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    
    if ([LXSession locationPermissionDetermined]) {
        [self getCurrentLocation];
    } else {
        if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [self.locationManager requestWhenInUseAuthorization];
        } else {
            [self.locationManager startUpdatingLocation];
        }
    }
}

- (void) getCurrentLocation
{
    NSLog(@"getting current location!");
    locationManager.distanceFilter = 50.0;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
}

- (void) locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorizedAlways || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [self getCurrentLocation];
    }
}

- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *myLocation = [locations lastObject];
    //[manager stopUpdatingLocation];
    NSLog(@"LATITUDE, LONGITUDE: %f, %f", myLocation.coordinate.latitude, myLocation.coordinate.longitude);
}


# pragma mark - Push Notifications
+ (BOOL) areNotificationsEnabled
{
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(currentUserNotificationSettings)]){
        UIUserNotificationSettings *noticationSettings = [[UIApplication sharedApplication] currentUserNotificationSettings];
        if (!noticationSettings || (noticationSettings.types == UIUserNotificationTypeNone)) {
            return NO;
        }
        return YES;
    }
    
    UIRemoteNotificationType types = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
    return (types & UIRemoteNotificationTypeAlert);
}

@end
