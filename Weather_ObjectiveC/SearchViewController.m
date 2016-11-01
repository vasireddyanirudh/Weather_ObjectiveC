//
//  SearchViewController.m
//  Weather_ObjectiveC
//
//  Created by Anirudh Reddy on 10/18/16.
//  Copyright © 2016 anirudh reddy. All rights reserved.
//

#import "SearchViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <AddressBookUI/AddressBookUI.h>
#import <Contacts/CNContact.h>
#import <MapKit/MapKit.h>



static NSString *API_KEY = @"a62177d994c36315743e0a2469572630";

static NSString *BASE_URL = @"http://api.openweathermap.org/data/2.5/weather";

@interface SearchViewController ()
@property (strong,nonatomic) LocationModel *locationModel;
@property (strong,nonatomic) NSArray      *savedLocation;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchTableView.delegate = self;

    self.locArry = [NSMutableArray array];
    NSData  *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"loc1"];
    _savedLocation = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma UITableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0) {
        return  1;
    }
    return _savedLocation.count;
    
}

#pragma UITable View Delegate.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellId = @"suggestionCell";
    UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    cell = [self.searchTableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    if(cell==nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    if(indexPath.section == 0){ //search results section
            cell.textLabel.text = self.suggestions;
    }
    else if (indexPath.section == 1) {   //saved locations sections.
        cell.textLabel.text = [_savedLocation objectAtIndex:indexPath.row];
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        [self saveLocations];
        [self.delegate selectedLocation:_locationModel];
        [self.navigationController popViewControllerAnimated:YES];
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


#pragma searchBar Delegate

- (void)searchBar:(UISearchBar *)theSearchBar textDidChange:(NSString *)searchText {
    
        [self getPlaceService:searchText];
}


-(void)getPlaceService:(NSString *)word{
    
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery = word;
    
    MKLocalSearch *search = [[MKLocalSearch alloc]initWithRequest:request];
    
    [search startWithCompletionHandler:^(MKLocalSearchResponse * _Nullable response, NSError * _Nullable error) {
        if (response.mapItems.count == 0)
            NSLog(@"No Matches");
        else
            for (MKMapItem *item in response.mapItems)
            {
//                if (item.placemark.locality != NULL && item.placemark.subAdministrativeArea != NULL && item.placemark.postalCode!= NULL) {
                
                NSString *cityName = item.placemark.locality;
                NSString *zipcode  = item.placemark.postalCode;
                NSString *ISOCode  = item.placemark.ISOcountryCode;
                self.locationModel = [[LocationModel alloc] initwithcityName:cityName
                                                                   zipCode:zipcode
                                                            ISOCountryCode:ISOCode];
            self.suggestions = [NSString stringWithFormat:@"%@,%@,%@",cityName,zipcode,ISOCode];
            }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.searchTableView reloadData];
        });
    }];
    
}



-(void)saveLocations{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *savedEncodedLoc      = [NSData data];
    [_locArry addObject:self.suggestions];
    
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"loc1"];
    NSMutableArray *retrievedArry = [[NSKeyedUnarchiver unarchiveObjectWithData:data] mutableCopy];
    
    if (!retrievedArry || !retrievedArry.count) {
        savedEncodedLoc = [NSKeyedArchiver archivedDataWithRootObject:_locArry];
    }else{
        
        [retrievedArry addObject:self.suggestions];
        savedEncodedLoc = [NSKeyedArchiver archivedDataWithRootObject:retrievedArry];
    }
    [userDefaults setObject:savedEncodedLoc forKey:@"loc1"];
    [userDefaults synchronize];
}

@end
