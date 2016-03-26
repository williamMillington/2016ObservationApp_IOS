//
//  SearchViewController.h
//  DrupalAPITester
//
//  Created by William Millington on 2016-03-09.
//  Copyright © 2016 William Millington. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SWRevealViewController.h"
#import "SearchPanelView.h"
#import "ObservationCollectionViewController.h"
#import "ObservationCollectionViewCell.h"
#import "ObservationViewController.h"

#import "DIOSNode.h"
#import "DIOSView.h"
#import "UIImage+AFNetworking.h"
#import "UIImageView+AFNetworking.h"

@interface SearchViewController : UICollectionViewController


- (void) fetchObservations:(NSMutableDictionary *)parameters;


@end
