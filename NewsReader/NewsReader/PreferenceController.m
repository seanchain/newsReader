//
//  PreferenceController.m
//  
//
//  Created by Sean Chain on 5/26/15.
//
//

#import "PreferenceController.h"
#import "AFHTTPRequestOperationManager.h"
#import "Func.h"

@implementation PreferenceController
@synthesize indexpath;
@synthesize table;
@synthesize keywords;
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:NO];
    NSLog(@"%@", indexpath);
    self.table.dataSource = self;
    self.table.delegate = self;
    [self.table reloadData];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSData *favData = [ud objectForKey:@"UserPreference"];
    NSArray *results = [[NSKeyedUnarchiver unarchiveObjectWithData:favData] allObjects];
    keywords = [[NSMutableArray alloc] initWithArray:results];
    NSLog(@"-\n%@-\n", keywords);
}

- (IBAction)add:(id)sender {
    NSLog(@"Click the button!");
    UIAlertView *inputAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入新的关键字名称" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    inputAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [inputAlert textFieldAtIndex:0].placeholder = @"关键词";
    [inputAlert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSString *filename = [alertView textFieldAtIndex:0].text;
        //filename为用户输入的文件名，需要过滤特殊字符
        [filename characterAtIndex:0];
        BOOL isValid = YES;
        for (int i = 0; i < filename.length; i ++) {
            char ch = [filename characterAtIndex:i];
            if (ch == '.' || ch == '/') {
                isValid = NO;
            }
        }
        if (!isValid) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"输入非法字符" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        else
            [self addNewRow:filename];
    }
}

- (void)addNewRow:(NSString*)name
{
    //获取ios应用沙盒内的文件的目录
    [keywords addObject:name];
    [self.table reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    NSInteger rowNO = indexPath.row;
    cell.textLabel.text = [keywords objectAtIndex:rowNO];
    cell.layer.cornerRadius = 12;
    cell.layer.masksToBounds = YES;
    return cell;
}

- (UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return keywords.count;
}

- (NSString*)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void) tableView:(UITableView *)tableView commitEditingStyle:
(UITableViewCellEditingStyle)editingStyle
 forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSInteger rowNo = [indexPath row];
        NSLog(@"Row Number is %lu", rowNo);
        NSLog(@"The object which is going to be deleted is %@", keywords[rowNo]);
        // 从底层NSArray集合中删除指定数据项
        [keywords removeObjectAtIndex:rowNo];
        // 从UITable程序界面上删除指定表格行。
        [tableView deleteRowsAtIndexPaths:[NSArray
                                           arrayWithObject:indexPath]
                         withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

-(void)didMoveToParentViewController:(UIViewController *)parent
{
    NSLog(@"back to parent controller");
    [self saveValueToDB];
}

- (void)saveValueToDB
{
    NSLog(@"进行服务器端数据的更新");
    // 这里发送异步请求
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *str = @"";
    for (int i = 0; i < [keywords count]; i ++) {
        str = [str stringByAppendingString:keywords[i]];
        str = [str stringByAppendingString:@","];
    }
    NSLog(@"%@", str);
    NSDictionary *params = @{@"ary":str};
    [manager POST:@"http:www.chensihang.com/iostest/keywordupdate.php" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"RESPONSE: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}



@end
