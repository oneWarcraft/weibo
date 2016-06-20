//
//  WJWAdvertViewController.m
//  baiSiBuDeJie
//
//  Created by Wang Wei on 16/6/19.
//  Copyright © 2016年 WangJiwei. All rights reserved.
//

#import "WJWAdvertViewController.h"
#define iphone6P (WJWScreenH == 736)
#define iphone6 (WJWScreenH == 667)
#define iphone5 (WJWScreenH == 568)
#define iphone4 (WJWScreenH == 480)
#define WJWScreenH [UIScreen mainScreen].bounds.size.height
#define WJWScreenW [UIScreen mainScreen].bounds.size.width

@interface WJWAdvertViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *Adver_ImageView;

@end

@implementation WJWAdvertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self setupLaughImage];
}

- (void) setupLaughImage
{
    UIImage *image = nil;
    if (iphone6P) {
        image = [UIImage imageNamed:@"LaunchImage-800-Portrait-736h@3x.png"];
    }else if (iphone6)
    {
        image = [UIImage imageNamed:@"LaunchImage-800-667h.png"];
    }else if (iphone5)
    {
        image = [UIImage imageNamed:@"LaunchImage-700-568h.png"];
    }else if (iphone4)
    {
        image = [UIImage imageNamed:@"LaunchImage-700.png"];
    }
    _Adver_ImageView.image = image;
        
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
