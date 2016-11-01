//
//  WeatherTableViewCell.h
//  Weather_ObjectiveC
//
//  Created by Anirudh Reddy on 10/19/16.
//  Copyright © 2016 anirudh reddy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeatherTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *temperature;

@property (strong, nonatomic) IBOutlet UILabel *humidity;
@property (strong, nonatomic) IBOutlet UILabel *cityName;
@property (strong, nonatomic) IBOutlet UILabel *minTemp;
@property (strong, nonatomic) IBOutlet UILabel *maxTemp;


@end
