//
//  ObservationCollectionViewController.m
//  DrupalAPITester
//
//  Created by William Millington on 2016-03-01.
//  Copyright © 2016 William Millington. All rights reserved.
//

#import "ObservationCollectionViewController.h"



@interface ObservationCollectionViewController ()
@end


@implementation ObservationCollectionViewController{
//    NSMutableArray *observations;
    NSArray *observations;
}

@synthesize fabView;

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
    
    
    observations = [[NSMutableArray alloc] init];

    
    if([AFNetworkReachabilityManager sharedManager].reachable){
        [self fetchObservations];
    }
    
    
    
    
    
    
    
    // Register this class for network changes
    // ------------------------------------------------------------------------------
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(networkStatusChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    
}


- (void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL isLoggedIn  = [[defaults objectForKey:@"isLoggedIn"] boolValue];
    
    if(isLoggedIn){
        fabView = [VCUtility initFABView];
        [self.view addSubview:fabView];
    }
}



- (void) networkStatusChanged:(NSNotification*)notification{
    if([AFNetworkReachabilityManager sharedManager].reachable){
        [self fetchObservations];
    }
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
    
    // grab observation
    NSDictionary *observation = observations[indexPath.row];
    
    
    // Retrieve the html string detailing the URL of the image
    NSString *htmlImgUrl = observation[@"image"];
    
    // If the string is not NSNULL
    if(htmlImgUrl != (id)[NSNull null]){
        NSString *imgURL = [self retrieveImageURLFromString:htmlImgUrl];
        
        // create NSURL and use UIImage_AFNetworking method to
        // load image
        NSURL *url = [NSURL URLWithString:imgURL];
        [cell.imgThumbnail setImageWithURL:url];
    }
    
    // Extract observation data from observation
    cell.observation_title.text = observation[@"title"];
    cell.username.text = observation[@"author_name"];
    cell.nid = observation[@"nid"];
    cell.uid = observation[@"uid"];
    cell.field_date_observed = observation[@"field_date_observed"];
    
    return cell;
}


-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    ObservationViewController *obsViewContr = [[ObservationViewController alloc] initWithNibName:@"ObservationViewController" bundle:nil];
    
    ObservationCollectionViewCell *cell = (ObservationCollectionViewCell *) [collectionView cellForItemAtIndexPath:indexPath];
    
    
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    
    [data setObject:cell.nid forKey:@"nid"];
    [data setObject:cell.uid forKey:@"uid"];
    
    obsViewContr.cellData = data;
    [obsViewContr reload];
    
    [self.navigationController pushViewController:obsViewContr animated:YES];
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
    
    
//    NSLog(@"FETCH OBSERVATIONS");
    
    // Set up URL for one-time request to Newest Observations
    NSMutableURLRequest *request =
        [NSMutableURLRequest requestWithURL:
         [NSURL URLWithString:@"http://137.149.157.10/cs482/mobile-api/newest-observations-mobile"] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
    
    // Set Request to GET, and specify JSON
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPMethod:@"GET"];
    
    // Set up error and response objects
    NSError *requestError = nil;
    NSURLResponse *response = nil;
    
    // Send request
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&requestError];
    
    // Convert data into JSON
    NSError *error = nil;
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    
    // load observation into observations list
    observations = jsonArray;
    
    [self.collectionView reloadData];
}


@end
