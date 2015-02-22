//
//  NewsContent.m
//  NewsReader
//
//  Created by Sean Chain on 2/18/15.
//  Copyright (c) 2015 Sean Chain. All rights reserved.
//

#import "NewsContent.h"

@interface NewsContent ()

@end

@implementation NewsContent

@synthesize web;
NSString *url;

UINavigationBar *navigationBar;

- (void)viewDidLoad {
    [super viewDidLoad];
    NSInteger idx = self.indexpath.row;
    //将来会从服务器端获得用户新闻的链接与索引对应关系的字典
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:@[@"http://chensihang.com/iostest/newsone.html", @"http://chensihang.com/iostest/newstwo.html"] forKeys:@[@"0", @"1"]];
    NSString *keystr = [NSString stringWithFormat:@"%lu", idx];
    NSLog(@"%@", keystr);
    url = [dic valueForKey:[NSString stringWithFormat:@"%lu", idx]];
    NSLog(@"%@", url);
    [self getNews:url];
}

- (void)getNews:(NSString *)str
{
    NSURL *url = [NSURL URLWithString:str];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    [web loadRequest:req];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
