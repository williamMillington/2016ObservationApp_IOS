//
//  AppDelegate.m
//  DrupalAPITester
//
//  Created by William Millington on 2016-02-28.
//  Copyright © 2016 William Millington. All rights reserved.
//

#import "AppDelegate.h"

#import "DIOSUser.h"
#import "DIOSSystem.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
   
    [DIOSSession setupDios];
    
    // register self for network reconnection notification
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(networkStatusChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    
    
    // -- Start monitoring network reachability (globally available) -- //
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    
    // AFNetworking only allows one responder block, so use this to send out a notification that can be picked up anywhere
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kReachabilityChangedNotification object:nil];
        
        }
     ];
    
    return YES;
}



- (void) networkStatusChanged:(NSNotification*)notification{

    // if we can reach the internet, refetch the CSRF token
    if([AFNetworkReachabilityManager sharedManager].reachable){
        
        [[DIOSSession sharedSession] getCSRFTokenWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject){
        
                    NSLog(@"%@",[[DIOSSession sharedSession] csrfToken]);
        
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    [defaults setObject:[[DIOSSession sharedSession] csrfToken] forKey:@"token"];
                    [defaults synchronize];
        
                }
                                                         failure:^(AFHTTPRequestOperation *operation, NSError *error){
                                                             NSLog(@"FAILURE");
                                                        }
                 ];
    }
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
