//
//  RegisterController.h
//  NewsReader
//
//  Created by Sean Chain on 2/17/15.
//  Copyright (c) 2015 Sean Chain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *emailtext;
@property (weak, nonatomic) IBOutlet UITextField *idtext;
@property (weak, nonatomic) IBOutlet UITextField *passwordtext;
@property (weak, nonatomic) IBOutlet UITextField *passwordcomfirmtext;
- (IBAction)registerUser:(id)sender;

@end
