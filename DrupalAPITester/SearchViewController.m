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

@interface SearchViewController ()

@end

@implementation SearchViewController{
    UIView *dimView;
    UIVisualEffectView *searchPanel;
    SearchPanelView *SPControls;
    Boolean searchPanelVisible;
}

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
    
    
    
    
    // Define search panel backdrop blur effect and create searchPanel with it
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    searchPanel = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    
    // Create search panel controls from Nib
    SPControls = [[[NSBundle mainBundle] loadNibNamed:@"SearchPanel" owner:nil options:nil] objectAtIndex:0];
    [SPControls setBackgroundColor:[UIColor clearColor]];
    
    // Create view that will provide "dimming" effect on collection view
    dimView = [[UIView alloc] initWithFrame:
                                CGRectMake(0, 0,
                                           self.view.frame.size.width,
                                           self.view.frame.size.height)
               ];
    [self.view addSubview:dimView];
    
    // define panel height, create panel frame
    // (-panelheight) the searchPanel is created off-screen
    int panelHeight = SPControls.frame.size.height;
    
    searchPanel.frame = CGRectMake(0, -panelHeight, 320, panelHeight);
    SPControls.frame = CGRectMake(0, 0, 320, panelHeight);
    
    // add SPControls to the blur backdrop
    // add searchPanel to this View Controller
    [searchPanel addSubview:SPControls];
    [self.view addSubview:searchPanel];
    
    
    
    
    // Grab and configure Side Menu Controller
    SWRevealViewController *revealViewController = self.revealViewController;
    if (revealViewController){
        [sidebarButton setTarget: self.revealViewController];
        [sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ObservationCollectionViewCell *cell = [super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    
    
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
        int dimViewOriginX = 0;
        int dimViewOriginY = searchPanel.frame.size.height;
        int dimViewWidth = self.view.frame.size.width;
        int dimViewHeight = self.view.frame.size.height;
        
        dimView.frame = CGRectMake(dimViewOriginX,
                                   dimViewOriginY,
                                   dimViewWidth,
                                   dimViewHeight);
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
        int dimViewOriginX = 0;
        int dimViewOriginY = 0;
        int dimViewWidth = self.view.frame.size.width;
        int dimViewHeight = self.view.frame.size.height;
        
        dimView.frame = CGRectMake(dimViewOriginX,
                                   dimViewOriginY,
                                   dimViewWidth,
                                   dimViewHeight);
        [dimView setBackgroundColor:[UIColor clearColor]];
        [dimView setAlpha:1.0];
        
        // Begin animation
        [UIView commitAnimations];
    }
    
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
