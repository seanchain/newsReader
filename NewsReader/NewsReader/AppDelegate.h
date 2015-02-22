//
//  AppDelegate.h
//  NewsReader
//
//  Created by Sean Chain on 2/17/15.
//  Copyright (c) 2015 Sean Chain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FirstViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) FirstViewController *viewController;
@property (strong, nonatomic) UINavigationController *naviController;

@end

