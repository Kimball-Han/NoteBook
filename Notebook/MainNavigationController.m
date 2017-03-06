//
//  MainNavigationController.m
//  Notebook
//
//  Created by 韩金波 on 2017/2/28.
//  Copyright © 2017年 Psylife. All rights reserved.
//

#import "MainNavigationController.h"
#import <Chameleon.h>

@interface MainNavigationController ()

@end

@implementation MainNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //设置导航栏颜色
    
    self.navigationBar.barTintColor = [UIColor flatMintColor];
    self.navigationBar.tintColor = [UIColor whiteColor];
    
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName :[UIColor whiteColor]};
//    [self.navigationBar setTranslucent:NO];
//    self.navigationBar.opaque = NO;
//    self.automaticallyAdjustsScrollViewInsets = NO;
  

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
