//
//  SearchViewController.h
//  Weather_ObjectiveC
//
//  Created by Anirudh Reddy on 10/18/16.
//  Copyright © 2016 anirudh reddy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeatherViewController.h"
#import "WeatherModel.h"
#import "LocationModel.h"
@protocol SelectedCityProtocol

@optional

-(void)selectedLocation:(LocationModel *)location;

@end

@interface SearchViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
//search controller
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *searchTableView;
@property (copy, nonatomic)  NSString *suggestions;
@property (strong, nonatomic)  NSMutableArray *locArry;
@property (weak, nonatomic) IBOutlet UILabel *searchResultsLabel;
@property (weak, nonatomic) id<SelectedCityProtocol> delegate;

@end
