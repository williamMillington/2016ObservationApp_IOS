//
//  ObservationViewController.m
//  ObservationApp
//
/**	 ObservationApp, Copyright 2016, University of Prince Edward Island,
 *    550 University Avenue, C1A4P3,
 *    Charlottetown, PE, Canada
 *
 * 	 @author William Millington<wmillington@upei.ca>
 *
 *   This file is part of ObservationApp.
 *
 *   ObservationApp is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation, either version 3 of the License, or
 *   (at your option) any later version.
 *
 *
 *   You should have received a copy of the GNU General Public License
 *   along with Observation App.  If not, see <http://www.gnu.org/licenses/>.
 */

#import "ObservationViewController.h"


@interface ObservationViewController ()
{
    NSMutableData *_responseData;
    UIActivityIndicatorView *spinner;
}
@end

@implementation ObservationViewController

@synthesize location;
@synthesize observation;
@synthesize user;
@synthesize map;
@synthesize user_image;


- (void)viewDidLoad {
    [super viewDidLoad];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// Method called when the User's picture is tapped to navigate to User page
- (IBAction)openUser:(id)sender {
    
    
}


- (void) reload{
    [self fetchObservationData:[self.cellData objectForKey:@"nid"]];
}


- (void) fetchObservationData:(NSString *)nid{
    
    NSURLComponents *requestURL =
    [[NSURLComponents alloc]
     initWithString:@"http://137.149.157.10/cs482/mobile-api/single-node-detail-mobile"];
    
    NSURLQueryItem *q_item_nid = [[NSURLQueryItem alloc] initWithName:@"nid"
                                                                value:nid];
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


- (void) fetchUser:(NSString *) uid{
    
    NSURLComponents *requestURL =
    [[NSURLComponents alloc]
     initWithString:@"http://137.149.157.10/cs482/mobile-api/user-mobile"];
    
    NSURLQueryItem *q_item_nid = [[NSURLQueryItem alloc] initWithName:@"uid"
                                                                value:uid];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


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
    
    
    if([url rangeOfString:@"single-node-detail-mobile"].length != 0){
        observation = jsonArray[0];
        NSString *urlString = observation[@"Image"];
        NSString *urlString_userPic = observation[@"user_picture"];
        
        if(urlString.length > 0){
            
            NSURL *url = [NSURL URLWithString:[self retrieveImageURLFromString:urlString]];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                NSData *imageData = [NSData dataWithContentsOfURL:url];
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIImage *picture = [UIImage imageWithData:imageData];
                    [self.observation_image setImage:picture];
                });
            });
        }
        
        if(urlString_userPic.length > 0){
            NSURL *url_userPic =
                [NSURL URLWithString:[self retrieveImageURLFromString:urlString_userPic]];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                NSData *imageData = [NSData dataWithContentsOfURL:url_userPic];
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIImage *picture = [UIImage imageWithData:imageData];
                    [user_image setBackgroundImage:picture forState:UIControlStateNormal];
                });
            });
        }
        
        [self updateView];
    }
    else {
        user = jsonArray[0];
    }
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
    NSLog(@"%@",error);
}

- (void) updateView {
    
    [_observation_title setText: [observation objectForKey:@"title"]];
    
    NSString *dateString = [observation objectForKey:@"Date Observed"];
    [_date_observed setText: dateString];
    
    NSDictionary *coords = [observation objectForKey:@"Location lat/long"];
    
    
    // If there are coordinates
    if([coords count] > 0){
        double lon = [[coords objectForKey:@"lon"] doubleValue];
        double lat = [[coords objectForKey:@"lat"] doubleValue];
        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(lat, lon);
        [self updateMap:coord];
    }
}


- (void) updateMap:(CLLocationCoordinate2D)coord{
    
    MKPointAnnotation *pin = [[MKPointAnnotation alloc] init];
    pin.coordinate = coord;
    pin.title = _observation_title.text;
    pin.subtitle = _date_observed.text;
    
    MKCoordinateRegion region =
    MKCoordinateRegionMakeWithDistance(coord, METERS_PER_MILE, METERS_PER_MILE);
    
    [map setRegion:region animated:YES];
    [map addAnnotation:pin];
    
    
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

@end
