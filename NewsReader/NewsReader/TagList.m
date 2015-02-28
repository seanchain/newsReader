//
//  TagList.m
//  NewsReader
//
//  Created by Sean Chain on 2/28/15.
//  Copyright (c) 2015 Sean Chain. All rights reserved.
//

#import "TagList.h"

@interface TagList ()

@end

@implementation TagList

- (void)viewDidLoad {
    [super viewDidLoad];
    tagList = [[DWTagList alloc] initWithFrame:CGRectMake(20.0f, 70.f, 280.0f, 300.0f)];
    NSArray *array = [[NSArray alloc] initWithObjects:@"体育", @"生活", @"军事", @"科技", @"财经", @"社会", nil];
    [tagList setTags:array];
    [self.view addSubview:tagList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
