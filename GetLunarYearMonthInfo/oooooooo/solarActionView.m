//
//  solarActionView.m
//  iPhone4OriPhone5
//
//  Created by cqsxit on 13-11-14.
//  Copyright (c) 2013年 cqsxit. All rights reserved.
//

#import "solarActionView.h"
#import "Date+string.h"
#import "LunarSolarModel.h"

//获取设备物理高度
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

//获取设备物理宽度
#define ScreenWidth [UIScreen mainScreen].bounds.size.width

@implementation solarActionView{
    NSArray * arrYear;/*年份*/
    NSMutableArray * arrMonthList;/*月份*/
    NSArray * arrDayBigList;/*大月天数*/
    NSArray  * arrDayLittleList;/*小月天数*/

    NSDictionary * dicYearBaseList;
    NSArray *leapMonthReferList;/*闰月数组*/
    NSArray *MonthReferList;/*月数组*/
    BOOL isBigMonth;
    NSString * strMonth;/*月份对应码，每一位代表一个月,为1则为大月,为0则为小月*/
    
    NSInteger indexYear;/*选择年份对应的行数下标*/
    NSInteger indexMonth;/*选择月份对应下标*/
    NSInteger indexDay;/*选择天数对应下标*/
}


- (id)init{
    self =[super init];
    if (self) {
        /*
         0x04bd8,代表阳历1900.1.31为始的阴历0年,是5个16进制数,共20bit
         
         1.前4位,即0在这一年是润年时才有意义,它代表这年润月的大小月,为1则润大月,为0则润小月。
         2.中间12位,即4bd,每位代表一个月,为1则为大月,为0则为小月
         3.最后4位,即8,代表这一年的润月月份,为0则不润,首4位要与末4位搭配使用
         
         
         int lunarcalendaList[]={0x04ae0,0x0a570,0x054d5,0x0d260,0x0d950,0x16554,0x056a0,0x09ad0,0x055d2,
         0x04ae0,0x0a5b6,0x0a4d0,0x0d250,0x1d255,0x0b540,0x0d6a0,0x0ada2,0x095b0,0x14977,
         0x04970,0x0a4b0,0x0b4b5,0x06a50,0x06d40,0x1ab54,0x02b60,0x09570,0x052f2,0x04970,
         0x06566,0x0d4a0,0x0ea50,0x06e95,0x05ad0,0x02b60,0x186e3,0x092e0,0x1c8d7,0x0c950,
         0x0d4a0,0x1d8a6,0x0b550,0x056a0,0x1a5b4,0x025d0,0x092d0,0x0d2b2,0x0a950,0x0b557,
         0x06ca0,0x0b550,0x15355,0x04da0,0x0a5d0,0x14573,0x052d0,0x0a9a8,0x0e950,0x06aa0,
         0x0aea6,0x0ab50,0x04b60,0x0aae4,0x0a570,0x05260,0x0f263,0x0d950,0x05b57,0x056a0,
         0x096d0,0x04dd5,0x04ad0,0x0a4d0,0x0d4d4,0x0d250,0x0d558,0x0b540,0x0b5a0,0x195a6,
         0x095b0,0x049b0,0x0a974,0x0a4b0,0x0b27a,0x06a50,0x06d40,0x0af46,0x0ab60,0x09570,
         0x04af5,0x04970,0x064b0,0x074a3,0x0ea50,0x06b58,0x055c0,0x0ab60,0x096d5,0x092e0,
         0x0c960,0x0d954,0x0d4a0,0x0da50,0x07552,0x056a0,0x0abb7,0x025d0,0x092d0,0x0cab5,
         0x0a950,0x0b4a0,0x0baa4,0x0ad50,0x055d9,0x04ba0,0x0a5b0,0x15176,0x052b0,0x0a930,
         0x07954,0x06aa0,0x0ad50,0x05b52,0x04b60,0x0a6e6,0x0a4e0,0x0d260,0x0ea65,0x0d530,
         0x05aa0,0x076a3,0x096d0,0x04bd7,0x04ad0,0x0a4d0,0x1d0b6,0x0d250,0x0d520,0x0dd45,
         0x0b5a0,0x056d0,0x055b2,0x049b0,0x0a577,0x0a4b0,0x0aa50,0x1b255,0x06d20,0x0ada0};//农历查询表
         
         */
        arrYear =[[NSArray alloc] init];
        arrDayBigList =[[NSArray alloc] init];
        arrDayLittleList =[[NSArray alloc] init];
        
        
        arrYear =@[@"一九零一",@"一九零二",@"一九零三",@"一九零四",@"一九零五",@"一九零六",@"一九零七",@"一九零八",@"一九零九",/*1*/
                   @"一九一零",@"一九一一",@"一九一二",@"一九一三",@"一九一四",@"一九一五",@"一九一六",@"一九一七",@"一九一八",@"一九一九",/*2*/
                   @"一九二零",@"一九二一",@"一九二二",@"一九二三",@"一九二四",@"一九二五",@"一九二六",@"一九二七",@"一九二八",@"一九二九",/*3*/
                   @"一九三零",@"一九三一",@"一九三二",@"一九三三",@"一九三四",@"一九三五",@"一九三六",@"一九三七",@"一九三八",@"一九三九",/*4*/
                   @"一九四零",@"一九四一",@"一九四二",@"一九四三",@"一九四四",@"一九四五",@"一九四六",@"一九四七",@"一九四八",@"一九四九",/*5*/
                   @"一九五零",@"一九五一",@"一九五二",@"一九五三",@"一九五四",@"一九五五",@"一九五六",@"一九五七",@"一九五八",@"一九五九",/*6*/
                   @"一九六零",@"一九六一",@"一九六二",@"一九六三",@"一九六四",@"一九六五",@"一九六六",@"一九六七",@"一九六八",@"一九六九",/*7*/
                   @"一九七零",@"一九七一",@"一九七二",@"一九七三",@"一九七四",@"一九七五",@"一九七六",@"一九七七",@"一九七八",@"一九七九",/*8*/
                   @"一九八零",@"一九八一",@"一九八二",@"一九八三",@"一九八四",@"一九八五",@"一九八六",@"一九八七",@"一九八八",@"一九八九",/*9*/
                   @"一九九零",@"一九九一",@"一九九二",@"一九九三",@"一九九四",@"一九九五",@"一九九六",@"一九九七",@"一九九八",@"一九九九",/*10*/
                   @"二零零零",@"二零零一",@"二零零二",@"二零零三",@"二零零四",@"二零零五",@"二零零六",@"二零零七",@"二零零八",@"二零零九",/*11*/
                   @"二零一零",@"二零一一",@"二零一二",@"二零一三",@"二零一四",@"二零一五",@"二零一六",@"二零一七",@"二零一八",@"二零一九",/*12*/
                   @"二零二零",@"二零二一",@"二零二二",@"二零二三",@"二零二四",@"二零二五",@"二零二六",@"二零二七",@"二零二八",@"二零二九",/*13*/
                   @"二零三零",@"二零三一",@"二零三二",@"二零三三",@"二零三四",@"二零三五",@"二零三六",@"二零三七",@"二零三八",@"二零三九",/*14*/
                   @"二零四零",@"二零四一",@"二零四二",@"二零四三",@"二零四四",@"二零四五",@"二零四六",@"二零四七",@"二零四八",@"二零四九",/*15*/
                   ];
        
        arrDayBigList =@[@"初一",@"初二",@"初三",@"初四",@"初五",@"初六",@"初七",@"初八",@"初九",@"初十",
                         @"十一",@"十二",@"十三",@"十四",@"十五",@"十六",@"十七",@"十八",@"十九",@"二十",
                         @"廿一",@"廿二",@"廿三",@"廿四",@"廿五",@"廿六",@"廿七",@"廿八",@"廿九",@"三十"];
        
        arrDayLittleList =@[@"初一",@"初二",@"初三",@"初四",@"初五",@"初六",@"初七",@"初八",@"初九",@"初十",
                            @"十一",@"十二",@"十三",@"十四",@"十五",@"十六",@"十七",@"十八",@"十九",@"二十",
                            @"廿一",@"廿二",@"廿三",@"廿四",@"廿五",@"廿六",@"廿七",@"廿八",@"廿九"];
        
        MonthReferList =@[@"正",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"十",@"十一",@"腊"];
        leapMonthReferList=@[@"闰正",@"闰二",@"闰三",@"闰四",@"闰五",@"闰六",@"闰七",@"闰八",@"闰九",@"闰十",@"闰十一",@"闰腊"];
        
        NSString * strBasePath =[[NSBundle mainBundle] pathForResource:@"lunarcalenda" ofType:@"plist"];
        dicYearBaseList =[[NSDictionary alloc] initWithContentsOfFile:strBasePath];
        arrMonthList =[[NSMutableArray alloc] init];
        
        indexYear=0;
        indexMonth=0;
        indexDay=0;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}



- (id)initWithViewdelegate:(id)delegate WithSheetTitle:(NSString *)_title sheetMode:(date_type)Mode{
    self=[super init];
    NSString * strTitle;
    if (self) {
        strTitle =[NSString stringWithFormat:@"%@%@",_title,@"\n\n\n\n\n\n\n\n\n\n\n\n"];
        [self setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
        _DetaSource=delegate;
    }
    return [self initWithTitle:strTitle
                      delegate:self
             cancelButtonTitle:@"取消"
        destructiveButtonTitle:nil
             otherButtonTitles:@"确定",nil];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    _pickerView =[[UIPickerView alloc] initWithFrame:CGRectMake(0, 20, ScreenWidth, 216)];
    _pickerView.delegate=self;
    _pickerView.dataSource=self;
    [self addSubview:_pickerView];
    
    /*指定初始时间*/
    if (indexYear==0&&indexMonth==0&&indexDay==0)[self initWithDate:[NSDate date]];/*如果没有初始时间，则初始为当前时间*/

     [_pickerView selectRow:indexYear inComponent:0 animated:NO];
     [_pickerView selectRow:indexMonth inComponent:1 animated:NO];
     [_pickerView selectRow:indexDay inComponent:2 animated:NO];
}

/*设定初始时间*/
- (void)initWithDate:(NSDate *)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *Date = [formatter stringFromDate:[NSDate date]];
    NSArray *arr=[Date componentsSeparatedByString:@"-"];
    int year =[arr[0] intValue];
    int month =[arr[1] intValue];
    int day =[arr[2] intValue];
    hjz lunar =solar_to_lunar(year, month, day);/*将当前的公历时间转换为农历*/
    
    NSString *strYear_date =[NSString stringWithFormat:@"%d",lunar.year];
    NSString *strMonth_date =[NSString stringWithFormat:@"%dx%d",lunar.month,lunar.reserved];
    NSString *strDay_date =[NSString stringWithFormat:@"%d",lunar.day];
    [self setPickerViewSlelctRowAndConponent:strYear_date Month:strMonth_date Day:strDay_date];
}

/*设定初始时间*/
- (void)setPickerViewSlelctRowAndConponent:(NSString *)year Month:(NSString *)month Day:(NSString *)day{
    
    year =[Date_string setYearBaseSting:year];
    month =[Date_string setMonthBaseSting:month];
    day =[Date_string setDayBaseSting:day];
    
    /*指定年份*/
    for (int i=0; i<arrYear.count; i++) {
        if ([year isEqualToString:arrYear[i]]) {
            indexYear=i;
           
        }
    }
    [self setMonthAndDay:dicYearBaseList[arrYear[indexYear]]];
    
    /*指定月份*/
    for (int i=0; i<arrMonthList.count; i++) {
        if ([month isEqualToString:arrMonthList[i]]) {
            indexMonth=i;
        }
    }
    
    /*指定日份*/
    for (int i=0; i<arrDayLittleList.count; i++) {
        if ([day isEqualToString:arrDayLittleList[i]]) {
            indexDay=i;
        }
    }
}



#pragma mark - UIPickerViewDataSoure
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}

-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    switch (component) {
        case 0:{
        return arrYear.count;}
            break;
        case 1:{
            return arrMonthList.count;}
            break;
        case 2:{
            if (isBigMonth)return arrDayBigList.count;
            else return arrDayLittleList.count;
                }
            break;
        default:
            return 0;
            break;
    }

}


#pragma mark - UIPickerViewDelegate
-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    switch (component) {
        case 0:
            return arrYear[row];
            break;
        case 1:
            return arrMonthList[row];
            break;
        case 2:{
            if (isBigMonth)return arrDayBigList[row];
            else return arrDayLittleList[row];
        }
            break;
        default:
            return 0;
            break;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    switch (component) {
        case 0:{
            indexYear=row;
            [self setMonthAndDay:dicYearBaseList[arrYear[row]]];
            [self setDay:indexMonth];
             [pickerView reloadComponent:1];
             [pickerView reloadComponent:2];
        }
            break;
        case 1:{
            indexMonth=row;
            [self setDay:indexMonth];
            [pickerView reloadComponent:2];
            
        }
            break;
        case 2: {
            indexDay =row;
            
        }
            break;
        default:
            break;
    }
}


#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex==0) {
        NSString * year=[Date_string setYearInt:arrYear[indexYear]];
        NSString * month =[Date_string setMonthInt:arrMonthList[indexMonth]];
        NSString * day =[Date_string setDayInt:arrDayBigList[indexDay]];
        NSString * reserved =[Date_string setReservedInt:arrMonthList[indexMonth]];
        [_DetaSource actionSheetSolarDate:year Month:month Day:day reserved:reserved];/*返回小写的农历*/
        [_DetaSource actionSheetTitleDateText:arrYear[indexYear] Month:arrMonthList[indexMonth] day:arrDayBigList[indexDay]];/*返回大写的农历*/
    }
}

//刷新内容属性(月，日)
- (void)setMonthAndDay:(NSString *)strYearBase{/*传入对应的年份编码制*/
   NSString * MonthAndDay =[strYearBase substringFromIndex:3];
    strMonth  =[[self getBinaryByhex:MonthAndDay] substringToIndex:12];/*用于大月平月的判断字符串*/
    [self setLeapMonth:strYearBase];/*判断闰月*/
}

//刷新内容属性(日)<判断是否为大月，平月>
- (void)setDay:(NSInteger)row{
    NSString * strBool;
    int count =row;
    int max =strMonth.length;
    if (count<max) {
       strBool=[strMonth substringFromIndex:row];
    }else{
    strBool=[strMonth substringFromIndex:strMonth.length-1];
    }
   
    strBool =[strBool substringToIndex:1];
    if ([strBool isEqualToString:@"0"])isBigMonth=NO;
    else isBigMonth=YES;
}

//判断闰月以及闰月的天数
- (void)setLeapMonth:(NSString *)YearBaseDate{
    NSString *isLeap=[YearBaseDate substringFromIndex:YearBaseDate.length-1];
    NSString *isBigLeap =[YearBaseDate substringToIndex:1];
    if (![isLeap isEqualToString:@"0"]) {/*是否有闰月*/
        if ([isBigLeap isEqualToString:@"0"]) {
            /***************************************/
            /*闰小月*/
            if (arrMonthList) [arrMonthList removeAllObjects];
            int leapNumnber=[isLeap intValue];
            for (int i=0; i<strMonth.length; i++) {
                [arrMonthList  addObject:MonthReferList[i]];
                if (leapNumnber-1==i)[arrMonthList addObject:leapMonthReferList[leapNumnber-1]];
            }
            NSString * strOne =[strMonth substringToIndex:leapNumnber];
            NSString * strTwo =[strMonth substringFromIndex:leapNumnber];
            strMonth =[NSString stringWithFormat:@"%@0%@",strOne,strTwo];
            /***************************************/
        }else{
            /***************************************/
            /*闰大月*/
            if (arrMonthList) [arrMonthList removeAllObjects];
            int leapNumnber=[isLeap intValue];
            for (int i=0; i<strMonth.length; i++) {
                [arrMonthList  addObject:MonthReferList[i]];
                if (leapNumnber-1==i)[arrMonthList addObject:leapMonthReferList[leapNumnber-1]];
            }
            
            NSString * strOne =[strMonth substringToIndex:leapNumnber];
            NSString * strTwo =[strMonth substringFromIndex:leapNumnber];
            strMonth =[NSString stringWithFormat:@"%@1%@",strOne,strTwo];
            /***************************************/
        }
    }else{/*如果不闰月*/
        if (arrMonthList) [arrMonthList removeAllObjects];
        arrMonthList =[[NSMutableArray alloc] initWithArray:MonthReferList];
    }
}


//将16进制转化为二进制
-(NSString *)getBinaryByhex:(NSString *)hex
{
    NSMutableDictionary  *hexDic;
    
    hexDic = [[NSMutableDictionary alloc] initWithCapacity:16];
    
    [hexDic setObject:@"0000" forKey:@"0"];
    
    [hexDic setObject:@"0001" forKey:@"1"];
    
    [hexDic setObject:@"0010" forKey:@"2"];
    
    [hexDic setObject:@"0011" forKey:@"3"];
    
    [hexDic setObject:@"0100" forKey:@"4"];
    
    [hexDic setObject:@"0101" forKey:@"5"];
    
    [hexDic setObject:@"0110" forKey:@"6"];
    
    [hexDic setObject:@"0111" forKey:@"7"];
    
    [hexDic setObject:@"1000" forKey:@"8"];
    
    [hexDic setObject:@"1001" forKey:@"9"];
    
    [hexDic setObject:@"1010" forKey:@"a"];
    
    [hexDic setObject:@"1011" forKey:@"b"];
    
    [hexDic setObject:@"1100" forKey:@"c"];
    
    [hexDic setObject:@"1101" forKey:@"d"];
    
    [hexDic setObject:@"1110" forKey:@"e"];
    
    [hexDic setObject:@"1111" forKey:@"f"];
    
    NSString *binaryString=[[NSString alloc] init];
    
    for (int i=0; i<[hex length]; i++) {
        
        NSRange rage;
        
        rage.length = 1;
        
        rage.location = i;
        
        NSString *key = [hex substringWithRange:rage];
        
        NSString * strLast =[NSString stringWithFormat:@"%@",[hexDic objectForKey:key]];
        binaryString = [NSString stringWithFormat:@"%@%@",binaryString,strLast];
        
    }
    return binaryString;
    
}



@end
