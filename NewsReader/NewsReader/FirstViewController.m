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
NSIndexPath *idxpth;
NSArray *news;
NSMutableSet *favSet;
NSString *token;
NSArray *recommend_news;
NSString *entry_news_id;

- (void)viewDidLoad {
    news = @[];
    entry_news_id = @"";
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    favSet = [[NSMutableSet alloc] init];
    NSData *favData = [ud objectForKey:@"UserPreference"];
    favSet = [NSKeyedUnarchiver unarchiveObjectWithData:favData];
    
    NSString *username = @"ciaomondo94";
    NSString *email = @"ciaomondo94@163.com";
    NSString *displayname = @"ciaomondo94";
    NSString *password = @"12345678";
    NSDictionary *res = [Func registerUserInfo:@{@"username":username, @"email":email, @"displayname":displayname, @"password":password}];
    NSLog(@"Result here: %@", res);
    if (res[@"succeeded"]) {
        NSString *poststr = [ NSString stringWithFormat:@"username=%@&password=%@&grant_type=password&client_id=hhh&client_secret=hhh", username, password];
        token = [Func getTokenAndValidate:poststr and:username];
    }
    if (token) {
        [ud setObject:token forKey:@"token"]; // 设置token
        [Func setUpKeywords:[favSet allObjects] And:token];
    }
    [Func userNews:token];
    [Func recommendNews:token];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:NO];
    [self getUserPortraitAsync];
    // [self getTheWebContent:@"username"];
    tapstr = @"全部";
    
    // 尝试创建文件
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *directoryPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [directoryPaths objectAtIndex:0];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YY-MM-dd"];
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    NSString *filePath = [documentDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.txt", currentDateStr]];
    if (![fileManager fileExistsAtPath:filePath]) {
        [fileManager createFileAtPath:filePath contents:nil attributes:nil];
    }
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    news = [ud objectForKey:@"news"];
    // 默认进来的时候是全部的内容
    
    // 现在我们开始假设这里有一个字典包含我们需要的一切材料
    
    // Do any additional setup after loading the view, typically from a nib.
    float x = self.view.frame.size.width;
    float y = self.view.frame.size.height;
    toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, y * 0.09, x, y * 0.07)];
    //将来添加获得用户喜好关键词的语句

    
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
    if ([tapstr isEqualToString:@"全部"]) {
        cell.titleLabel.text = [news objectAtIndex:rowNo][@"title"];
        cell.timeLabel.text = [news objectAtIndex:rowNo][@"posttime"];
    }
    else {
        for (NSDictionary *new in news) {
            if ([new[@"keyword"] isEqualToString:tapstr]) {
                [allContentsAry addObject:new];
            }
        }
        cell.titleLabel.text = [allContentsAry objectAtIndex:rowNo][@"title"];
        cell.timeLabel.text = [allContentsAry objectAtIndex:rowNo][@"posttime"];
    }
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
        count = [news count];
    }
    else {
        for (NSDictionary *new in news) {
            if ([new[@"keyword"] isEqualToString:tapstr]) {
                count += 1;
            }
        }
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
        dataAry = (NSMutableArray*)news;
        for (int i = 0; i < [dataAry count]; i ++) {
            NSIndexPath *rowNo = [NSIndexPath indexPathForRow:i inSection:0];
            CustomTableViewCell *cell = [table cellForRowAtIndexPath:rowNo];
            cell.titleLabel.text = [dataAry objectAtIndex:i][@"title"];
            cell.timeLabel.text = [dataAry objectAtIndex:i][@"posttime"];
        }
    }
    
    else {
        NSMutableArray *contentsAry = [[NSMutableArray alloc] init];
        for (NSDictionary *new in news) {
            if ([new[@"keyword"] isEqualToString:tapstr]) {
                [contentsAry addObject:new];
            }
        }
        for (int i = 0; i < [contentsAry count]; i ++) {
            NSIndexPath *rowNo = [NSIndexPath indexPathForRow:i inSection:0];
            CustomTableViewCell *cell = [table cellForRowAtIndexPath:rowNo];
            cell.titleLabel.text = [contentsAry objectAtIndex:i][@"title"];
            cell.timeLabel.text = [contentsAry objectAtIndex:i][@"posttime"];
        }
    }
}

- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
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
    [newString writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    idxpth = indexPath;
    NSMutableArray *dataAry = [[NSMutableArray alloc] init];
    if ([tapstr isEqualToString:@"全部"]) {
        dataAry = (NSMutableArray*)news;
        entry_news_id = dataAry[idxpth.row][@"id"];
        [self writeToCertainFile:dataAry[idxpth.row][@"keyword"]];
    }
    
    else {
        NSMutableArray *contentsAry = [[NSMutableArray alloc] init];
        for (NSDictionary *new in news) {
            if ([new[@"keyword"] isEqualToString:tapstr]) {
                [contentsAry addObject:new];
            }
        }
        entry_news_id = contentsAry[idxpth.row][@"id"];
        [self writeToCertainFile:contentsAry[idxpth.row][@"keyword"]];
    }

    
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
    [destController setValue:entry_news_id forKey:@"newsID"];
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
