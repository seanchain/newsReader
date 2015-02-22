//
//  FirstViewController.m
//  NewsReader
//
//  Created by Sean Chain on 2/17/15.
//  Copyright (c) 2015 Sean Chain. All rights reserved.
//

#import "FirstViewController.h"
#import "AppDelegate.h"
#import "NewsContent.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

NSArray *newstitle;
//将来将使用解析新闻链接的方式获得标题

UIToolbar *toolbar;
UITableView *table;

NSIndexPath *idxpth;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    float x = self.view.frame.size.width;
    float y = self.view.frame.size.height;
    toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, y * 0.09, x, y * 0.07)];
    //将来添加获得用户喜好关键词的语句
    NSArray *favstr = @[@"全部", @"iOS8", @"Android5.0", @"拜仁慕尼黑", @"iMac 5k"];
    //关键词对应的都有自己的新闻链接网址，只需要将网址中的内容放到相对应的tableview cell中
    NSArray *fav = [self transferButtonArray:favstr];
    [toolbar setItems:fav animated:YES];
    [toolbar setTintColor:[UIColor whiteColor]];
    [toolbar setBarTintColor:[UIColor blackColor]];
    //[toolbar setBackgroundColor:[UIColor greenColor]];
    [self.view addSubview:toolbar];
    table = [[UITableView alloc] initWithFrame:CGRectMake(0, y * 0.16, x, y - y * 0.16) style:UITableViewStylePlain];
    table.delegate = self;
    [self.navigationBar setBarStyle:UIBarStyleBlackTranslucent];
    table.dataSource = self;
    [self.view addSubview:table];
    newstitle = @[@"拜仁1-1憾平矿工", @"苹果加大Apple Watch生产"];
}


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellId = @"cellId";
    UITableViewCell* cell = [tableView
                             dequeueReusableCellWithIdentifier:cellId];
    if(cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    NSUInteger rowNo = indexPath.row;
    cell.textLabel.text = [newstitle objectAtIndex:rowNo];
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //将来加入缩略图显示
    return cell;
}
// 该方法的返回值决定指定分区内包含多少个表格行。
- (NSInteger)tableView:(UITableView*)tableView
	numberOfRowsInSection:(NSInteger)section
{
    // 由于该表格只有一个分区，直接返回books中集合元素个数代表表格的行数
    return newstitle.count;
}

- (NSArray *)transferButtonArray:(NSArray *)ary
{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (id str in ary) {
        UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:str style:UIBarButtonItemStylePlain target:self action:@selector(getNewsURL:)];
        [arr addObject:button];
    }
    return (NSArray *)arr;
}

- (NSArray *)getNewsURL:(UIBarButtonItem*)sender{
    NSString *keyword = [sender title];
    //进行一系列的获取新闻URL的操作并将所得的URL结果以数组的形式过滤
    NSArray *ary = @[@"http://chensihang/iostest/newsone.html", @"http://chensihang/iostest/newstwo.html"];
    return ary;
}

- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    idxpth = indexPath;
    [self performSegueWithIdentifier:@"newscontent" sender:self.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    id destController = segue.destinationViewController;
    [destController setValue:idxpth forKey:@"indexpath"];
}

@end
