
//
//  Func.m
//  NewsReader
//
//  Created by Sean Chain on 2/17/15.
//  Copyright (c) 2015 Sean Chain. All rights reserved.
//

#import "Func.h"
#import <UIKit/UIKit.h>
#import "AFHTTPRequestOperationManager.h"


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

+ (NSString*)registerUserInfo:(NSDictionary*)userinfo {
    __block NSString *responseFromServer = @"";
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = userinfo;
    [manager POST:@"http://too-young.me:8000/user/register" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        responseFromServer = responseFromServer;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        responseFromServer = nil;
    }];
    return responseFromServer;
}
+ (NSString*)getTokenAndValidate:(NSDictionary*)userinfo {
    // 用户获取token
    __block NSString *token = @"Bearer ";
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = userinfo;
    [manager POST:@"http://too-young.me:8000/user/oauth/token" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject[@"access_token"]);
        token = [token stringByAppendingString:responseObject[@"access_token"]];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];

    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];

    [manager GET:@"http://too-young.me:8000/user/oauth/token_check" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"username"] isEqualToString:userinfo[@"username"]]) {
            ;
        }
        else {
            token = nil;
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    return token;
}
+ (NSString*)setUpKeywords:(NSArray*)keywords And:(NSString*)token{
    __block NSString *response = @"";
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    NSDictionary *parameters = @{@"keywords": keywords};
    [manager POST:@"http://too-young.me:8000/user/keywords" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        response = responseObject;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        response = nil;
    }];
    return response;
}

+ (NSString*)updateKeywords:(NSArray*)keywords And:(NSString*)token {
    __block NSString *response = @"";
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    NSDictionary *parameters = @{@"keywords": keywords};
    [manager PUT:@"http://too-young.me:8000/user/keywords" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        response = responseObject;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        response = nil;
    }];
    return response;
}
+ (NSArray*)userNews:(NSString*)token {
    __block NSArray* news;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];

    [manager GET:@"http://too-young.me:8000/user/recommends" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        news = responseObject;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        news = nil;
    }];
    return news;
}
+ (NSArray*)recommendNews:(NSString*)token {
    NSArray *news = [Func userNews:token];
    NSMutableArray *userNews_ids = [[NSMutableArray alloc] init];
    NSMutableArray *recommend_ids = [[NSMutableArray alloc] init];
    for (NSDictionary *new in news) {
        [userNews_ids addObject:new[@"id"]];
    }
    for (NSInteger i = 0; i < [userNews_ids count]; i ++) {
        NSString *newsid = userNews_ids[i];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
        NSString *urlStr = [NSString stringWithFormat:@"http://too-young.me:8000/news/entry/%@/recommend", newsid];
        [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSArray *ary = responseObject;
            for (NSDictionary *post in ary) {
                if ([recommend_ids count] < 30) {
                    if (![userNews_ids containsObject:post[@"id"]] && ![recommend_ids containsObject:post[@"id"]]) {
                        [recommend_ids addObject:post[@"id"]];
                    }
                }
                else
                    break;
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
    }
    NSMutableArray *ret = [[NSMutableArray alloc] init];
    for (NSString *newsId in recommend_ids) {
        [ret addObject:[Func getNewsById:newsId and:token]];
    }
    return ret;
}

+ (NSArray*)getNewsById:(NSString*)newsID and:(NSString*)token {
    __block NSArray* news;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
    NSString *url = [NSString stringWithFormat:@"http://too-young.me:8000/news/entry/%@", newsID];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        news = responseObject;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        news = nil;
    }];
    return news;
}

@end
