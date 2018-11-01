//
//  Date+string.h
//  iPhone4OriPhone5
//
//  Created by cqsxit on 13-11-15.
//  Copyright (c) 2013年 cqsxit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Date_string : NSObject

/*小写转大写*/
+ (NSString *)setYearBaseSting:(NSString *)Yearstring;

+ (NSString *)setMonthBaseSting:(NSString *)Monthstring;

+ (NSString *)setDayBaseSting:(NSString *)Daystring;


/*大写转小写*/
+(NSString *)setYearInt:(NSString *)Yearstring;

+(NSString *)setMonthInt:(NSString *)Monthstring;

+(NSString *)setDayInt:(NSString *)Daystring;

+(NSString *)setReservedInt:(NSString *)Monthstring;

/*天干、地支*/
+(NSString *)LunarForSolar:(NSDate *)solarDate;
@end
