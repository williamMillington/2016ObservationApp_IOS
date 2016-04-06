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
    
    
//    NSLog(@"%@",[DIOSSession sharedSession]);
//    NSLog(@"%@",[[DIOSSession sharedSession] csrfToken]);
//    NSLog(@"%@",[[DIOSSession sharedSession] user]);
    
    
    [[DIOSSession sharedSession] getCSRFTokenWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject){
            NSLog(@"SUCCESS");
        
            NSLog(@"%@",[[DIOSSession sharedSession] csrfToken]);
        
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:[[DIOSSession sharedSession] csrfToken] forKey:@"token"];
            [defaults synchronize];
        
    }
                                                 failure:^(AFHTTPRequestOperation *operation, NSError *error){
                                                     NSLog(@"FAILURE");
    }
     ];
    
    
    
//    [DIOSUser
//     userMakeSureUserIsLoggedInWithUsername:@"wmillington"
//     andPassword:@"password"
//     success:^(AFHTTPRequestOperation *op, id response) { /* Handle successful operation here */
//         
//         NSLog(@"Still Logged In!");
//         NSLog(@"%@",response);
//         
//         
//         NSString *token = response[@"token"];
//         NSLog(@"%@",token);
//         
//         
////         sessionName = response[@"session_name"];
////         sessionValue = response[@"sessid"];
////         tokenValue = response[@"sessid"];
////         
////         DIOSSession *session = [DIOSSession sharedSession];
//////         [[DIOSSession sharedSession] addHeaderValue:[NSString stringWithFormat:@"%@=%@", sessionName, sessionValue] forKey:@"cookie"];
//////         [[DIOSSession sharedSession] addHeaderValue:[NSString stringWithFormat:@"%@", tokenValue] forKey:@"X-CSRF-Token"];
////         
////         [[DIOSSession sharedSession] setCsrfToken:tokenValue];
////         
////         [DIOSSystem systemConnectwithSuccess: ^(AFHTTPRequestOperation *operation, id responseObject) {
////             NSLog(@"SUCCESS RECONNECT");
////         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
////             NSLog(@"FAIL RECONNECT: %@", error);
////         }
////          ];
//         
//     }
//     failure:^(AFHTTPRequestOperation *op, NSError *err) { /* Handle operation failire here */
//         NSLog(@"FUCK");
//     }
//     ];
    
    return YES;
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
