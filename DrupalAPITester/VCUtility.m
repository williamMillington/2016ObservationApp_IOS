//
//  VCUtility.m
//  DrupalAPITester
//
//  Created by William Millington on 2016-03-23.
//  Copyright © 2016 William Millington. All rights reserved.
//

#import "VCUtility.h"

@implementation VCUtility



+ (LGPlusButtonsView *) initFABView {
    
    
    
    LGPlusButtonsView *fabView = [LGPlusButtonsView plusButtonsViewWithNumberOfButtons:4
                                            firstButtonIsPlusButton:YES
                                                      showAfterInit:YES
                                                      actionHandler:^(LGPlusButtonsView *plusButtonView, NSString *title, NSString *description, NSUInteger index) {
                   
                   switch(index){
                       case 0:
                           break;
                       case 1:
                           // Take photo
                           [self createObservationWithOption:CREATE_WITH_TAKE_PHOTO];
                           [plusButtonView hideButtonsAnimated:YES completionHandler:nil];
                           
                           break;
                       case 2:
                           // Choose photo
                           [self createObservationWithOption:CREATE_WITH_GALLERY_PHOTO];
                           [plusButtonView hideButtonsAnimated:YES completionHandler:nil];
                           break;
                       case 3:
                           // No photo
                           [self createObservationWithOption:CREATE_WITHOUT_PHOTO];
                           [plusButtonView hideButtonsAnimated:YES completionHandler:nil];
                           break;
                       default:
                           NSLog(@"Default case");
                           break;
                   }
               }];
    
    
    
    //------------------------------------------------------------------------------
    // This is all pretty much copied verbatim from the LGPlusButtons github page
    //------------------------------------------------------------------------------
    fabView.coverColor = [UIColor colorWithWhite:1.f alpha:0.7];
    fabView.position = LGPlusButtonsViewPositionBottomRight;
    fabView.plusButtonAnimationType = LGPlusButtonAnimationTypeRotate;
    
    // Move buttons slightly inwards from the screen edge
    fabView.offset = CGPointMake(-10.f, -20.f);
    
    
    [fabView setButtonsTitles:@[@"+", @"", @"", @""] forState:UIControlStateNormal];
    [fabView setDescriptionsTexts:@[@"", @"Take observation photo", @"Choose photo from gallery", @"Observation without photo"]];
    [fabView setButtonsImages:@[[NSNull new], [UIImage imageNamed:@"Camera"], [UIImage imageNamed:@"Picture"], [UIImage imageNamed:@"Message"]]
                     forState:UIControlStateNormal
               forOrientation:LGPlusButtonsViewOrientationAll];
    [fabView setButtonsAdjustsImageWhenHighlighted:NO];
    
    
    [fabView setButtonsBackgroundColor:[UIColor colorWithRed:0.f green:0.5 blue:1.f alpha:1.f] forState:UIControlStateNormal];
    [fabView setButtonsBackgroundColor:[UIColor colorWithRed:0.2 green:0.6 blue:1.f alpha:1.f] forState:UIControlStateHighlighted];
    [fabView setButtonsBackgroundColor:[UIColor colorWithRed:0.2 green:0.6 blue:1.f alpha:1.f] forState:UIControlStateHighlighted|UIControlStateSelected];
    
    
    [fabView setButtonsSize:CGSizeMake(44.f, 44.f) forOrientation:LGPlusButtonsViewOrientationAll];
    [fabView setButtonsLayerCornerRadius:44.f/2.f forOrientation:LGPlusButtonsViewOrientationAll];
    [fabView setButtonsTitleFont:[UIFont boldSystemFontOfSize:24.f] forOrientation:LGPlusButtonsViewOrientationAll];
    
    
    [fabView setButtonsLayerShadowColor:[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1.f]];
    [fabView setButtonsLayerShadowOpacity:0.5];
    [fabView setButtonsLayerShadowRadius:3.f];
    [fabView setButtonsLayerShadowOffset:CGSizeMake(0.f, 2.f)];
    
    
    [fabView setButtonAtIndex:0 size:CGSizeMake(56.f, 56.f)
               forOrientation:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? LGPlusButtonsViewOrientationPortrait : LGPlusButtonsViewOrientationAll)];
    [fabView setButtonAtIndex:0 layerCornerRadius:56.f/2.f
               forOrientation:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? LGPlusButtonsViewOrientationPortrait : LGPlusButtonsViewOrientationAll)];
    [fabView setButtonAtIndex:0 titleFont:[UIFont systemFontOfSize:40.f]
               forOrientation:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? LGPlusButtonsViewOrientationPortrait : LGPlusButtonsViewOrientationAll)];
    [fabView setButtonAtIndex:0 titleOffset:CGPointMake(0.f, -3.f) forOrientation:LGPlusButtonsViewOrientationAll];
    
    
    [fabView setButtonAtIndex:1 backgroundColor:[UIColor colorWithRed:1.f green:0.f blue:0.5 alpha:1.f] forState:UIControlStateNormal];
    [fabView setButtonAtIndex:1 backgroundColor:[UIColor colorWithRed:1.f green:0.2 blue:0.6 alpha:1.f] forState:UIControlStateHighlighted];
    [fabView setButtonAtIndex:2 backgroundColor:[UIColor colorWithRed:1.f green:0.5 blue:0.f alpha:1.f] forState:UIControlStateNormal];
    [fabView setButtonAtIndex:2 backgroundColor:[UIColor colorWithRed:1.f green:0.6 blue:0.2 alpha:1.f] forState:UIControlStateHighlighted];
    [fabView setButtonAtIndex:3 backgroundColor:[UIColor colorWithRed:0.f green:0.7 blue:0.f alpha:1.f] forState:UIControlStateNormal];
    [fabView setButtonAtIndex:3 backgroundColor:[UIColor colorWithRed:0.f green:0.8 blue:0.f alpha:1.f] forState:UIControlStateHighlighted];
    
    
    [fabView setDescriptionsBackgroundColor:[UIColor whiteColor]];
    [fabView setDescriptionsTextColor:[UIColor blackColor]];
    [fabView setDescriptionsLayerShadowColor:[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1.f]];
    [fabView setDescriptionsLayerShadowOpacity:0.25];
    [fabView setDescriptionsLayerShadowRadius:1.f];
    [fabView setDescriptionsLayerShadowOffset:CGSizeMake(0.f, 1.f)];
    [fabView setDescriptionsLayerCornerRadius:6.f forOrientation:LGPlusButtonsViewOrientationAll];
    [fabView setDescriptionsContentEdgeInsets:UIEdgeInsetsMake(4.f, 8.f, 4.f, 8.f) forOrientation:LGPlusButtonsViewOrientationAll];
    
    
    for (NSUInteger i=1; i<=3; i++)
        [fabView setButtonAtIndex:i offset:CGPointMake(-6.f, 0.f)
                   forOrientation:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? LGPlusButtonsViewOrientationPortrait : LGPlusButtonsViewOrientationAll)];
    
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        [fabView setButtonAtIndex:0 titleOffset:CGPointMake(0.f, -2.f) forOrientation:LGPlusButtonsViewOrientationLandscape];
        [fabView setButtonAtIndex:0 titleFont:[UIFont systemFontOfSize:32.f] forOrientation:LGPlusButtonsViewOrientationLandscape];
    }
    
    return fabView;
}



+ (void) createObservationWithOption:(CREATE_OBSERVATION_OPTION)option{

    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    UIViewController *root = (SWRevealViewController *)[window rootViewController];
    
    UploadViewController *uploader = [[UploadViewController alloc] initWithNibName:@"UploadViewController"
                                                                            bundle:nil];
    UploadNavigationViewController *uploaderNav = [[UploadNavigationViewController alloc] initWithRootViewController:uploader];
    
    [uploaderNav setModalPresentationStyle:UIModalPresentationPopover];
    
    
    
    
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.delegate = uploader;
    
    
    if(option == CREATE_WITHOUT_PHOTO){
        [root presentViewController:uploaderNav animated:YES completion:nil];
    }
    else {
        
        if(option == CREATE_WITH_TAKE_PHOTO){
        
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
                ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
            }
            else {
                UIAlertView *noCameraAlert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                        message:@"No Camera Available"
                                                                       delegate:self
                                                              cancelButtonTitle:@"Okay"
                                                              otherButtonTitles:nil,
                                              nil];
                [noCameraAlert show];
                noCameraAlert = nil;
            }
        }
        else {
            ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
    
        
        [root presentViewController:uploaderNav animated:YES completion:nil];
        [uploaderNav presentViewController:ipc animated:YES completion:nil];
    
    }
}

@end







