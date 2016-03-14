//
//  SearchViewController.m
//  DrupalAPITester
//
//  Created by William Millington on 2016-03-09.
//  Copyright © 2016 William Millington. All rights reserved.
//

#import "SearchViewController.h"
#import "SWRevealViewController.h"
#import "SearchPanelView.h"
#import "ObservationCollectionViewCell.h"

#import "DIOSNode.h"
#import "DIOSView.h"
#import "UIImage+AFNetworking.h"
#import "UIImageView+AFNetworking.h"

@interface SearchViewController ()

@end

@implementation SearchViewController{
    UIView *dimView;
    UIVisualEffectView *searchPanel;
    SearchPanelView *SPControls;
    Boolean searchPanelVisible;
    
    NSArray *observations;
    
}

//@synthesize observations;
static NSString* const reuseIdentifier = @"ObservationCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
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
    dimView = [[UIView alloc] initWithFrame:
                                CGRectMake(0, 0,
                                           self.view.frame.size.width,
                                           self.view.frame.size.height)
               ];
    
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
    
    
//    observations = [[NSArray alloc] init];
//    // only load from source on first instance of viewDidLoad
//    [self fetchObservations];
    
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
