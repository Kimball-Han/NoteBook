//
//  MainViewController.m
//  Notebook
//
//  Created by 韩金波 on 16/4/6.
//  Copyright © 2016年 Psylife. All rights reserved.
//

#import "MainViewController.h"
#import "CustomTabBar.h"
#import "SelectMenuViewController.h"
#import "WriteViewController.h"
#import "WriteEssayViewController.h"
#import "WriteWordViewController.h"

#import "AppDelegate.h"
#import <Chameleon.h>
#import "PublicClass.h"

#import "DiaryViewController.h"
#import "EssayViewController.h"
#import "WordsBookViewController.h"
#import "MeViewController.h"
@interface MainViewController ()<SelectMenuViewDelegate,NSURLConnectionDelegate>

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}



-(void)initUI
{
    
 
   

    //自定义tabBar
    CustomTabBar *tabBar = [[CustomTabBar alloc] init];
    [tabBar.addButton addTarget:self action:@selector(addButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self setValue:tabBar forKey:@"tabBar"];

    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.view.backgroundColor = [UIColor whiteColor];
  
    
}




-(void)addButtonClick
{

    [self performSegueWithIdentifier:@"selectMenu" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"selectMenu"]) {
        
        SelectMenuViewController *destinationVc=  segue.destinationViewController;
        destinationVc.delegate=self;
    }
    
}

#pragma mark - SelectMenuViewDelegate
-(void)SelectMenuView:(SelectMenuViewType)type
{
   
 
    switch (type) {
        case SelectMenuViewTypeDiary:
        {
            WriteViewController *vc=[[WriteViewController alloc] init];
            [self presentViewController:vc animated:YES completion:nil];
            
        }
            break;
        case SelectMenuViewTypeEssay:
        {
            WriteEssayViewController *vc = [[WriteEssayViewController alloc] init];
            [self presentViewController:vc animated:YES completion:nil];
        }
            break;
        case SelectMenuViewTypeWord:
        {
            [self performSegueWithIdentifier:@"writeWord" sender:self.tabBarController ];
        }
            break;
            
        default:
            break;
    }
   
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
