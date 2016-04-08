//
//  SearchViewController.m
//  DrupalAPITester
//
//  Created by William Millington on 2016-03-09.
//  Copyright © 2016 William Millington. All rights reserved.
//

#import "SearchViewController.h"

@interface SearchViewController ()
{
    NSMutableData *_responseData;
}

@end

@implementation SearchViewController{
    UIView *dimView;
    UIVisualEffectView *searchPanel;
    SearchPanelView *SPControls;
    Boolean searchPanelVisible;
    
    NSArray *observations;
    
}

@synthesize fabView;
static NSString* const reuseIdentifier = @"ObservationCell";




- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Configure the menu button on the leftside
    UIBarButtonItem *sidebarButton = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style: UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.leftBarButtonItem = sidebarButton;
    
    // Define search bar and add it to menu
    UISearchBar *searchbar = [[UISearchBar alloc] init];
    self.navigationItem.titleView = searchbar;
    
    // Define search panel toggle button and add it to menu
    UIBarButtonItem *searchToggleButton = [[UIBarButtonItem alloc] initWithTitle:@"expand" style: UIBarButtonItemStylePlain target:self action:@selector(toggleSearchPanel)];
    self.navigationItem.rightBarButtonItem = searchToggleButton;
    
    // Grab and configure Side Menu Controller
    SWRevealViewController *revealViewController = self.revealViewController;
    if (revealViewController){
        [sidebarButton setTarget: self.revealViewController];
        [sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    
    
    // Create searchPanel with blur effect
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    searchPanel = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    
    // Create search panel controls from Nib
    SPControls = [[[NSBundle mainBundle] loadNibNamed:@"SearchPanel" owner:nil options:nil] objectAtIndex:0];
    [SPControls setBackgroundColor:[UIColor clearColor]];
    
    // Create view that will provide "dimming" effect on collection view
    // when control panel is showing
    dimView = [[UIView alloc] initWithFrame: CGRectMake(0, 0,
                                                        self.view.frame.size.width,
                                                        self.view.frame.size.height)
               ];
    [dimView setUserInteractionEnabled:NO]; 
    
    // - define panel height, create panel frame
    // - the searchPanel is created off-screen (-panelheight)
    int panelHeight = SPControls.frame.size.height;
    int panelWidth = SPControls.frame.size.width;
    searchPanel.frame = CGRectMake(0, -panelHeight, panelWidth, panelHeight);
    SPControls.frame = CGRectMake(0, 0, panelWidth, panelHeight);
    
    
    
    // add SPControls to the searchPanel
    // add searchPanel to this View Controller
    // add the dimView to this View Controller
    [searchPanel addSubview:SPControls];
    [self.view addSubview:searchPanel];
    [self.view addSubview:dimView];
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




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


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
    NSString *htmlImgUrl = observation[@"Image"];
    
    // If the string is not NSNULL
    if(htmlImgUrl != (id)[NSNull null]){
        
        // strip HTML tags from URL
        NSString *imgURL = [self retrieveImageURLFromString:htmlImgUrl];
        
        // create NSURL and use UIImage_AFNetworking method to
        // load image
        NSURL *url = [NSURL URLWithString:imgURL];
        [cell.imgThumbnail setImageWithURL:url];
    }
    
//    NSLog(@"%@",observation);
    
    // Extract observation data from observation
    NSString *title = observation[@"title"];
    NSString *user = observation[@"name"];
    cell.nid = observation[@"Nid"];
    cell.uid = observation[@"uid"];
    cell.field_date_observed = observation[@"field_date_observed"];
    
    // Populate Cell with observation data
    cell.observation_title.text = title;
    cell.username.text = user;
    
    
    return cell;
}


-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    ObservationViewController *obsViewContr = [[ObservationViewController alloc] initWithNibName:@"ObservationViewController" bundle:nil];
    
    ObservationCollectionViewCell *cell = (ObservationCollectionViewCell *) [collectionView cellForItemAtIndexPath:indexPath];
    
    
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    
    [data setObject:cell.nid forKey:@"nid"];
    
    obsViewContr.cellData = data;
    [obsViewContr reload];
    
    [self.navigationController pushViewController:obsViewContr animated:YES];
}



// Method responsible for toggling the reveal/hide
// of the search panel
- (void)toggleSearchPanel {
    
    if(!searchPanelVisible){
        
        // Set the top of the search panel to perfectly
        // align with th bottom of the navbar
        CGRect navbarFrame = self.navigationController.navigationBar.frame;
        CGRect newSearchPanelFrame = searchPanel.frame;
        newSearchPanelFrame.origin.y = (navbarFrame.origin.y + navbarFrame.size.height);
        
        // Animation parameters
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.25];
        [UIView setAnimationDelay:0.0];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        
        // Assign new coordinates to search panel
        searchPanel.frame = newSearchPanelFrame;
        searchPanelVisible = TRUE;
        
        // Dim the background
        int dimViewOriginY = searchPanel.frame.size.height
                                + (navbarFrame.origin.y + navbarFrame.size.height);
        int dimViewWidth = self.view.frame.size.width;
        int dimViewHeight = self.view.frame.size.height;
        
        dimView.frame = CGRectMake(0, dimViewOriginY, dimViewWidth, dimViewHeight);
        [dimView setBackgroundColor:[UIColor blackColor]];
        [dimView setAlpha:0.5];
        
        // Begin animation
        [UIView commitAnimations];
        
    }
    else {
        
        // Set search panel to disappear into the top of the
        // screen the entirety of its height
        CGRect newSearchPanelFrame = searchPanel.frame;
        newSearchPanelFrame.origin.y = -newSearchPanelFrame.size.height;
        
        // Animation parameters
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.25];
        [UIView setAnimationDelay:0.0];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        
        // Set new coordinates of search panel
        searchPanel.frame = newSearchPanelFrame;
        searchPanelVisible = FALSE;
        
        // un-dim the background
        int dimViewWidth = self.view.frame.size.width;
        int dimViewHeight = self.view.frame.size.height;
        
        dimView.frame = CGRectMake(0, 0, dimViewWidth, dimViewHeight);
        [dimView setBackgroundColor:[UIColor clearColor]];
        [dimView setAlpha:1.0];
        
        // Begin animation
        [UIView commitAnimations];
    }
}




// fetches the observations
- (void) fetchObservations:(NSMutableDictionary *)parameters{
    
//    NSLog(@"FETCH OBSERVATIONS");
    
    NSURLComponents *requestURL =
    [[NSURLComponents alloc]
     initWithString:@"http://137.149.157.10/cs482/mobile-api/search-mobile"];
    
    
    NSString *titleVal = [parameters objectForKey:@"title"];
    NSURLQueryItem *q_item_nid = [[NSURLQueryItem alloc] initWithName:@"title"
                                                                value:titleVal];
    requestURL.queryItems = @[q_item_nid];
    
    
    // Set up URL for one-time request to Newest Observations
    NSMutableURLRequest *request =
    [NSMutableURLRequest requestWithURL: requestURL.URL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30];
    
    // Set Request to GET, and specify JSON
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPMethod:@"GET"];
    
    // Create url connection and fire request
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
    
    NSString *url = [connection.currentRequest.URL absoluteString];
    
    // convert data to JSON
    NSError *error = nil;
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:_responseData options:kNilOptions error:&error];
    
    observations = jsonArray;
    
//    NSLog(@"%@",observations);
    
    
    [self.collectionView reloadData];
    [self toggleSearchPanel];
    
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
    NSLog(@"%@",error);
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
