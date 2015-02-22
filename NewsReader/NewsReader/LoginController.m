//
//  LoginController.m
//  NewsReader
//
//  Created by Sean Chain on 2/17/15.
//  Copyright (c) 2015 Sean Chain. All rights reserved.
//

#import "LoginController.h"
#import "SKSplashIcon.h"
#import "Func.h"
#import "FirstViewController.h"
#import "AppDelegate.h"

@interface LoginController ()

@property (strong, nonatomic) SKSplashView *splashView;
@property (strong, nonatomic) UIActivityIndicatorView *indicatorView;

@end

@implementation LoginController

@synthesize idoremail;
@synthesize passwd;

- (void) twitterSplash
{
    //Setting the background
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.frame];
    imageView.image = [UIImage imageNamed:@"twitter background.png"];
    [self.view addSubview:imageView];
    //Twitter style splash
    SKSplashIcon *twitterSplashIcon = [[SKSplashIcon alloc] initWithImage:[UIImage imageNamed:@"icon.png"] animationType:SKIconAnimationTypeBounce];
    UIColor *twitterColor = [UIColor colorWithRed:0.25098 green:0.6 blue:1.0 alpha:1.0];
    _splashView = [[SKSplashView alloc] initWithSplashIcon:twitterSplashIcon backgroundColor:twitterColor animationType:SKSplashAnimationTypeNone];
    _splashView.delegate = self; //Optional -> if you want to receive updates on animation beginning/end
    _splashView.animationDuration = 2; //Optional -> set animation duration. Default: 1s
    [self.view addSubview:_splashView];
    [_splashView startAnimation];
}

- (void)viewDidLoad
{
    //准备使用一个沙箱文件来确定是否已经进行了登录。
    static int count = 0;
    [super viewDidLoad];
    if (count == 0) {
        [self twitterSplash];
        count ++;
    }
    UIImage *background = [UIImage imageNamed:@"Background.jpg"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:background];
}



- (IBAction)login:(id)sender
{
    NSString *user = idoremail.text;
    NSString *password = passwd.text;
    NSString *url = @"http://www.chensihang.com/iostest/login.php";
    NSString *poststr = [NSString stringWithFormat:@"idoremail=%@&password=%@", user, password];
    NSString *res = [Func webRequestWith:url and:poststr];
    NSLog(@"%@", res);
    if ([res isEqualToString:@"success"]) {
        NSLog(@"Login successfully");
        
        [self performSegueWithIdentifier:@"tabbar" sender:self];
    }
    else{
        [Func showAlert:res];
    }
}


- (IBAction)keyboarddown:(id)sender
{
    [self.idoremail resignFirstResponder];
    [self.passwd resignFirstResponder];
}

- (IBAction)loginIssue:(id)sender
{
    //这个功能未来完成
    NSLog(@"problem login");
}

@end
