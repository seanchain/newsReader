
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
#import "AFHTTPRequestOperationManager+Synchronous.h"


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
    return response;
}

+ (NSDictionary *)webJSONRequestWith:(NSString *)url and:(NSString*)postInfo
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
    NSError* error;
    NSDictionary* response = [NSJSONSerialization JSONObjectWithData:returnData
                                                         options:kNilOptions
                                                           error:&error];
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

+ (NSDictionary*)registerUserInfo:(NSDictionary*)userinfo {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *result = [manager syncPOST:@"http://too-young.me:8000/user/register"
                           parameters:userinfo
                            operation:NULL
                                error:nil];
    return result;
}
+ (NSString*)getTokenAndValidate:(NSString*)userinfo and:(NSString*)username{
//    // 用户获取token
    NSDictionary *str = (NSDictionary*)[Func webJSONRequestWith:@"http://too-young.me:8000/user/oauth/token" and:userinfo];
    NSString *token = [NSString stringWithFormat:@"Bearer %@", str[@"access_token"]];
    NSLog(@"The bearer token is %@", token);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    NSDictionary *result = [manager syncGET:@"http://too-young.me:8000/user/oauth/token_check"
                                  parameters:nil
                                   operation:NULL
                                       error:nil];
    if ([result[@"username"] isEqualToString:username])
        return token;
    else
        return nil;
}
+ (NSString*)setUpKeywords:(NSArray*)keywords And:(NSString*)token{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    NSDictionary *parameters = @{@"keywords": keywords};
    NSString *response = [manager syncPOST:@"http://too-young.me:8000/user/keywords" parameters:parameters operation:NULL error:nil];
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
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
    NSArray *news = [manager syncGET:@"http://too-young.me:8000/user/recommends" parameters:nil operation:NULL error:nil];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    [ud setObject:news forKey:@"news"];
    return news;
}
+ (NSArray*)recommendNews:(NSString*)token {
    NSArray *news = [Func userNews:token];
    NSMutableArray *userNews_ids = [[NSMutableArray alloc] init];
    NSMutableArray *recommend_ids = [[NSMutableArray alloc] init];
    for (NSDictionary *new in news) {
        [userNews_ids addObject:new[@"id"]];
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths objectAtIndex:0];
    NSString *filename=[path stringByAppendingPathComponent:@"recommend5.plist"];
    NSFileManager* fm = [NSFileManager defaultManager];
    [fm createFileAtPath:filename contents:nil attributes:nil];
    for (NSString *news_id in userNews_ids) {
        NSString *urlStr = [NSString stringWithFormat:@"http://too-young.me:8000/news/entry/%@/recommend", news_id];
        NSDictionary *res = [manager syncGET:urlStr parameters:nil operation:NULL error:nil][0];
        if (![userNews_ids containsObject:res[@"id"]] && ![recommend_ids containsObject:res]) {
            [recommend_ids addObject:res];
        }
    }
    NSLog(@"最后的推荐内容为：%@", recommend_ids);
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    [ud setObject:recommend_ids forKey:@"recommend"];
    return nil;
}

+ (NSArray*)getNewsById:(NSString*)newsID and:(NSString*)token {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
    NSString *url = [NSString stringWithFormat:@"http://too-young.me:8000/news/entry/%@", newsID];
    NSArray *ret = [manager syncGET:url parameters:nil operation:NULL error:nil];
    return ret;
}

@end
