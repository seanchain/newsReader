//
//  TagList.m
//  NewsReader
//
//  Created by Sean Chain on 2/28/15.
//  Copyright (c) 2015 Sean Chain. All rights reserved.
//

#import "TagList.h"
#import "DWTagList.h"
#import "Func.h"
#import "ZuSimpelColor.h"

@interface TagList ()

@end

extern NSMutableSet *set;

@implementation TagList

@synthesize textfield;
@synthesize buttonLook;

NSMutableArray *array;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = doubi;
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
    NSLog(@"%@", set);
    NSString *str = textfield.text;
    if (![str isEqualToString:@""] && ![set containsObject:str]) {
        [array addObject:str];
        [set addObject:str];
    }
    [tagList setTags:array];
    [self.view addSubview:tagList];
    textfield.text = nil;
    [self.textfield resignFirstResponder];
}


- (IBAction)submit:(id)sender {
    NSArray *jsonarr = [NSArray arrayWithObjects:[set allObjects], nil];
    jsonarr = jsonarr[0];
    NSString *final = @"";
    if ([jsonarr count] == 0) {
        [Func showAlert:@"没有选中任何的关键词"];
    }
    
    else {
        for (int i = 0; i < [jsonarr count] - 1; i ++) {
            final = [final stringByAppendingString:jsonarr[i]];
            final = [final stringByAppendingString:@","];
        }
        
        final = [final stringByAppendingString:jsonarr[[jsonarr count] - 1]];
        NSLog(@"JSON String Here: %@", final);
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSString *user = [ud objectForKey:@"user"];
        NSData *dataSave = [NSKeyedArchiver archivedDataWithRootObject:set];
        [ud setObject:dataSave forKey:@"UserPreference"];
        NSLog(@"%@", user);
        NSString *postvars = [NSString stringWithFormat:@"newspref=%@&user=%@", final, user];
        NSLog(@"%@", postvars);
        
        NSString *username = [ud valueForKey:@"user"];
        NSString *email = [ud valueForKey:@"email"];
        NSString *displayname = [ud valueForKey:@"user"];
        NSString *password = [ud valueForKey:@"password"];
        NSDictionary *res = [Func registerUserInfo:@{@"username":username, @"email":email, @"displayname":displayname, @"password":password}];
        NSLog(@"Result here: %@", res);
        NSString *token = @"";
        if (res[@"succeeded"]) {
            NSString *poststr = [ NSString stringWithFormat:@"username=%@&password=%@&grant_type=password&client_id=hhh&client_secret=hhh", username, password];
            token = [Func getTokenAndValidate:poststr and:username];
        }
        if (token) {
            [ud setObject:token forKey:@"token"]; // 设置token
            [Func setUpKeywords:[set allObjects] And:token];
        }
        
        // 这个地方通过发送请求初始化用户对于新闻的偏好
        [self performSegueWithIdentifier:@"main" sender:self.view];
    }
}
@end
