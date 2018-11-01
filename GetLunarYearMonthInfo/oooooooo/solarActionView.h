//
//  solarActionView.h
//  iPhone4OriPhone5
//
//  Created by cqsxit on 13-11-14.
//  Copyright (c) 2013年 cqsxit. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum {
    
    Type_solar,
    type_lunar
}  date_type;

@class ActionSheetView;
@protocol ActionSheetViewDetaSource <NSObject>
@optional
- (void)actionSheetSolarDate:(int)year Month:(int)month Day:(int)day;

/*返回小写的农历，比如1991-04-01*/
- (void)actionSheetSolarDate:(NSString *)year Month:(NSString *)month Day:(NSString *)day reserved:(NSString *)reserved;

/*返回大写写的农历，比如一九九一年四月一日*/
- (void)actionSheetTitleDateText:(NSString *)year Month:(NSString *)month day:(NSString *)day;

@end

@interface solarActionView : UIActionSheet<UIActionSheetDelegate,UIPickerViewDataSource,UIPickerViewDelegate>

- (id)initWithViewdelegate:(id)delegate WithSheetTitle:(NSString *)_title sheetMode:(date_type)Mode;

/*设定初始时间*/
- (void)initWithDate:(NSDate *)date;


@property (assign ,nonatomic)id<ActionSheetViewDetaSource>DetaSource;
@property (strong ,nonatomic)UIPickerView * pickerView;
@end
