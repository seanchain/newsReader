//
//  ZuSimpelColor.m
//  ZuSimpelColor
//
//  Created by Sean Chain on 3/1/15.
//  Copyright (c) 2015 Sean Chain. All rights reserved.
//

#import "ZuSimpelColor.h"


@interface ZuSimpelColor ()

@end

@implementation ZuSimpelColor

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

+ (UIColor *) R:(NSUInteger)r G:(NSUInteger)g B:(NSUInteger)b
{
    return [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0f];
}

@end
