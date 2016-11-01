//
//  WeatherViewController.h
//  Weather_ObjectiveC
//
//  Created by Anirudh Reddy on 10/18/16.
//  Copyright © 2016 anirudh reddy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

#import "WeatherTableViewCell.h"
#import "SearchViewController.h"
#import "WeatherModel.h"
#import "LocationModel.h"


@interface WeatherViewController : UIViewController<CLLocationManagerDelegate,UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *addCityButton;
@property (strong, nonatomic)  WeatherTableViewCell *weatherCell;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) IBOutlet UIVisualEffectView       *loadingView;



- (IBAction)searchPressed:(id)sender;
//retrieve location address and weather model array
-(void)retrieveDiskData;
//Retrieve users current location
-(void)getCurrentLocation;
//calls the service layer by city name or zip code.
-(void)getLocationWeather:(LocationModel *)location;
// creates a NSURL session for Open Weather API
-(void)getServiceLayer:(NSURL *)destinationUrl;
//saves weather data from API to Disk
-(void)saveLocationsData:(WeatherModel *)location;
//saves users address string to Disk
-(void)saveAddressString:(LocationModel*)destination;


@end
