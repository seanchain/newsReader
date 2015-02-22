//
//  SKSplashIcon.h
//  SKSplashView
//
//  Created by Sachin Kesiraju on 10/25/14.
//  Copyright (c) 2014 Sachin Kesiraju. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKSplashView.h"

typedef NS_ENUM(NSInteger, SKIconAnimationType)
{
    SKIconAnimationTypeBounce,
    SKIconAnimationTypeGrow,
    SKIconAnimationTypeShrink,
    SKIconAnimationTypeFade,
    SKIconAnimationTypePing,
    SKIconAnimationTypeBlink,
    SKIconAnimationTypeNone,
    SKIconAnimationTypeCustom
};

@interface SKSplashIcon : UIImageView

@property (strong, nonatomic) UIColor *iconColor; //Default: white
@property (nonatomic, assign) CGSize iconSize; //Default: 60x60
@property (strong, nonatomic) SKSplashView *splashView;

- (instancetype) initWithImage: (UIImage *) iconImage;

- (instancetype) initWithImage: (UIImage *) iconImage animationType: (SKIconAnimationType) animationType;

- (void) setIconAnimationType: (SKIconAnimationType) animationType;
- (void) setCustomAnimation: (CAAnimation *) animation;

@end

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com 
