//
//  WJWSettingTableViewController.m
//  weibo
//
//  Created by 王继伟 on 16/6/26.
//  Copyright © 2016年 WangJiwei. All rights reserved.
//

#import "WJWSettingTableViewController.h"
#import "WJWFileManager.h"


#define cachePath NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0]
@interface WJWSettingTableViewController () <UITableViewDelegate>

@end

@implementation WJWSettingTableViewController

static NSString *ID = @"cleanRubbishID";
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.title = @"设置";
    
    //    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"jump" style:(UIBarButtonItemStyleDone) target:self action:@selector(jump)];
    
    self.tableView.delegate = self;
//    self.tableView.dataSource = self;
    
    self.tableView.sectionHeaderHeight = 6;
    self.tableView.sectionFooterHeight = 6;
    self.tableView.contentInset = UIEdgeInsetsMake(-25, 0, 0, 0);
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:ID];
}

//- (void) jump
//{
//    UIViewController *vc = [[UIViewController alloc] init];
//
//    vc.view.backgroundColor = [UIColor redColor];
//
//    [self.navigationController pushViewController:vc animated:YES];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  加载storyBoard中设置控制器
 */
+ (instancetype)loadSettingVC
{
    UIStoryboard *settingVCSB = [UIStoryboard storyboardWithName:@"globalStoryBoard" bundle:nil];
    
    return [settingVCSB instantiateViewControllerWithIdentifier:@"Mine-SettingVC-ID"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //计算显示当前缓存有多少垃圾文件
    NSIndexPath *indexPath2 = [NSIndexPath indexPathForRow:0 inSection:3];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath2];
//    cell.textLabel.text = @"清理缓存";
    NSLog(@"==%@", cell.detailTextLabel.text);
    cell.detailTextLabel.text = [self getFileSizeStr];
    NSLog(@"==%@", cell.detailTextLabel.text);
}


#pragma mark -- Table View data Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WJWLog(@"清理完毕 %zd,  %zd", indexPath.section, indexPath.row);
    
    [WJWFileManager removeDirectoryPath:cachePath];
 

    NSIndexPath *indexPath2 = [NSIndexPath indexPathForRow:0 inSection:3];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath2];
    cell.detailTextLabel.text = @"0KB";
}

- (NSString*)getFileSizeStr
{
    NSInteger totalSize = [WJWFileManager getDirectorySize:cachePath];
    
    NSString *str = @"0KB"; //清除缓存
    
    if (totalSize > 1000 * 1000) { //MB
        CGFloat totalSizeF = totalSize / 1000.0 /1000.0;
        str = [NSString stringWithFormat:@"%@(%.1fMB)", str, totalSizeF];
    }else if (totalSize > 1000) { // KB
        CGFloat totalSizeF = totalSize / 1000.0;
        str = [NSString stringWithFormat:@"%@(%.1fKB)", str, totalSizeF];
    }else if (totalSize > 0) //B
    {
        str = [NSString stringWithFormat:@"%@(%.1ldB)", str, (long)totalSize];
    }
//    else
//    {
//        str = @"0KB";
//    }
    
    return str;
}


//#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 5;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return 1;
//}
//
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//
//    if (indexPath.section == 3 && indexPath.row == 0) {
//    }
//    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
//    }
//    
//    cell.textLabel.text = @"清理垃圾";
//    cell.detailTextLabel.text = @"128M";
//    
////    self.tableView
//    
//    return cell;
//}

//+ (instancetype)indexPathForRow:(NSInteger)row inSection:(NSInteger)section
//{
//    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
//
//    cell.textLabel.text = @"清理垃圾";
//    cell.detailTextLabel.text = @"128M";
//    
//    return cell;
//}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
