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

- (void)configUI:(NSIndexPath *)indexPath
{
    if (chartView) {
        [chartView removeFromSuperview];
        chartView = nil;
    }
    
    path = indexPath;
    
    chartView = [[UUChart alloc]initwithUUChartDataFrame:CGRectMake(10, 0, [UIScreen mainScreen].bounds.size.width-20, 150)
                                              withSource:self
                                               withStyle:indexPath.section==1?UUChartBarStyle:UUChartLineStyle];
    [chartView showInView:self.contentView];
}

- (NSArray *)getXNames
{
    return @[@"体育", @"科技", @"金融", @"艺术", @"旅游"];
}

- (NSArray *)getWeekdays
{
    return @[@"日", @"一", @"二", @"三", @"四"];
}

#pragma mark - @required
//横坐标标题数组
- (NSArray *)UUChart_xLableArray:(UUChart *)chart
{

    if (path.section==0) {
        return [self getWeekdays];
    }else{
        return [self getXNames];
    }
}

//数值多重数组
- (NSArray *)UUChart_yValueArray:(UUChart *)chart
{
    NSArray *ary1 = @[@"22",@"54",@"15",@"30",@"42"];
    NSArray *ary2 = @[@"76",@"34",@"54",@"23",@"16"];
    NSArray *ary3 = @[@"34", @"21", @"54", @"71", @"15"];
    
    if (path.section==0) {
        return @[ary1, ary2, ary3]; //折线图显示阅读类型
    }else{
        return @[ary1]; //柱状图显示排名前五的阅读类型一个星期内的阅读总数
    }
}

#pragma mark - @optional
//颜色数组
- (NSArray *)UUChart_ColorArray:(UUChart *)chart
{
    return @[UUGreen,UURed,UUTwitterColor, UUWeiboColor, UUStarYellow];
}
//显示数值范围
- (CGRange)UUChartChooseRangeInLineChart:(UUChart *)chart
{
    return CGRangeMake(100, 0);
}

//判断显示横线条

- (BOOL)UUChart:(UUChart *)chart ShowHorizonLineAtIndex:(NSInteger)index
{
    return YES;
}


//判断显示最大最小值
- (BOOL)UUChart:(UUChart *)chart ShowMaxMinAtIndex:(NSInteger)index
{
    return YES;
}
@end
