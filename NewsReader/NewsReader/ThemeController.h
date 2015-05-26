//
//  ThemeController.h
//  沉思·航
//
//  Created by Sean Chain on 5/14/15.
//  Copyright (c) 2015 Sean Chain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IZValueSelectorView.h"

@interface ThemeController : UIViewController <IZValueSelectorViewDataSource, IZValueSelectorViewDelegate>
@property (weak, nonatomic) IBOutlet IZValueSelectorView *selectorVertical;

@property (nonatomic, strong) id indexpath;
@end
