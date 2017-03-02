//
//  AppDelegate.m
//  Notebook
//
//  Created by 韩金波 on 16/4/6.
//  Copyright © 2016年 Psylife. All rights reserved.
//

#import "AppDelegate.h"
#import "MainNavigationController.h"
#import "MainViewController.h"
#import <Chameleon.h>
#import "PublicClass.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    NSArray * array = @[@{
                            @"title":@"日记",
                            @"class":@"DiaryViewController"
                            },
                        @{
                            @"title":@"随笔",
                            @"class":@"EssayViewController"
                            },
                        @{
                            @"title":@"单词本",
                            @"class":@"WordsBookViewController"
                            },
                        @{
                            @"title":@"我的",
                            @"class":@"MeViewController"
                            }];
    NSMutableArray *VCArrays = [NSMutableArray array];
    
    for (NSDictionary *info in array) {
        UIViewController *vc = [[NSClassFromString(info[@"class"]) alloc]init];
        
        NSString *title = info[@"title"];
        vc.tabBarItem.title = title;
        
        vc.tabBarItem.image = [UIImage imageNamed:title] ;
        vc.tabBarItem.selectedImage = [[PublicClass image:[UIImage imageNamed:title] WithColor:[UIColor flatMintColor]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] ;
        //    [vc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:COLOR_DEEP} forState:UIControlStateNormal];
        [vc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor flatMintColor]} forState:UIControlStateSelected];
        
        [VCArrays addObject:vc];
    }
    MainViewController *tabvc = [[MainViewController alloc] init];
    tabvc.viewControllers = VCArrays;
    
    
    MainNavigationController *nav = [[MainNavigationController alloc] initWithRootViewController:tabvc];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen  mainScreen].bounds];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
