//
//  LoginController.h
//  NewsReader
//
//  Created by Sean Chain on 2/17/15.
//  Copyright (c) 2015 Sean Chain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKSplashView.h"

@interface LoginController : UIViewController <SKSplashDelegate>
@property (weak, nonatomic) IBOutlet UITextField *idoremail;
@property (weak, nonatomic) IBOutlet UITextField *passwd;
- (IBAction)login:(id)sender;
- (IBAction)keyboarddown:(id)sender;
- (IBAction)loginIssue:(id)sender;

@end
