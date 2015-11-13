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
#import "UUColor.h"
#import "Func.h"
#import "AFHTTPRequestOperationManager.h"
#import "ZuSimpelColor.h"
#import "CustomTableViewCell.h"
#import "CBStoreHouseRefreshControl.h"

@interface FirstViewController ()

@property (strong, nonatomic) CBStoreHouseRefreshControl *storeHouseRefreshControl;

@end

@implementation FirstViewController

NSArray *newstitle;
//将来将使用解析新闻链接的方式获得标题
NSString *tapstr;
UIToolbar *toolbar;
UITableView *table;
NSMutableDictionary *testdic;
NSIndexPath *idxpth;

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:NO];
    [self getUserPortraitAsync];
    // [self getTheWebContent:@"username"];
    testdic = [[NSMutableDictionary alloc] init];
    tapstr = @"全部";
    // 默认进来的时候是全部的内容
    
    // 现在我们开始假设这里有一个字典包含我们需要的一切材料
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    // Do any additional setup after loading the view, typically from a nib.
    float x = self.view.frame.size.width;
    float y = self.view.frame.size.height;
    NSLog(@"高速我iPhone的宽度是%f", x);
    toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, y * 0.09, x, y * 0.07)];
    //将来添加获得用户喜好关键词的语句
    NSData *favData = [ud objectForKey:@"UserPreference"];
    NSMutableSet *favSet = [NSKeyedUnarchiver unarchiveObjectWithData:favData];
    for (NSString *dic in [favSet allObjects]) {
        [testdic setObject:[[NSMutableArray alloc] init] forKey:dic];
    }
    // 这里开始获得每个关键词的内容结果
    
    for (NSString *key in [favSet allObjects]) {
        NSMutableArray *subary = [testdic objectForKey:key]; // 数组中的每一个元素就是一个字典，字典中包含每一个新闻的详细内容
        if ([key isEqualToString:@"体育"]) {
            subary[0] = @{@"title":@"test1", @"url":@"http://www.whatever.com/1", @"time":@"some time"};
            subary[1] = @{@"title":@"test2", @"url":@"http://www.whatever.com/2", @"time":@"another time"};
            subary[2] = @{@"title":@"test3", @"url":@"http://www.whatever.com/3", @"time":@"third time"};
        }
        else if ([key isEqualToString:@"社会"]) {
            subary[0] = @{@"title":@"test4", @"url":@"http://www.whatever.com/2", @"time":@"another time"};
            subary[1] = @{@"title":@"test5", @"url":@"http://www.whatever.com/3", @"time":@"third time"};
        }
        else {
            subary[0] = @{@"title":@"test6", @"url":@"http://www.whatever.com/2", @"time":@"another time"};
            subary[1] = @{@"title":@"一个稍微长一点的标题测试，测试啊，测试啊，测试啊，测试", @"url":@"http://www.whatever.com/3", @"time":@"third time"};
            subary[2] = @{@"title":@"test8", @"url":@"http://www.whatever.com/2", @"time":@"another time"};
            subary[3] = @{@"title":@"test9", @"url":@"http://www.whatever.com/3", @"time":@"third time"};
        }
    }
    
    NSLog(@"TEST DICTIONARY: %@", testdic); // 测试用的列表构建完毕
    
    NSArray *fav = [self transferButtonArray:[favSet allObjects]];
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = toolbar.frame;
    scrollView.bounds = toolbar.bounds;
    scrollView.autoresizingMask = toolbar.autoresizingMask;
    scrollView.showsVerticalScrollIndicator = false;
    scrollView.showsHorizontalScrollIndicator = false;
    [self.view addSubview:toolbar];
    UIView *superView = toolbar.superview;
    [toolbar removeFromSuperview];
    toolbar.autoresizingMask = UIViewAutoresizingNone;
    
    
    
    toolbar.frame = CGRectMake(0, 0, x, toolbar.frame.size.height);
    
    
    toolbar.bounds = toolbar.frame;
    [toolbar setItems:fav];
    
    // 获得UIBarButtonItem的宽度总和
    
    double total_width = 0.0f;
    for (UIBarButtonItem *item in fav) {
        UIView *view = [item valueForKey:@"view"];
        CGFloat width = view? [view frame].size.width : (CGFloat)0.0;
        total_width += (width + 16);
    }
    NSLog(@"Total Item width are: %lf", total_width);
    if (total_width > scrollView.frame.size.width) {
        toolbar.frame = CGRectMake(0, 0, total_width * 1, toolbar.frame.size.height);
    }
    
    scrollView.contentSize = toolbar.frame.size;
    CGRect scrollViewRect = scrollView.frame;
    CGRect toolBarRect = toolbar.frame;
    NSLog(@"%f--%f", scrollViewRect.size.width, toolBarRect.size.width);
    [scrollView addSubview:toolbar];
    [superView addSubview:scrollView];
    
    
    [toolbar setBarTintColor:[UIColor colorWithRed:0.8 green:0 blue:0 alpha:1]];
    table = [[UITableView alloc] initWithFrame:CGRectMake(0, y * 0.16, x, y - y * 0.16) style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
    self.storeHouseRefreshControl = [CBStoreHouseRefreshControl attachToScrollView:table target:self refreshAction:@selector(refreshTriggered:) plist:@"csh" color:maroon lineWidth:1.5 dropHeight:80 scale:1 horizontalRandomness:150 reverseLoadingAnimation:YES internalAnimationFactor:0.5];
}


- (void)getTheWebContent:(NSString*)username
{
    // 假设username进行了Web端的传递并获得了对应的JSON，然后将对应的JSON存入了相应的文件中
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"news" ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    [data setObject:@"add some content" forKey:@"c_key"];
    
    //获取应用程序沙盒的Documents目录
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPath1 = [paths objectAtIndex:0];
    
    //得到完整的文件名
    NSString *filename=[plistPath1 stringByAppendingPathComponent:@"news.plist"];
    //输入写入
    [data writeToFile:filename atomically:YES];
    
    //那怎么证明我的数据写入了呢？读出来看看
    NSMutableDictionary *data1 = [[NSMutableDictionary alloc] initWithContentsOfFile:filename];
    NSLog(@"The content which has written to the plist file is :%@", data1);
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellId = @"cellId";
    CustomTableViewCell* cell = (CustomTableViewCell*)[tableView
                             dequeueReusableCellWithIdentifier:cellId];
    if(cell == nil) {
        NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"CustomTableViewCell" owner:self options:nil];
        cell = [nibArray objectAtIndex:0];
    }
    NSUInteger rowNo = indexPath.row;
    
    // 重新生成所有的内容
    NSMutableArray *allContentsAry = [[NSMutableArray alloc] init];
    for (NSString *key in testdic) {
        NSMutableArray *subary = [testdic objectForKey:key];
        for (NSMutableDictionary *dic in subary) {
            [allContentsAry addObject:dic[@"title"]];
        }
    }
    cell.titleLabel.text = [allContentsAry objectAtIndex:rowNo];
    cell.timeLabel.text = @"日期";
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:0.19 green:0.52 blue:0.92 alpha:1];
    //将来加入缩略图显示
    return cell;
}


// 该方法的返回值决定指定分区内包含多少个表格行。
- (NSInteger)tableView:(UITableView*)tableView
	numberOfRowsInSection:(NSInteger)section
{
    // 由于该表格只有一个分区，直接返回books中集合元素个数代表表格的行数
    NSUInteger count = 0;
    if ([tapstr isEqualToString:@"全部"]) {
        for (NSString *key in testdic) {
            NSMutableArray *ary = [testdic objectForKey:key];
            count += [ary count];
        }
    }
    else {
        NSMutableArray *ary = testdic[tapstr];
        count = [ary count];
    }
    return count;
}

- (NSArray *)transferButtonArray:(NSArray *)ary
{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    UIBarButtonItem *allBtn = [[UIBarButtonItem alloc] initWithTitle:@"全部" style:UIBarButtonItemStylePlain target:self action:@selector(getDic:)];
    [allBtn setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:indigo, NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    [arr addObject:allBtn];
    for (id str in ary) {
        UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:str style:UIBarButtonItemStylePlain target:self action:@selector(getDic:)];
        [button setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
        [arr addObject:button];
    }
    
    return (NSArray *)arr;
}

- (void)getDic:(UIBarButtonItem*)sender{
    NSString *keyword = [sender title];
    tapstr = keyword;
    NSLog(@"%@", tapstr);
    for (UIBarButtonItem *item in toolbar.items) {
        if ([item.title isEqualToString:keyword]) {
            [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:indigo, NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
        }
        else {
            [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
        }
    }
    
    // 上面点按更换颜色
    
    static NSString *cellid = @"cellId";
    CustomTableViewCell *cell = [table dequeueReusableCellWithIdentifier:cellid];
    cell = nil;
    [table reloadData];
    
    NSMutableArray *dataAry = [[NSMutableArray alloc] init];
    if ([tapstr isEqualToString:@"全部"]) {
        NSArray *keys = [testdic allKeys];
        for (NSString *key in keys) {
            NSMutableArray *ary = testdic[key];
            for (NSMutableDictionary *dic in ary) {
                [dataAry addObject:dic];
            }
        }
        for (int i = 0; i < [dataAry count]; i ++) {
            NSIndexPath *rowNo = [NSIndexPath indexPathForRow:i inSection:0];
            CustomTableViewCell *cell = [table cellForRowAtIndexPath:rowNo];
            cell.titleLabel.text = [dataAry objectAtIndex:i][@"title"];
            cell.timeLabel.text = @"日期";
        }
    }
    
    else {
        NSMutableArray *testary = testdic[tapstr];
        for (int i = 0; i < [testary count]; i ++) {
            NSIndexPath *rowNo = [NSIndexPath indexPathForRow:i inSection:0];
            CustomTableViewCell *cell = [table cellForRowAtIndexPath:rowNo];
            cell.titleLabel.text = [testary objectAtIndex:i][@"title"];
            cell.timeLabel.text = @"日期";
        }
    }
}

- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    idxpth = indexPath;
    UITableViewCell *cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:idxpth];
    if (cell.tag == 0) {
        cell.selected = NO;
    }else{
        [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    }
    [self performSegueWithIdentifier:@"newscontent" sender:self.view];
}

- (void)getUserPortraitAsync
{
    NSLog(@"trying to download the image");
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *user = [ud valueForKey:@"user"];
    NSString *url = [NSString stringWithFormat:@"http://www.chensihang.com/iostest/portraits/%@.jpg", user];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
    requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Response: %@", responseObject);
        NSData *portraitData = [NSKeyedArchiver archivedDataWithRootObject:responseObject];
        [ud setValue:portraitData forKey:@"portrait"];
        NSLog(@"portrait load");
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Image error: %@", error);
    }];
    [requestOperation start];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

#pragma mark - Notifying refresh control of scrolling

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.storeHouseRefreshControl scrollViewDidScroll];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.storeHouseRefreshControl scrollViewDidEndDragging];
}

#pragma mark - Listening for the user to trigger a refresh

- (void)refreshTriggered:(id)sender
{
    [self performSelector:@selector(finishRefreshControl) withObject:nil afterDelay:3 inModes:@[NSRunLoopCommonModes]];
}

- (void)finishRefreshControl
{
    [self.storeHouseRefreshControl finishingLoading];
//    self.statusFrames = [[self getContent] copy];
    [table reloadData];
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
