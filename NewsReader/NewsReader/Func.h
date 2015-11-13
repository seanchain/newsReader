//
//  Func.h
//  NewsReader
//
//  Created by Sean Chain on 2/17/15.
//  Copyright (c) 2015 Sean Chain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Func : NSObject

+ (NSString *)webRequestWith:(NSString *)url and:(NSString*)postInfo;
+ (void)showAlert:(NSString *)str;
+ (NSArray *)getUserFav;
+ (NSString*)registerUserInfo:(NSDictionary*)userinfo;
+ (NSString*)getTokenAndValidate:(NSDictionary*)userinfo;
+ (NSString*)setUpKeywords:(NSArray*)keywords And:(NSString*)token;
+ (NSString*)updateKeywords:(NSArray*)keywords And:(NSString*)token;
+ (NSArray*)userNews:(NSString*)token;
+ (NSArray*)recommendNews:(NSString*)token;
+ (NSArray*)getNewsById:(NSString*)newsID and:(NSString*)token;
@end
