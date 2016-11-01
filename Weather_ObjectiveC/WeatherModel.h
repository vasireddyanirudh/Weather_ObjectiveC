//
//  WeatherModel.h
//  Weather_ObjectiveC
//
//  Created by Anirudh Reddy on 10/18/16.
//  Copyright © 2016 anirudh reddy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherModel : NSObject<NSCoding>

@property (strong, nonatomic)  NSNumber *temperature;
@property (strong, nonatomic)  NSString *minTemperature;
@property (strong, nonatomic)  NSString *maxTemperature;
@property (strong, nonatomic)  NSString *precipitation;


@property (strong, nonatomic)  NSString *cityName_api;

-(instancetype)initWithDictionary:(NSData *)dictionary;

@end
