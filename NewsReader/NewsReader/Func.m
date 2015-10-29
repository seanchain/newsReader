
//
//  Func.m
//  NewsReader
//
//  Created by Sean Chain on 2/17/15.
//  Copyright (c) 2015 Sean Chain. All rights reserved.
//

#import "Func.h"
#import <UIKit/UIKit.h>


@implementation Func
+ (NSString *)webRequestWith:(NSString *)url and:(NSString*)postInfo
{
    NSString *myRequestString = [NSString stringWithString:postInfo];
    NSLog(@"%@", myRequestString);
    
    // Create Data from request
    NSData *myRequestData = [myRequestString dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString:url]];
    [request setHTTPMethod: @"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    [request setHTTPBody: myRequestData];
    NSData *returnData = [NSURLConnection sendSynchronousRequest: request returningResponse: nil error: nil];
    NSString *response = [[NSString alloc] initWithBytes:[returnData bytes] length:[returnData length] encoding:NSUTF8StringEncoding];
    NSLog(@"The response is %@", response);
    return response;
}

+ (void)showAlert:(NSString *)str
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

+ (NSArray*)getUserFav
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *urlstr = [NSString stringWithFormat:@"http://www.chensihang.com/iostest/getKeyword.php?username=%@", [ud objectForKey:@"user"]];
    NSURL *url = [NSURL URLWithString:urlstr];
    NSString *response = [[NSString alloc] initWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    response = [response stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSLog(@"%@", response);
    NSArray *ary = [response componentsSeparatedByString:@","];
    NSLog(@"%@", ary);
    return ary;
}

@end
