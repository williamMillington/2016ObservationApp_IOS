//
//  SearchViewController.h
//  DrupalAPITester
//
//  Created by William Millington on 2016-03-09.
//  Copyright © 2016 William Millington. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ObservationCollectionViewController.h"

@interface SearchViewController : UICollectionViewController


- (void) fetchObservations:(NSMutableDictionary *)parameters;

@end
