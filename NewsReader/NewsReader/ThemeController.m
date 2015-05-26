//
//  ThemeController.m
//  沉思·航
//
//  Created by Sean Chain on 5/14/15.
//  Copyright (c) 2015 Sean Chain. All rights reserved.
//

#import "ThemeController.h"
#import "ZuSimpelColor.h"

@implementation ThemeController

@synthesize indexpath;
@synthesize selectorVertical = _selectorVertical;

NSArray *arr;

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.wantHorizontal = YES;
    
    
    //YOU CAN ALSO ASSIGN THE DATA SOURCE AND THE DELEGATE IN CODE (IT'S ALREADY DONE IN NIB, BUT DO AS YOU PREFER)
    self.selectorVertical.dataSource = self;
    self.selectorVertical.delegate = self;
    self.selectorVertical.shouldBeTransparent = YES;
    self.selectorVertical.horizontalScrolling = NO;
    
    
    arr = [NSArray arrayWithObjects:@"GREEN", @"PINK", @"BLACK", @"BLUE", @"ORANGE", nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma IZValueSelector dataSource
- (NSInteger)numberOfRowsInSelector:(IZValueSelectorView *)valueSelector {
    return 5;
}



//ONLY ONE OF THESE WILL GET CALLED (DEPENDING ON the horizontalScrolling property Value)
- (CGFloat)rowHeightInSelector:(IZValueSelectorView *)valueSelector {
    return 70.0;
}

- (CGFloat)rowWidthInSelector:(IZValueSelectorView *)valueSelector {
    return 70.0;
}
//
//- (UIView *)selector:(IZValueSelectorView *)valueSelector viewForRowAtIndex:(NSInteger)index
//{
//    return [self selector:valueSelector viewForRowAtIndex:index selected:NO];
//}

- (UIView *)selector:(IZValueSelectorView *)valueSelector viewForRowAtIndex:(NSInteger)index selected:(BOOL)selected {
    UILabel * label = nil;
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.selectorVertical.frame.size.width, 70)];
    label.text = arr[index];
    label.font = [UIFont fontWithName:@"SourceHanSansCN-Medium" size:15];
    label.textAlignment =  NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    if (selected) {
        label.textColor = [UIColor redColor];
    } else {
        label.textColor = [UIColor blackColor];
    }
    return label;
}

- (CGRect)rectForSelectionInSelector:(IZValueSelectorView *)valueSelector {
    //Just return a rect in which you want the selector image to appear
    //Use the IZValueSelector coordinates
    //Basically the x will be 0
    //y will be the origin of your image
    //width and height will be the same as in your selector image
    return CGRectMake(0.0, self.selectorVertical.frame.size.height/2 - 35.0, 90.0, 70.0);
}

#pragma IZValueSelector delegate
- (void)selector:(IZValueSelectorView *)valueSelector didSelectRowAtIndex:(NSInteger)index {
    NSLog(@"%@", arr[index]);
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSData *colorData;
    switch (index) {
        case 0:
            colorData = [NSKeyedArchiver archivedDataWithRootObject:forestgreen];
            [ud setValue:colorData forKey:@"scheme"];
            break;
        case 1:
            colorData = [NSKeyedArchiver archivedDataWithRootObject:deeppink];
            [ud setValue:colorData forKey:@"scheme"];
            break;
        case 2:
            colorData = [NSKeyedArchiver archivedDataWithRootObject:black];
            [ud setValue:colorData forKey:@"scheme"];
            break;
        case 3:
            colorData = [NSKeyedArchiver archivedDataWithRootObject:skyblue];
            [ud setValue:colorData forKey:@"scheme"];
            break;
        case 4:
            colorData = [NSKeyedArchiver archivedDataWithRootObject:darkorange];
            [ud setValue:colorData forKey:@"scheme"];
            break;
        default:
            break;
    }
}



@end
