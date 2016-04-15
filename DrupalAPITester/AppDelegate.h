//
//  AppDelegate.h
//  DrupalAPITester
//
//  Created by William Millington on 2016-02-28.
//  Copyright © 2016 William Millington. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DIOSSession.h"
#import "DIOSNode.h"

#import "Reachability.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (retain, nonatomic)  Reachability* reachability;


@end

