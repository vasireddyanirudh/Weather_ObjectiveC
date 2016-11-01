//
//  WeatherViewController.m
//  Weather_ObjectiveC
//
//  Created by Anirudh Reddy on 10/18/16.
//  Copyright © 2016 anirudh reddy. All rights reserved.
//

#import "WeatherViewController.h"

static NSString *kWeatherModelKey = @"mr";
static NSString *kLocationKey = @"vr";
static NSString *API_KEY = @"a62177d994c36315743e0a2469572630";
static NSString *BASE_URL = @"http://api.openweathermap.org/data/2.5/weather";

@interface WeatherViewController() <SelectedCityProtocol>
{
    CLLocationManager *locationManager;
    CLLocation        *currentLocation;
    NSArray           *savedArray;
    //checks if data is being updates.
    BOOL              *isReloading;
    BOOL              *returnedAddress;

}
@property(nonatomic) BOOL *checkNetwork;
@property(nonatomic,strong) NSMutableArray *savedWeatherArray; //weather model array
@property(nonatomic,strong) NSMutableArray *addressArry;     // Destination URL Array.
@property(nonatomic,strong) WeatherModel   *weatherModel;
@property(nonatomic,strong) LocationModel  *locationModel;

@end

@implementation WeatherViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    _savedWeatherArray = [NSMutableArray array];
    _addressArry       = [NSMutableArray array];
    
    [self retrieveDiskData];
    
       if(!_savedWeatherArray || !_savedWeatherArray.count){
        [self getCurrentLocation];
    }
    
    [NSTimer scheduledTimerWithTimeInterval:9999.0
                                     target:self
                                   selector:@selector(timerFired)
                                   userInfo:nil
                                    repeats:YES];
}

-(void)viewDidAppear:(BOOL)animated{

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)retrieveDiskData{
    
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:kWeatherModelKey];
    _savedWeatherArray   = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    data = [[NSUserDefaults standardUserDefaults] objectForKey:kLocationKey];
    _addressArry   =  [[NSKeyedUnarchiver unarchiveObjectWithData:data] mutableCopy];

}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"SearchVC"]) {
        SearchViewController *searchVC = [[SearchViewController alloc] init];
        searchVC.delegate = self;
    }    
}

//pass location address to the servivce layer.
-(void)getLocationWeather:(LocationModel *)location{
    NSString *urlString;
    
    if (!isReloading) {
        [self.addressArry addObject:location];
        [self saveAddressString:location];
    }
    
    if(location.cityName != nil){
        urlString = [NSString stringWithFormat:@"%@?q=%@,%@&APPID=%@",BASE_URL,location.cityName,location.ISOCode,API_KEY];
    }else if(location.zipcode != nil){
        urlString = [NSString stringWithFormat:@"%@?zip=%@,%@&APPID=%@",BASE_URL,location.zipcode,location.ISOCode,API_KEY];
    }
    urlString = [urlString stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSURL *destinationURL = [NSURL URLWithString:urlString];
    // save location address in disk.
    [self getServiceLayer:destinationURL];
}

#pragma Selected City Delegate.
-(void)selectedLocation:(LocationModel *)location{
    [self getLocationWeather:location];
}

-(void)getServiceLayer:(NSURL *)destinationUrl{
    // Create URL request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:destinationUrl];
    [request setHTTPMethod:@"GET"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    if([self isNetworkAvailable]){
        // Start data session
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if(data != nil){
            _weatherModel = [[WeatherModel alloc] initWithDictionary:data];
                //adding the weather model to array
            [self.savedWeatherArray addObject:_weatherModel];
                // saving the return weather model.
            [self saveLocationsData:_weatherModel];
                
                //TODO : check if this approach is working.
                if (isReloading) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSArray *visibleRows = [self.tableView indexPathsForVisibleRows];
                        [self.tableView reloadRowsAtIndexPaths:visibleRows withRowAnimation:UITableViewRowAnimationAutomatic];
                    });
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.tableView reloadData];
                       
                    });
                }
                    
            }else{
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Cannot Retrieve Data" message:@"Please retry!" preferredStyle:UIAlertControllerStyleAlert];
              
                [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    [self dismissViewControllerAnimated:YES completion:nil];
                }]];
                [self presentViewController:alert animated:YES completion:nil];
            }
        }];
        [task resume];
    }
}

- (IBAction)searchPressed:(id)sender {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SearchViewController *searchVC = [storyBoard instantiateViewControllerWithIdentifier:@"SearchViewController"];
    searchVC.delegate = self;
    [self.navigationController showViewController:searchVC sender:nil];
}

-(void)getCurrentLocation{
    
    locationManager = [CLLocationManager new];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        [locationManager requestWhenInUseAuthorization];
    [locationManager startUpdatingLocation];
   
//    if ([CLLocationManager locationServicesEnabled]){
//        if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied){
////            alert = [[UIAlertView alloc] initWithTitle:@"App Permission Denied"
//                                               message:@"To re-enable, please go to Settings and turn on Location Service for this app."
//                                              delegate:nil
//                                     cancelButtonTitle:@"OK"
//                                     otherButtonTitles:nil];
//            [alert show];
//        }else{
//            
//            [self currentLocationWeather];
//            
//        }
//    }
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    currentLocation = (CLLocation *)[locations lastObject];
    
    CLGeocoder* geoCoder = [[CLGeocoder alloc] init];
    
    [geoCoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark = [placemarks lastObject];
        
        NSString *cityName = placemark.locality;
        NSString *zipcode  = placemark.postalCode;
        NSString *ISOCode  = placemark.ISOcountryCode;
        
        if(!returnedAddress){
        _locationModel = [[LocationModel alloc] initwithcityName:cityName
                                                         zipCode:zipcode
                                                  ISOCountryCode:ISOCode];
        //saving the current location address.
        [self getLocationWeather:_locationModel];
            returnedAddress = YES;
        }
        //TODO : check if reverse geo coding is working and remove below line
        //[self saveAddressString:_locationModel];
    }];
}

- (void) dealloc
{
    [locationManager stopUpdatingLocation];
}

#pragma UITableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _savedWeatherArray.count;
}

#pragma  UITabelView Delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        NSString *cellId = @"weatherCell";
        WeatherTableViewCell *cell = (WeatherTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
        cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
        if(cell==nil){
            cell = [[WeatherTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
        }
            _weatherModel        = [_savedWeatherArray objectAtIndex:indexPath.row];
            _locationModel       = [_addressArry objectAtIndex:indexPath.row];
           cell.cityName.text    = [NSString stringWithFormat:@"%@",_locationModel.cityName];
           cell.temperature.text = [NSString stringWithFormat:@"%f-F",(([_weatherModel.temperature doubleValue]*(9.0/5.0)) - 459.67)];
           cell.humidity.text    = [NSString stringWithFormat:@"%@ percent ",_weatherModel.precipitation];
           cell.minTemp.text     = [NSString stringWithFormat:@"min:%f ",(([_weatherModel.minTemperature doubleValue]*(9.0/5.0)) - 459.67)];
           cell.maxTemp.text     = [NSString stringWithFormat:@"max:%f ",(([_weatherModel.maxTemperature doubleValue]*(9.0/5.0)) - 459.67)];
    
    return cell;

}

-(void)saveLocationsData:(WeatherModel *)location{

    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:kWeatherModelKey];
    NSMutableArray *retrievedArry = [[NSKeyedUnarchiver unarchiveObjectWithData:data] mutableCopy];

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *savedEncodedLoc      = [NSData data];
    
    if (!retrievedArry || !retrievedArry.count) {
        NSMutableArray *temparry = [NSMutableArray arrayWithObject:location];
        savedEncodedLoc = [NSKeyedArchiver archivedDataWithRootObject:temparry];
    }else{
        
        [retrievedArry addObject:location];
        savedEncodedLoc = [NSKeyedArchiver archivedDataWithRootObject:retrievedArry];
    }
    [userDefaults setObject:savedEncodedLoc forKey:kWeatherModelKey];
    [userDefaults synchronize];
}

-(void)saveAddressString:(LocationModel*)destination{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *savedUrlData         = [NSData data];
    
    //checking for previously saved array.
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:kLocationKey];
    NSMutableArray *retrievedArry = [[NSKeyedUnarchiver unarchiveObjectWithData:data] mutableCopy];
    
    if (!retrievedArry || !retrievedArry.count) {
        NSMutableArray *temparry = [NSMutableArray arrayWithObject:destination];
        savedUrlData = [NSKeyedArchiver archivedDataWithRootObject:temparry];
    }else{
        [retrievedArry addObject:destination];
        savedUrlData = [NSKeyedArchiver archivedDataWithRootObject:retrievedArry];
    }
    [userDefaults setObject:savedUrlData forKey:kLocationKey];
    [userDefaults synchronize];
}

-(void)timerFired{
    
    //TODO : approach 1. using a is reloading flag to check.
    isReloading = YES;
    
    for (LocationModel  *location in _addressArry) {
        [self getLocationWeather:location];
    }
    
//    //TODO : approach 2 . go home and check.
//    for (LocationModel  *location in _addressArry) {
//        NSString *urlString;
//        if(location.cityName != nil){
//            urlString = [NSString stringWithFormat:@"%@?q=%@,%@&APPID=%@",BASE_URL,location.cityName,location.ISOCode,API_KEY];
//        }else if(location.zipcode != nil){
//            urlString = [NSString stringWithFormat:@"%@?zip=%@,%@&APPID=%@",BASE_URL,location.zipcode,location.ISOCode,API_KEY];
//        }
//        urlString = [urlString stringByReplacingOccurrencesOfString:@" " withString:@""];
//        NSURL *destinationURL = [NSURL URLWithString:urlString];
//        // save location address in disk.
//        [self reloadService:destinationURL];
//    }
}

-(void)reloadService:(NSURL *)destinationUrl{
    // Create URL request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:destinationUrl];
    [request setHTTPMethod:@"GET"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    if([self isNetworkAvailable]){
        // Start data session
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if(data != nil){
                _weatherModel = [[WeatherModel alloc] initWithDictionary:data];
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSArray *visibleRows = [self.tableView indexPathsForVisibleRows];
                    [self.tableView reloadRowsAtIndexPaths:visibleRows withRowAnimation:UITableViewRowAnimationAutomatic];
                });
            }else{
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Cannot Retrieve Data" message:@"Please retry!" preferredStyle:UIAlertControllerStyleAlert];
                
                [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    [self dismissViewControllerAnimated:YES completion:nil];
                }]];
                [self presentViewController:alert animated:YES completion:nil];
            }
        }];
        [task resume];
    }
}

- (BOOL)isNetworkAvailable
{
    CFNetDiagnosticRef dReference;
    
    dReference = CFNetDiagnosticCreateWithURL (NULL, (__bridge CFURLRef)[NSURL URLWithString:@"www.google.com"]);
    
    CFNetDiagnosticStatus status;
    status = CFNetDiagnosticCopyNetworkStatusPassively (dReference, NULL);
    
    CFRelease (dReference);
    
    if ( status == kCFNetDiagnosticConnectionUp )
    {
        NSLog (@"Connection is Available");
        return YES;
    }
    else
    {
        NSLog (@"Connection is down");
        return NO;
    }
}

-(double) fahrenheitValue{

    return (([_weatherModel.temperature doubleValue]*(9.0/5.0)) - 459.67);
}

-(double) celsiusValue
{
    return ([_weatherModel.temperature doubleValue] - 273.15);
}





@end
