//
//  SecondViewController.m
//  NewsReader
//
//  Created by Sean Chain on 2/17/15.
//  Copyright (c) 2015 Sean Chain. All rights reserved.
//

#import "SecondViewController.h"
#import "TableViewCell.h"
#import "UUColor.h"
#import "CustomTableViewCell.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

@synthesize myTableView;
- (void)viewDidLoad {
    [super viewDidLoad];
    myTableView.dataSource = self;
    myTableView.delegate = self;
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger returnval = 0;
    switch (section) {
        case 0:
            returnval = 1;
            break;
        case 1:
            returnval = 1;
            break;
        case 2:
            returnval = 8;
            break;
        default:
            break;
    }
    return returnval;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"TableViewCell";
    if (indexPath.section == 0 || indexPath.section == 1) {
        TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if(cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"TableViewCell" owner:nil options:nil] firstObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell configUI:indexPath];
        return cell;
    }
    else {
        static NSString* cellId = @"cellId";
        CustomTableViewCell* cell = (CustomTableViewCell*)[tableView
                                                           dequeueReusableCellWithIdentifier:cellId];
        if(cell == nil) {
            NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"CustomTableViewCell" owner:self options:nil];
            cell = [nibArray objectAtIndex:0];
        }
        cell.titleLabel.text = @"测试";
        cell.timeLabel.text = @"时间测试";
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 || indexPath.section == 1)
        return 200;
    else {
        UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.frame.size.height;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    CGRect frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width , 35);
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.font = [UIFont systemFontOfSize:25];
    label.backgroundColor = UULightBlue;
    if (section == 0) label.text = @"新闻分类排名";
    else if (section == 1) label.text = @"新闻日期走势";
    else label.text = @"推荐新闻";
    label.textColor = UUWhite;
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

@end
