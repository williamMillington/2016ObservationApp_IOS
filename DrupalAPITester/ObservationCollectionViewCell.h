//
//  ObservationCollectionViewCell.h
//  DrupalAPITester
//
//  Created by William Millington on 2016-03-01.
//  Copyright © 2016 William Millington. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ObservationCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *observation_title;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) NSString *nid;
@property (weak, nonatomic) NSString *uid;
@property (weak, nonatomic) NSString *field_date_observed;

@property (weak, nonatomic) IBOutlet UIImageView *imgThumbnail;

@end
