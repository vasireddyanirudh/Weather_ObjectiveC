//
//  LocationModel.h
//  Weather_ObjectiveC
//
//  Created by Anirudh Reddy on 10/31/16.
//  Copyright © 2016 anirudh reddy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocationModel : NSObject<NSCoding>

@property (strong, nonatomic)  NSString *cityName;
@property (strong, nonatomic)  NSString *zipcode;
@property (strong, nonatomic)  NSString *ISOCode;

-(id)initwithcityName:(NSString *)city
              zipCode:(NSString *)zipcode
       ISOCountryCode:(NSString *)ISOcode;
@end
