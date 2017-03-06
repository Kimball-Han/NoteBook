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
#import "AppConfig.h"
#import "AppDelegate.h"
#import <Chameleon.h>
#import "PublicClass.h"
#import <CoreLocation/CoreLocation.h>
#import "DiaryViewController.h"
#import "EssayViewController.h"
#import "WordsBookViewController.h"
#import "MeViewController.h"
#import "MainNavigationController.h"
@interface MainViewController ()<SelectMenuViewDelegate,NSURLConnectionDelegate,CLLocationManagerDelegate>
@property(nonatomic,strong)CLLocationManager *locationManager;
@property(nonatomic,copy)NSString *locationInfo;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    self.locationInfo = @"未知";
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

    SelectMenuViewController *destinationVc=  [[SelectMenuViewController alloc] init];
    destinationVc.delegate=self;
    //设置模式展示风格
//    [destinationVc setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    destinationVc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;

    //必要配置
//    self.navigationController.modalPresentationStyle = UIModalPresentationCurrentContext;
//    self.navigationController.providesPresentationContextTransitionStyle = YES;
//    self.navigationController.definesPresentationContext = YES;
    [self.navigationController presentViewController:destinationVc animated:YES completion:nil];

}



#pragma mark - SelectMenuViewDelegate
-(void)SelectMenuView:(SelectMenuViewType)type
{
   
    [self OperationModel:(OperationModel)type];
    
   
}
-(void)OperationModel:(OperationModel)model
{
    switch (model) {
        case OperationModelPresentWriteDiary:
        {
            WriteViewController *vc=[[WriteViewController alloc] init];
            vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            vc.loactionCity = self.locationInfo;
            [self.navigationController presentViewController:vc animated:YES completion:nil];
            
        }
            break;
        case OperationModelPresentWriteEssay:
        {
            WriteEssayViewController *vc = [[WriteEssayViewController alloc] init];
            vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self.navigationController presentViewController:vc animated:YES completion:nil];
        }
            break;
        case OperationModelPresentWriteWorld:
        {
            WriteWordViewController *vc = [[WriteWordViewController alloc] init];
            vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self.navigationController presentViewController:vc animated:YES completion:nil];
        }
            break;
            
        default:
            break;
    }
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self startLocalization];
    
}


#pragma mark - 定位
-(void)startLocalization
{
    if ([CLLocationManager locationServicesEnabled]) {
        self.locationManager=[[CLLocationManager alloc] init];
        self.locationManager.delegate=self;
        [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        if (IOS8) {
            [self.locationManager requestAlwaysAuthorization];
        }
        [self.locationManager startUpdatingLocation];
    }else{
        [self showAlertWithTitle:@"定位失败" andMessage:@"定位不成功 ,请确认开启定位"];
    }
    
}
- (void)showAlertWithTitle:(NSString *)title andMessage:(NSString *)message{
    if (IOS8) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        [[[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil] show];
    }
}

#pragma mark - 定位代理方法
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *loc = [locations objectAtIndex:0];
    
    // NSLog(@"经纬度  %f  %f ",loc.coordinate.latitude,loc.coordinate.longitude);
    CLGeocoder * geocoder = [[CLGeocoder alloc] init];
    // 经纬度对象
    __weak typeof(self) weakSelf = self;
    
    [geocoder reverseGeocodeLocation:loc completionHandler:^(NSArray *placemarks, NSError *error) {
        // 回调中返回当前位置的地理位置信息
        // 描述地名的类
        CLPlacemark * placemark = placemarks[0];
        //KBLog(@">>%@ ,%@",placemark.locality,placemark.subLocality);
        
        if (placemark.locality.length >0 && ![placemark.locality  isEqualToString:weakSelf.locationInfo]) {
            weakSelf.locationInfo = placemark.locality;
            
        }
        
    }];
}
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    KBLog(@"定位失败");
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
