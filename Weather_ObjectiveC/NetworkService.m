//
//  NetworkService.m
//  Weather_ObjectiveC
//
//  Created by Anirudh Reddy on 10/26/16.
//  Copyright © 2016 anirudh reddy. All rights reserved.
//

#import "NetworkService.h"

@implementation NetworkService

//static NSString *API_KEY = @"a62177d994c36315743e0a2469572630";
//static NSString *BASE_URL = @"http://api.openweathermap.org/data/2.5/weather";

//-(void)getService{
//    
//NSURL *destinationUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@?lat=%f&lon=%f&APPID=%@",BASE_URL,currentLocation.coordinate.latitude,currentLocation.coordinate.longitude,API_KEY]];
//NSLog(@"Calling Weather API on %@",destinationUrl);
//
//// Create URL request
//NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:destinationUrl];
//[request setHTTPMethod:@"GET"];
//
//NSURLSession *session = [NSURLSession sharedSession];
//
//// Start data session
//NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//    [self.activityIndicator stopAnimating];
//    self.activityIndicator.hidden = YES;
//    self.loadingView.hidden = YES;
//    weather= [[WeatherModel alloc] initWithDictionary:data];
//    [self.tableView reloadData];
//    
//    
//}];
//[task resume];
//
//}
@end
