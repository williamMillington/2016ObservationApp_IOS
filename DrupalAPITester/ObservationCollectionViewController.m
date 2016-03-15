//
//  ObservationCollectionViewController.m
//  DrupalAPITester
//
//  Created by William Millington on 2016-03-01.
//  Copyright © 2016 William Millington. All rights reserved.
//

#import "ObservationCollectionViewController.h"
#import "ObservationCollectionViewCell.h"

#import "DIOSNode.h"
#import "DIOSView.h"
#import "UIImage+AFNetworking.h"
#import "UIImageView+AFNetworking.h"

#import "SWRevealViewController.h"

@interface ObservationCollectionViewController ()
@end

@implementation ObservationCollectionViewController{
    NSArray *observations;
}

//@synthesize observations;
static NSString* const reuseIdentifier = @"ObservationCell";



- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    
    // Configure the menu button on the leftside
    UIBarButtonItem *sidebarButton = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:
                                                    UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.leftBarButtonItem = sidebarButton;
    
    // Grab and configure Side Menu Controller 
    SWRevealViewController *revealViewController = self.revealViewController;
    if (revealViewController){
        [sidebarButton setTarget: self.revealViewController];
        [sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    observations = [[NSArray alloc] init];
    
    // only load from source on first instance of viewDidLoad
    [self fetchObservations];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [observations count];
}



- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ObservationCollectionViewCell *cell = [collectionView
                                        dequeueReusableCellWithReuseIdentifier:reuseIdentifier
                                        forIndexPath:indexPath];
    
    // Style cell shadow
    cell.layer.shadowOffset = CGSizeMake(0.5f, 0.5f);
    cell.layer.shadowRadius = 0.5f;
    cell.layer.shadowOpacity = 0.5f;
    cell.layer.masksToBounds = NO;
    
    // Retrieve the html string detailing the URL of the image
    NSString *htmlImgUrl = observations[indexPath.row][@"image"];
    
    // If the string is not NSNULL
    if(htmlImgUrl != (id)[NSNull null]){
        
        // strip HTML tags from URL
        NSString *imgURL = [self retrieveImageURLFromString:htmlImgUrl];
        
        // create NSURL and use UIImage_AFNetworking method to
        // load image
        NSURL *url = [NSURL URLWithString:imgURL];
        [cell.imgThumbnail setImageWithURL:url];
    }
    
    
    // Extract observation data from observation
    NSString *title = observations[indexPath.row][@"title"];
    NSString *user = observations[indexPath.row][@"name"];
    
    
    // Populate Cell with observation data
    cell.observationName.text = title;
    cell.username.text = user;
    
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/


// allows for the login screen to return to this view controller upon completion
- (IBAction)prepareForUnwindSegue:(UIStoryboardSegue *) segue{

}


- (NSString *) retrieveImageURLFromString: (NSString *)string {
    
    
    // Find the first occurence of the substring "src" and store its location
    NSRange locationOfSubstring = [string rangeOfString:@"src="];
    int startIndex = locationOfSubstring.location;
    
    // - Clip the string starting from the location of "src="
    // - Clip "src=" in the process (+5)
    // - Store the location of the first whitespace following the url
    NSString *tailString = [string substringFromIndex:startIndex+5];
    NSRange endIndex = [tailString rangeOfString:@" "];
    
    
    // - Clip everything from the string following the whitespace
    // - (-1) clips off the closing quotation around the URL
    NSString *imgURL = [tailString substringToIndex:endIndex.location-1];
    
    return imgURL;
}


// fetches the observations
- (void) fetchObservations{
    
    
    // fetch the newest observations from services_view
    [DIOSView viewGet: [[NSDictionary alloc] initWithObjects: [[NSArray alloc]
                                                               initWithObjects:@"newest_mobile", nil]
                                                     forKeys:  [[NSArray alloc]
                                                                initWithObjects:@"view_name", nil]
                        ]
              success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
         // grab list of newest observations, and update
         // collectionview
         observations = responseObject ;
         [self.collectionView reloadData];
         
     }
              failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
                  NSLog(@"%@",error);
    }
     ];
}


@end
