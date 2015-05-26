//
//  TagList.m
//  NewsReader
//
//  Created by Sean Chain on 2/28/15.
//  Copyright (c) 2015 Sean Chain. All rights reserved.
//

#import "TagList.h"
#import "Func.h"

@interface TagList ()

@end

@implementation TagList

@synthesize textfield;
@synthesize buttonLook;

NSMutableArray *array;

- (void)viewDidLoad {
    [super viewDidLoad];
    buttonLook.backgroundColor = [UIColor colorWithRed:0.19 green:0.49 blue:0.92 alpha:1];
    tagList = [[DWTagList alloc] initWithFrame:CGRectMake(20.0f, 86.0f, 320.0f, 300.0f)];
    array = [[NSMutableArray alloc] initWithObjects:@"金融", @"体育", @"生活", @"科技", @"军事", @"社会", nil];
    [tagList setTags:array];
    [self.view addSubview:tagList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)add:(id)sender {
    NSString *str = textfield.text;
    if (str != nil) {
        [array addObject:str];
    }
    [tagList setTags:array];
    [self.view addSubview:tagList];
    textfield.text = nil;
    [self.textfield resignFirstResponder];
}


- (IBAction)submit:(id)sender {
    
    [Func showAlert:@"Hello, worlder"];
    NSLog(@"****%@****", [DWTagList returnSet]);
    NSSet *set = [DWTagList returnSet];
    NSLog(@"SET HERE: %@", set);
    NSArray *jsonarr = [NSArray arrayWithObjects:[set allObjects], nil];
    jsonarr = jsonarr[0];
    NSString *final = @"";
    NSLog(@"ARRAY HERE: %@", jsonarr);
    for (int i = 0; i < [jsonarr count] - 1; i ++) {
        final = [final stringByAppendingString:jsonarr[i]];
        final = [final stringByAppendingString:@","];
    }
    
    final = [final stringByAppendingString:jsonarr[[jsonarr count] - 1]];
    NSLog(@"JSON String Here: %@", final);
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *user = [ud objectForKey:@"user"];
    NSLog(@"%@", user);
    NSString *postvars = [NSString stringWithFormat:@"newspref=%@&user=%@", final, user];
    NSLog(@"%@", postvars);
    NSString *res = [Func webRequestWith:@"http://www.chensihang.com/iostest/newsPref.php" and:postvars]; //发送保存用户信息的post请求
    
    NSLog(@"Respond Here: %@", res);
}
@end
