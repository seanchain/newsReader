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

UINavigationBar *navigationBar;

- (void)viewDidLoad {
    [super viewDidLoad];
    // 此处将要存一个log
    NSString *newsID = self.newsID;
    NSLog(@"The News ID is %@", newsID);
    NSString *str = [NSString stringWithFormat:@"http://fxckgfw.xyz/news/%@", newsID];
    NSURL *url = [NSURL URLWithString:str];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    [web loadRequest:req];
    //将来会从服务器端获得用户新闻的链接与索引对应关系的字典
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
