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
    NSMutableArray *observations;
    UIRefreshControl *refresh;
    NSMutableData *_responseData;
    int pageSize;
    int item_offset;
    BOOL no_new_items;
    UIActivityIndicatorView *loadingIndicator;
    UILabel *no_more_items;
    
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
    
    // initialize variables
    observations = [[NSMutableArray alloc] init];
    pageSize = 10;
    item_offset = 0;
    no_new_items = NO;
    
    no_more_items = [[UILabel alloc] init];
    [no_more_items setText:@"No More Items"];
    [no_more_items setTextAlignment:NSTextAlignmentCenter];

    
    // Configure size of collectionview footer
    // Configure size of loading icon based on size of footer
    // ------------------------------------------------------------------------------
    double footerWidth = self.view.frame.size.width;
    double footerHeight = 50;
    double indicatorWidth = 20;
    double indicatorHeight = 20;
    double indicator_x = (footerWidth / 2) - (indicatorWidth / 2);
    double indicator_y = (footerHeight / 2) - (indicatorHeight / 2);
    
    // create & configure loading icon
    loadingIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(indicator_x,
                                                                                 indicator_y,
                                                                                 indicatorWidth,
                                                                                 indicatorHeight)];
    [loadingIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [loadingIndicator setHidesWhenStopped:YES];
    
    
    
    
    // if we are connected to the internet
    // ------------------------------------------------------------------------------
    if([AFNetworkReachabilityManager sharedManager].reachable){
        [self fetchObservations:pageSize offset:item_offset];
    }
    
    
    
    // Register this class for network changes
    // ------------------------------------------------------------------------------
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(networkStatusChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    
    
    // Pull to refresh
    // -----------------------------------------------------------------------------
    refresh = [[UIRefreshControl alloc] init];
    [refresh addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    
    [self.collectionView addSubview:refresh];
    
}


- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL isLoggedIn  = [[defaults objectForKey:@"isLoggedIn"] boolValue];
    
    // If use is logged in, present option to create observations
    if(isLoggedIn){
        fabView = [VCUtility initFABView];
        [self.view addSubview:fabView];
    }
}



- (void) networkStatusChanged:(NSNotification*)notification{
    // If network connection goes from unreachable to reachable, fetch
    // observations
    if([AFNetworkReachabilityManager sharedManager].reachable){
        [self fetchObservations:pageSize offset:item_offset];
    }
}



- (void) refresh:(UIRefreshControl *)refreshControl{
    
    // reset observation list
    item_offset = 0;
    observations = [[NSMutableArray alloc] init];
    no_new_items = NO;
    
    no_more_items = [[UILabel alloc] init];
    [no_more_items setText:@"No More Items"];
    [no_more_items setTextAlignment:NSTextAlignmentCenter];
    
    
    [self fetchObservations:pageSize offset:item_offset];
    
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
    
    // if we reach the bottom of the screen, try to load more
    if(indexPath.row == observations.count-1){
        
        // fetch if we know there are more observations on the server
        if(!no_new_items){
            item_offset += pageSize;
            [self fetchObservations:pageSize offset:item_offset];
            [loadingIndicator startAnimating];
        }
    }
    
    
    
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
    [obsViewContr reload]; //reload the view after it receives its data
    
    [self.navigationController pushViewController:obsViewContr animated:YES];
}



- (UICollectionReusableView *)collectionView:(UICollectionView *)theCollectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)theIndexPath
{
    
    UICollectionReusableView *theView;
    
    if(kind == UICollectionElementKindSectionHeader)
    {
        theView = [theCollectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                        withReuseIdentifier:@"header"
                                                               forIndexPath:theIndexPath];
    } else {
        theView = [theCollectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                                                        withReuseIdentifier:@"footer"
                                                               forIndexPath:theIndexPath];
        
        // position indicator in the middle of the footer
        if(no_new_items){
            no_more_items.frame = CGRectMake(0,
                                             0,
                                             theView.frame.size.width,
                                             theView.frame.size.height);
            
            [theView addSubview:no_more_items];
        }
        else {
        
            if(![loadingIndicator isDescendantOfView:theView])
                [theView addSubview:loadingIndicator];
            
            [loadingIndicator startAnimating];
        }
    }
    
    return theView;
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
- (void) fetchObservations:(int)numberOfItems offset:(int)offset {

    
    NSURLComponents *requestURL =
    [[NSURLComponents alloc]
     initWithString:@"http://137.149.157.10/cs482/mobile-api/newest-observations-mobile"];
    
    
    NSURLQueryItem *q_num_items = [[NSURLQueryItem alloc] initWithName:@"num_items"
                                                                value:[NSString stringWithFormat:@"%d",numberOfItems]];
    
    NSURLQueryItem *q_offset = [[NSURLQueryItem alloc] initWithName:@"offset"
                                                                    value:[NSString stringWithFormat:@"%d",offset]];
    requestURL.queryItems = @[q_num_items,q_offset];
    
    
    // Set up URL for one-time request to Newest Observations
    NSMutableURLRequest *request =
        [NSMutableURLRequest requestWithURL:requestURL.URL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
    
    
    // Set Request to GET, and specify JSON
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPMethod:@"GET"];
    
    
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}




#pragma mark NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
    
    _responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the instance variable you declared
    [_responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    // convert data to JSON
    NSError *error = nil;
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:_responseData options:kNilOptions error:&error];
    
    // the server has run out of new observations
    if(jsonArray.count < pageSize){
        no_new_items = YES;
        
    }
    
    
    NSLog(@"Observations: %lu",(unsigned long)observations.count);
    
    [loadingIndicator stopAnimating];
    [observations addObjectsFromArray:jsonArray];
    
    
    NSLog(@"Observations: %lu",(unsigned long)observations.count);
    
    [self.collectionView reloadData];
    [refresh endRefreshing];
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
    NSLog(@"%@",error);
}

@end
