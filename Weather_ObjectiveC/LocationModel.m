//
//  LocationModel.m
//  Weather_ObjectiveC
//
//  Created by Anirudh Reddy on 10/31/16.
//  Copyright © 2016 anirudh reddy. All rights reserved.
//

#import "LocationModel.h"

@implementation LocationModel

-(id)initwithcityName:(NSString *)cityName
              zipCode:(NSString *)zipCode
       ISOCountryCode:(NSString *)ISOCode{
    if(self){
        self.cityName = cityName;
        self.zipcode  = zipCode;
        self.ISOCode  = ISOCode;
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeObject:_cityName forKey:@"city"];
    [aCoder encodeObject:_zipcode forKey:@"zipcode"];
    [aCoder encodeObject:_ISOCode forKey:@"isocode"];

}
- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    
    self.cityName = [aDecoder decodeObjectForKey:@"city"];
    self.zipcode = [aDecoder decodeObjectForKey:@"zipcode"];
    self.ISOCode = [aDecoder decodeObjectForKey:@"isocode"];
    
    return self;
}


@end
