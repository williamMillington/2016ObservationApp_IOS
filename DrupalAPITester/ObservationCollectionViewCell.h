//
//  ObservationCollectionViewCell.h
//  DrupalAPITester
//
//  Created by William Millington on 2016-03-01.
//  Copyright © 2016 William Millington. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ObservationCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *observationName;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) NSString *nid;

@property (weak, nonatomic) IBOutlet UIImageView *imgThumbnail;

@end
