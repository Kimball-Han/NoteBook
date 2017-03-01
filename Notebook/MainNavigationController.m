//
//  MainNavigationController.m
//  Notebook
//
//  Created by 韩金波 on 2017/2/28.
//  Copyright © 2017年 Psylife. All rights reserved.
//

#import "MainNavigationController.h"
#import <Chameleon.h>
#import <CoreLocation/CoreLocation.h>
#import "AppConfig.h"

@interface MainNavigationController ()<CLLocationManagerDelegate>
@property(nonatomic,strong)CLLocationManager *locationManager;

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
    //初始位置：未知
    self.locationInfo = @"未知";

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
