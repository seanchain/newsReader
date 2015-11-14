//
//  TableViewCell.m
//  UUChartView
//
//  Created by shake on 15/1/4.
//  Copyright (c) 2015年 uyiuyao. All rights reserved.
//

#import "TableViewCell.h"
#import "UUChart.h"

@interface TableViewCell ()<UUChartDataSource>
{
    NSIndexPath *path;
    UUChart *chartView;
}
@end

@implementation TableViewCell

NSMutableDictionary * total_res;

NSMutableArray *resary;
//获取一个存放种类和对应颜色的


- (void)configUI:(NSIndexPath *)indexPath
{
    [self getStatistic];
    if (chartView) {
        [chartView removeFromSuperview];
        chartView = nil;
    }
    
    path = indexPath;
    
    chartView = [[UUChart alloc]initwithUUChartDataFrame:CGRectMake(10, 10, [UIScreen mainScreen].bounds.size.width-20, 150)
                                              withSource:self
                                               withStyle:indexPath.section==1?UUChartBarStyle:UUChartLineStyle];
    [chartView showInView:self.contentView];
}


- (void)getStatistic {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *directoryPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [directoryPaths objectAtIndex:0];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YY-MM-dd"];
    NSString *today = [dateFormatter stringFromDate:[NSDate date]];
    NSString *lastday1 = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:-24*3600]];
    NSString *lastday2 = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:-24*3600*2]];
    NSString *lastday3 = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:-24*3600*3]];
    NSString *lastday4 = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:-24*3600*4]];

    NSString *todayPath = [documentDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.txt", today]];
    NSString *lastdayPath1 = [documentDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.txt", lastday1]];
    NSString *lastdayPath2 = [documentDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.txt", lastday2]];
    NSString *lastdayPath3 = [documentDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.txt", lastday3]];
    NSString *lastdayPath4 = [documentDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.txt", lastday4]];
    NSArray *dayAry = [NSArray arrayWithObjects:todayPath, lastdayPath1, lastdayPath2, lastdayPath3, lastdayPath4, nil];
    NSMutableDictionary *res = [[NSMutableDictionary alloc] init];
    total_res = [[NSMutableDictionary alloc] init];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSData *favData = [ud objectForKey:@"UserPreference"];
    NSSet *favSet = [NSKeyedUnarchiver unarchiveObjectWithData:favData];
    NSArray *fav = [favSet allObjects];
    resary = [[NSMutableArray alloc] init];
    for (NSString *keyword in fav) {
        [res setObject:[NSNumber numberWithInt:0] forKey:keyword];
        [total_res setObject:[NSNumber numberWithInt:0] forKey:keyword];
    }
    for (NSString *dayPath in dayAry) {
        if ([fileManager fileExistsAtPath:dayPath]) {
            NSString *fileString = [NSString stringWithContentsOfFile:dayPath usedEncoding:NULL error:nil];
            NSArray *ary = [fileString componentsSeparatedByString:@"\n"];
            for (NSString *key in ary) {
                res[key] = [NSNumber numberWithInt:[res[key] intValue] + 1 ];
                total_res[key] = [NSNumber numberWithInt:[total_res[key] intValue] + 1];
            }
            [resary addObject:res];
        }
        else {
            [resary addObject:@{}];
        }
    }
}

- (NSArray *)getStat{
    //获得数据变化的资料
    NSMutableArray *ary1 = [[NSMutableArray alloc] init];
    for (int i = 0; i < [resary count]; i ++) {
        NSDictionary *dic = resary[i];
        if ([dic isEqualToDictionary:@{}]) {
            ary1[i] = @"0";
        } else {
            int count = 0;
            for (NSNumber *number in [dic allValues]) {
                count += [number intValue];
            }
            ary1[i] = [NSString stringWithFormat:@"%d", count];
        }
    }
    
    NSMutableArray *ret = [[NSMutableArray alloc] init];
    [ret addObject:ary1];
    return (NSArray*)ret;
}

- (NSArray *)getXTitles:(int)num
{
    NSMutableArray *xTitles = [NSMutableArray array];
    for (int i=0; i<num; i++) {
        NSString * str = [NSString stringWithFormat:@"R-%d",i];
        [xTitles addObject:str];
    }
    return xTitles;
}

- (NSArray *)getXNames
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSData *favData = [ud objectForKey:@"UserPreference"];
    NSSet *favSet = [NSKeyedUnarchiver unarchiveObjectWithData:favData];
    return [favSet allObjects];
}

#pragma mark - @required
//横坐标标题数组
- (NSArray *)UUChart_xLableArray:(UUChart *)chart
{
    
    if (path.section==0) {
        return [self getDateArray];
    }else{
        return [self getXNames];
    }
    return [self getXTitles:20];
}

- (NSInteger)getWeekToday{
    return 1; //今后从服务器端返回当日的星期identifier
}

- (NSArray*)getDateArray{
    NSMutableArray *dateary = [[NSMutableArray alloc] init];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"MM月dd日"];
    //用[NSDate date]可以获取系统当前时间
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    NSLog(@"%@", currentDateStr);
    [dateary addObject:[dateFormatter stringFromDate:[NSDate date]]];
    [dateary addObject:[dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:-3600*24]]];
    [dateary addObject:[dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:-3600*24*2]]];

    [dateary addObject:[dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:-3600*24*3]]];
    [dateary addObject:[dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:-3600*24*4]]];

    return (NSArray*)dateary;
}

//数值多重数组
- (NSArray *)UUChart_yValueArray:(UUChart *)chart
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSData *favData = [ud objectForKey:@"UserPreference"];
    NSSet *favSet = [NSKeyedUnarchiver unarchiveObjectWithData:favData];
    NSArray *ary= [favSet allObjects];
    NSMutableArray *ary2 = [[NSMutableArray alloc] init];
    for (NSString *key in ary) {
        NSLog(@"int_str: %@", [NSString stringWithFormat:@"%d", [total_res[key] intValue]]);
        [ary2 addObject:[NSString stringWithFormat:@"%d", [total_res[key] intValue]]];
    }
    if (path.section==0) {
        return [self getStat];
    }else{
        return @[(NSArray*)ary2];
    }
}

#pragma mark - @optional
//颜色数组
- (NSArray *)UUChart_ColorArray:(UUChart *)chart
{
    return @[UUGreen, UUTwitterColor, UUWeiboColor];
}


//显示数值范围
- (CGRange)UUChartChooseRangeInLineChart:(UUChart *)chart
{
    if (path.section == 0 || path.section == 1) {
        NSArray * minAndMax = [self getMaxAndMin];
        return CGRangeMake([minAndMax[1] integerValue], [minAndMax[0] integerValue]);
    }
    return CGRangeZero;
}

- (NSArray *) getMaxAndMin{
    NSArray *arr = [self getStat];
    NSUInteger minimum = 1000000000;
    NSUInteger maximum = 0;
    for (int i = 0; i < arr.count; i ++) {
        for (int j = 0; j < 5; j ++) {
            NSUInteger val = [arr[i][j] integerValue];
            if (val > maximum) {
                maximum = val;
            }
            if (val < minimum) {
                minimum = val;
            }
        }
    }
    minimum = (minimum / 10) * 10;
    maximum = (maximum / 10 + 2) * 10;
    return @[[NSString stringWithFormat:@"%lu", minimum],  [NSString stringWithFormat:@"%lu", maximum]];
}



#pragma mark 折线图专享功能

//判断显示横线条

- (BOOL)UUChart:(UUChart *)chart ShowHorizonLineAtIndex:(NSInteger)index
{
    return YES;
}
@end
