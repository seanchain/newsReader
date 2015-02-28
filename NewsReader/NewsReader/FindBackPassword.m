//
//  FindBackPassword.m
//  NewsReader
//
//  Created by Sean Chain on 2/28/15.
//  Copyright (c) 2015 Sean Chain. All rights reserved.
//

#import "FindBackPassword.h"
#import "Func.h"

@interface FindBackPassword ()

@end

@implementation FindBackPassword

@synthesize email;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)click:(id)sender {
    NSString *emailaddr = email.text;
    NSString *url = @"http://www.chensihang.com/iostest/mail_val.php";
    NSString *poststr = [NSString stringWithFormat:@"email=%@", emailaddr];
    NSString *res = [Func webRequestWith:url and:poststr];
    NSLog(@"%@", res);
    if ([res isEqualToString:@"success"]) { //登陆成功
        [Func showAlert:@"新的密码已发至您的邮箱，请查验"];
    }
    else{
        [Func showAlert:@"您并没有使用此邮箱注册！请更换或者重新注册"];
    }
}
@end
