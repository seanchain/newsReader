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


//获取一个存放种类和对应颜色的


- (void)configUI:(NSIndexPath *)indexPath
{
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

- (NSArray *)getStat{
    //获得数据变化的资料
    NSArray *ary1 = @[@"22",@"54",@"15",@"30",@"42"];
    NSArray *ary2 = @[@"76",@"34",@"54",@"23",@"15"];
    NSArray *ary3 = @[@"23",@"12",@"25",@"55",@"52"];
    NSMutableArray *ret = [[NSMutableArray alloc] init];
    [ret addObject:ary1];
    [ret addObject:ary2];
    [ret addObject:ary3];
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
    return @[@"Sports", @"Tech", @"Financial", @"Art", @"Tour"];
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
    [dateary addObject:[dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:-3600*24*4]]];
    [dateary addObject:[dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:-3600*24*3]]];
    [dateary addObject:[dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:-3600*24*2]]];
    [dateary addObject:[dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:-3600*24]]];
    [dateary addObject:[dateFormatter stringFromDate:[NSDate date]]];

    return (NSArray*)dateary;
}

//数值多重数组
- (NSArray *)UUChart_yValueArray:(UUChart *)chart
{
    
    NSArray *ary2 = @[@"76",@"34",@"54",@"23",@"15"];
    
    if (path.section==0) {
        return [self getStat];
    }else{
        return @[ary2];
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
