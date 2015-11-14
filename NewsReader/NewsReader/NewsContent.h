//
//  NewsContent.h
//  NewsReader
//
//  Created by Sean Chain on 2/18/15.
//  Copyright (c) 2015 Sean Chain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsContent : UIViewController
@property (weak, nonatomic) NSIndexPath* indexpath;
@property (weak, nonatomic) NSString* newsID;
@property (weak, nonatomic) IBOutlet UIWebView *web;

@end
