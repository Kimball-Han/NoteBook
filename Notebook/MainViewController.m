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
#import <CoreLocation/CoreLocation.h>
#import "AppConfig.h"
#import "AppDelegate.h"
@interface MainViewController ()<SelectMenuViewDelegate,CLLocationManagerDelegate,NSURLConnectionDelegate>
@property(nonatomic,strong)CLLocationManager *locationManager;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}



-(void)initUI
{
    NSArray *VCArrays = self.viewControllers;
    
    for (UIViewController *vc in VCArrays) {
        NSString *title = vc.tabBarItem.title;
        vc.tabBarItem.image = [UIImage imageNamed:title] ;
        vc.tabBarItem.selectedImage = [UIImage imageNamed:title] ;
        //        [vc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:COLOR_DEEP} forState:UIControlStateNormal];
        //        [vc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateSelected];
    }
//    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor]} forState:UIControlStateNormal];
//     [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor greenColor]} forState:UIControlStateNormal];
    
    CustomTabBar *tabBar = [[CustomTabBar alloc] init];
    [tabBar.addButton addTarget:self action:@selector(addButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self setValue:tabBar forKey:@"tabBar"];
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateWeather:) name:UIApplicationWillEnterForegroundNotification object:app.locationInfo];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:73/255.0 green:187/255.0 blue:199/255.0 alpha:1.0];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName :[UIColor whiteColor]};
    
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
          AppDelegate *app =[UIApplication sharedApplication].delegate;
        if (placemark.locality.length >0 && ![placemark.locality  isEqualToString:app.locationInfo]) {
            app.locationInfo = placemark.locality;
             [weakSelf updateWeather:app.locationInfo];
          
        }
       
    }];
}
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    KBLog(@"定位失败");
}

-(void)updateWeather:(NSString *)cityName
{
    if ([cityName isEqualToString:@"未知"]) {
        
        return;
    }
    NSURL *url = [NSURL URLWithString:[[NSString stringWithFormat:WEATHER_URL,cityName] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
  
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];

    AppDelegate *app = [UIApplication sharedApplication].delegate;
    __weak typeof(app) weakApp = app;
    
    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            
        }else{
            NSDictionary *obj =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:[[obj objectForKey:@"data"] dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
            NSString *weather=  [[dict objectForKey:@"retData"] objectForKey:@"weather"];
            if (weather.length>0) {
                KBLog(@"%@",weather);
                
                weakApp.weatherInfo = weather;
            }
        }
    }];
    [task resume];
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
