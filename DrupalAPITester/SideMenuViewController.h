//
//  SideMenuViewController.h
//  DrupalAPITester
//
//  Created by William Millington on 2016-03-09.
//  Copyright © 2016 William Millington. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SWRevealViewController.h"
#import "SearchViewController.h"

@interface SideMenuViewController : UITableViewController

@property (nonatomic, strong) UINavigationController *current;
@end
