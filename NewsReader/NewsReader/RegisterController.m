//
//  RegisterController.m
//  NewsReader
//
//  Created by Sean Chain on 2/17/15.
//  Copyright (c) 2015 Sean Chain. All rights reserved.
//

#import "RegisterController.h"
#import "Func.h"

@interface RegisterController ()

@end

@implementation RegisterController

@synthesize emailtext;
@synthesize idtext;
@synthesize passwordtext;
@synthesize passwordcomfirmtext;

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage *bg = [UIImage imageNamed:@"Background.jpg"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:bg];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)registerUser:(id)sender {
    NSString *email = emailtext.text;
    NSString *userid = idtext.text;
    NSString *password = passwordtext.text;
    NSString *passwordcomfirm = passwordcomfirmtext.text;
    if (![password isEqualToString:passwordcomfirm]) {
        [Func showAlert:@"输入的确认密码同原密码不同，请重新输入"];
    }
    NSString *url = @"http://www.chensihang.com/iostest/register.php";
    NSString *poststr = [NSString stringWithFormat:@"id=%@&email=%@&password=%@", userid, email,  password];
    NSString *res = [Func webRequestWith:url and:poststr];
    if ([res isEqualToString:@"success"]) {
        [self performSegueWithIdentifier:@"regbar" sender:self];
    }
    else [Func showAlert:res];
}

@end
