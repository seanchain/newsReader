//
//  TagList.h
//  NewsReader
//
//  Created by Sean Chain on 2/28/15.
//  Copyright (c) 2015 Sean Chain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DWTagList.h"

@interface TagList : UIViewController
{
    DWTagList *tagList;
}


@property (weak, nonatomic) IBOutlet UITextField *textfield;
- (IBAction)add:(id)sender;
- (IBAction)submit:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *buttonLook;

@end
