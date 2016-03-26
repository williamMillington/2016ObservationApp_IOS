//
//  VCUtility.h
//  DrupalAPITester
//
//  Created by William Millington on 2016-03-23.
//  Copyright © 2016 William Millington. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UploadViewController.h"
#import "SWRevealViewController.h"
#import "SideMenuViewController.h"

@import LGPlusButtonsView;


@interface VCUtility : NSObject


typedef NS_ENUM(NSInteger, CREATE_OBSERVATION_OPTION){
    CREATE_WITH_TAKE_PHOTO,
    CREATE_WITH_GALLERY_PHOTO,
    CREATE_WITHOUT_PHOTO
};

+ (LGPlusButtonsView *) initFABView;
+ (void) createObservationWithOption:(CREATE_OBSERVATION_OPTION)option;




@end