//
//  Date+string.m
//  iPhone4OriPhone5
//
//  Created by cqsxit on 13-11-15.
//  Copyright (c) 2013年 cqsxit. All rights reserved.
//

#import "Date+string.h"

@implementation Date_string

+ (NSString *)setYearBaseSting:(NSString *)Yearstring{
 NSString * strBasePath =[[NSBundle mainBundle] pathForResource:@"year" ofType:@"plist"];
    NSDictionary *dic =[NSDictionary dictionaryWithContentsOfFile:strBasePath];
    NSMutableDictionary * dicBase =[[NSMutableDictionary  alloc] init];
    for (NSString * key in dic.allKeys) {
        [dicBase setObject:key forKey:dic[key]];
    }
    return  dicBase[Yearstring];
}

+ (NSString *)setMonthBaseSting:(NSString *)Monthstring{
    NSString * strBasePath =[[NSBundle mainBundle] pathForResource:@"month" ofType:@"plist"];
    NSDictionary *dic =[NSDictionary dictionaryWithContentsOfFile:strBasePath];
    NSMutableDictionary * dicBase =[[NSMutableDictionary  alloc] init];
    for (NSString * key in dic.allKeys) {
        [dicBase setObject:key forKey:dic[key]];
    }
    return  dicBase[Monthstring];
}

+ (NSString *)setDayBaseSting:(NSString *)Daystring{
    NSString * strBasePath =[[NSBundle mainBundle] pathForResource:@"day" ofType:@"plist"];
    NSDictionary *dic =[NSDictionary dictionaryWithContentsOfFile:strBasePath];
    NSMutableDictionary * dicBase =[[NSMutableDictionary  alloc] init];
    for (NSString * key in dic.allKeys) {
        [dicBase setObject:key forKey:dic[key]];
    }
    return  dicBase[Daystring];
}

/******************/
+(NSString *)setYearInt:(NSString *)Yearstring{
    NSString * strBasePath =[[NSBundle mainBundle] pathForResource:@"year" ofType:@"plist"];
    NSDictionary *dic =[NSDictionary dictionaryWithContentsOfFile:strBasePath];
    NSString * year =[dic objectForKey:Yearstring];
    return year;
}

+(NSString *)setMonthInt:(NSString *)Monthstring{
    NSString * strBasePath =[[NSBundle mainBundle] pathForResource:@"month" ofType:@"plist"];
    NSDictionary *dic =[NSDictionary dictionaryWithContentsOfFile:strBasePath];
    
    NSString * strMonth =[[[dic objectForKey:Monthstring] componentsSeparatedByString:@"x"] firstObject];
    return strMonth;
}

+(NSString *)setDayInt:(NSString *)Daystring{
    NSString * strBasePath =[[NSBundle mainBundle] pathForResource:@"day" ofType:@"plist"];
    NSDictionary *dic =[NSDictionary dictionaryWithContentsOfFile:strBasePath];
    NSString * day =[dic objectForKey:Daystring];
    return day;
}

+(NSString *)setReservedInt:(NSString *)Monthstring{
    NSString * strBasePath =[[NSBundle mainBundle] pathForResource:@"month" ofType:@"plist"];
    NSDictionary *dic =[NSDictionary dictionaryWithContentsOfFile:strBasePath];
    
    NSString * strMonth =[[[dic objectForKey:Monthstring] componentsSeparatedByString:@"x"] lastObject];
    return strMonth;
}

/*天干地支*/
+(NSString *)LunarForSolar:(NSDate *)solarDate{
    //天干名称
    NSArray *cTianGan = [NSArray arrayWithObjects:@"甲",@"乙",@"丙",@"丁",@"戊",@"己",@"庚",@"辛",@"壬",@"癸", nil];
    
    //地支名称
    NSArray *cDiZhi = [NSArray arrayWithObjects:@"子",@"丑",@"寅",@"卯",@"辰",@"巳",@"午",@"未",@"申",@"酉",@"戌",@"亥",nil];
    
    //属相名称
    NSArray *cShuXiang = [NSArray  arrayWithObjects:@"鼠",@"牛",@"虎",@"兔",@"龙",@"蛇",@"马",@"羊",@"猴",@"鸡",@"狗",@"猪",nil];
    
    //农历日期名
    NSArray *cDayName = [NSArray arrayWithObjects:@"*",@"初一",@"初二",@"初三",@"初四",@"初五",@"初六",@"初七",@"初八",@"初九",@"初十",
                         @"十一",@"十二",@"十三",@"十四",@"十五",@"十六",@"十七",@"十八",@"十九",@"二十",
                         @"廿一",@"廿二",@"廿三",@"廿四",@"廿五",@"廿六",@"廿七",@"廿八",@"廿九",@"三十",nil];
    
    //农历月份名
    NSArray *cMonName = [NSArray arrayWithObjects:@"*",@"正",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"十",@"十一",@"腊",nil];
    
    //公历每月前面的天数
    const int wMonthAdd[12] = {0,31,59,90,120,151,181,212,243,273,304,334};
    
    //农历数据
    const int wNongliData[100] = {2635,333387,1701,1748,267701,694,2391,133423,1175,396438
        ,3402,3749,331177,1453,694,201326,2350,465197,3221,3402
        ,400202,2901,1386,267611,605,2349,137515,2709,464533,1738
        ,2901,330421,1242,2651,199255,1323,529706,3733,1706,398762
        ,2741,1206,267438,2647,1318,204070,3477,461653,1386,2413
        ,330077,1197,2637,268877,3365,531109,2900,2922,398042,2395
        ,1179,267415,2635,661067,1701,1748,398772,2742,2391,330031
        ,1175,1611,200010,3749,527717,1452,2742,332397,2350,3222
        ,268949,3402,3493,133973,1386,464219,605,2349,334123,2709
        ,2890,267946,2773,592565,1210,2651,395863,1323,2707,265877};
    
    static int wCurYear,wCurMonth,wCurDay;
    static int nTheDate,nIsEnd,m,k,n,i,nBit;
    
    //取当前公历年、月、日
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit |NSMonthCalendarUnit | NSYearCalendarUnit fromDate:solarDate];
    wCurYear = [components year];
    wCurMonth = [components month];
    wCurDay = [components day];
    
    //计算到初始时间1921年2月8日的天数：1921-2-8(正月初一)
    nTheDate = (wCurYear - 1921) * 365 + (wCurYear - 1921) / 4 + wCurDay + wMonthAdd[wCurMonth - 1] - 38;
    if((!(wCurYear % 4)) && (wCurMonth > 2))
        nTheDate = nTheDate + 1;
    
    //计算农历天干、地支、月、日
    nIsEnd = 0;
    m = 0;
    while(nIsEnd != 1)
    {
        if(wNongliData[m] < 4095)
            k = 11;
        else
            k = 12;
        n = k;
        while(n>=0)
        {
            //获取wNongliData(m)的第n个二进制位的值
            nBit = wNongliData[m];
            for(i=1;i<n+1;i++)
                nBit = nBit/2;
            
            nBit = nBit % 2;
            
            if (nTheDate <= (29 + nBit))
            {
                nIsEnd = 1;
                break;
            }
            
            nTheDate = nTheDate - 29 - nBit;
            n = n - 1;
        }
        if(nIsEnd)
            break;
        m = m + 1;
    }
    wCurYear = 1921 + m;
    wCurMonth = k - n + 1;
    wCurDay = nTheDate;
    if (k == 12)
    {
        if (wCurMonth == wNongliData[m] / 65536 + 1)
            wCurMonth = 1 - wCurMonth;
        else if (wCurMonth > wNongliData[m] / 65536 + 1)
            wCurMonth = wCurMonth - 1;
    }
    
    //生成农历天干、地支、属相
    NSString *szShuXiang = (NSString *)[cShuXiang objectAtIndex:((wCurYear - 4) % 60) % 12];
    NSString *szNongli = [NSString stringWithFormat:@"%@(%@%@)年",szShuXiang, (NSString *)[cTianGan objectAtIndex:((wCurYear - 4) % 60) % 10],(NSString *)[cDiZhi objectAtIndex:((wCurYear - 4) % 60) %12]];
    
    //生成农历月、日
    NSString *szNongliDay;
    if (wCurMonth < 1){
        szNongliDay = [NSString stringWithFormat:@"闰%@",(NSString *)[cMonName objectAtIndex:-1 * wCurMonth]];
    }
    else{
        szNongliDay = (NSString *)[cMonName objectAtIndex:wCurMonth];
    }
    
    NSString *lunarDate = [NSString stringWithFormat:@"%@ %@月 %@",szNongli,szNongliDay,(NSString*)[cDayName objectAtIndex:wCurDay]];
    
    return lunarDate;
}

@end
