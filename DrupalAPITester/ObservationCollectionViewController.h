//
//  ObservationCollectionViewController.h
//  ObservationApp
//
/**	 ObservationApp, Copyright 2016, University of Prince Edward Island,
 *    550 University Avenue, C1A4P3,
 *    Charlottetown, PE, Canada
 *
 * 	 @author William Millington<wmillington@upei.ca>
 *
 *   This file is part of ObservationApp.
 *
 *   ObservationApp is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation, either version 3 of the License, or
 *   (at your option) any later version.
 *
 *
 *   You should have received a copy of the GNU General Public License
 *   along with Observation App.  If not, see <http://www.gnu.org/licenses/>.
 */

#import <UIKit/UIKit.h>
#import "ObservationCollectionViewCell.h"
#import "ObservationViewController.h"
#import "VCUtility.h"
#import "UploadViewController.h"

#import "DIOSNode.h"
#import "DIOSView.h"
#import "DIOSUser.h"
#import "DIOSSystem.h"
#import "DIOSSession.h"

#import "UIImage+AFNetworking.h"
#import "UIImageView+AFNetworking.h"

#import "Reachability.h"

#import "SWRevealViewController.h"
@import LGPlusButtonsView;
//@import KCFloatingActionButton;

@interface ObservationCollectionViewController : UICollectionViewController

@property (strong, nonatomic) LGPlusButtonsView *fabView;

@end
