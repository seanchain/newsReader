//
//  PreferenceController.h
//  
//
//  Created by Sean Chain on 5/26/15.
//
//

#import <UIKit/UIKit.h>

@interface PreferenceController : UIViewController <UIAlertViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) id indexpath;
- (IBAction)add:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *table;

@property (nonatomic, strong) NSMutableArray *keywords;

@end
