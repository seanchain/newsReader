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
#import "Func.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

NSIndexPath *idxpth;
NSMutableArray *rec_news;

@synthesize myTableView;
- (void)viewDidLoad {
    [super viewDidLoad];
    myTableView.dataSource = self;
    myTableView.delegate = self;
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    rec_news = [ud objectForKey:@"recommend"];
    for (NSDictionary *ids in rec_news) {
        NSLog(@"id:%@", ids[@"id"]);
    }
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:NO];
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
        cell.titleLabel.text = rec_news[indexPath.row][@"title"];
        cell.timeLabel.text = rec_news[indexPath.row][@"posttime"];
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

- (void)writeToCertainFile:(NSString*)keyword {
    NSArray *directoryPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [directoryPaths objectAtIndex:0];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YY-MM-dd"];
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    NSString *filePath = [documentDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.txt", currentDateStr]];
    NSString *fileString = [NSString stringWithContentsOfFile:filePath usedEncoding:NULL error:nil];
    NSString *newString = @"";
    if ([fileString isEqualToString:@""])
        newString = [NSString stringWithFormat:@"%@", keyword];
    else
        newString = [NSString stringWithFormat:@"%@\n%@", fileString, keyword];
    [newString writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];    [newString writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    idxpth = indexPath;
    if (indexPath.section == 2) {
        [self writeToCertainFile:rec_news[idxpth.row][@"keyword"]];
        UITableViewCell *cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        if (cell.tag == 0) {
            cell.selected = NO;
        }else{
            [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
        }
        [self performSegueWithIdentifier:@"secnewscontent" sender:self.view];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    id destController = segue.destinationViewController;
    [destController setValue:idxpth forKey:@"indexpath"];
    [destController setValue:rec_news[idxpth.row][@"id"] forKey:@"newsID"];
}

@end
