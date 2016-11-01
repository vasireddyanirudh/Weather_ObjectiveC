//
//  WeatherModel.m
//  Weather_ObjectiveC
//
//  Created by Anirudh Reddy on 10/18/16.
//  Copyright © 2016 anirudh reddy. All rights reserved.
//

#import "WeatherModel.h"

@implementation WeatherModel
-(instancetype)initWithDictionary:(NSData *)data{
    if ((self = [super self])) {
        NSError* myError;
        if(data != nil){
        NSDictionary *response = [NSJSONSerialization JSONObjectWithData:data
                                                               options:kNilOptions
                                                                 error:&myError];
        
        NSDictionary *weatherDict   =  [response objectForKey:@"main"];
        self.temperature            =  [weatherDict objectForKey:@"temp"];
        self.precipitation          =  [weatherDict  objectForKey:@"humidity"];
        self.minTemperature         =  [weatherDict  objectForKey:@"temp_min"];
        self.maxTemperature         =  [weatherDict  objectForKey:@"temp_max"];
        self.cityName_api       =  [response     objectForKey:@"name"];
        }
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeObject:_temperature forKey:@"temp"];
    [aCoder encodeObject:_precipitation forKey:@"humidity"];
    [aCoder encodeObject:_minTemperature forKey:@"temp_min"];
    [aCoder encodeObject:_maxTemperature forKey:@"temp_max"];
}
- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    
    self.temperature = [aDecoder decodeObjectForKey:@"temp"];
    self.precipitation = [aDecoder decodeObjectForKey:@"humidity"];
    self.minTemperature = [aDecoder decodeObjectForKey:@"temp_min"];
    self.maxTemperature = [aDecoder decodeObjectForKey:@"temp_max"];

    return self;
}


@end
