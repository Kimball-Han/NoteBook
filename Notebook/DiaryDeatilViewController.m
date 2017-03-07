//
//  DiaryDeatilViewController.m
//  Notebook
//
//  Created by 韩金波 on 16/7/15.
//  Copyright © 2016年 Psylife. All rights reserved.
//

#import "DiaryDeatilViewController.h"
#import <Masonry.h>
#import "AppConfig.h"
#import "PublicClass.h"
@interface DiaryDeatilViewController ()
@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)UILabel *dayLabel;
@property(nonatomic,strong)UILabel *weatherLabel;
@property(nonatomic,strong)UILabel *locationLabel;
@property(nonatomic,strong)UILabel *contentLabel;
@end

@implementation DiaryDeatilViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    
}

-(void)initUI{
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(rightButtonClick:)];
    self.navigationItem.rightBarButtonItem =right;
    
   self.scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:self.scrollView];
    self.dayLabel.text = self.model.datetime;

    UIColor *grayColor = [UIColor grayColor];
    //周星期几
    self.title = self.model.datetime;
    self.dayLabel = [[UILabel alloc] init];
    self.dayLabel.text = self.model.weekday;
    [self.scrollView addSubview:self.dayLabel];
    self.dayLabel.font = [PublicClass fangsongAndSize:18];
    self.dayLabel.textColor = grayColor;
   //天气
    self.weatherLabel = [[UILabel alloc] init];
    self.weatherLabel.text = self.model.weather;
    self.weatherLabel.font = [PublicClass fangsongAndSize:18];
//    self.weatherLabel.textAlignment = NSTextAlignmentCenter;
    [self.scrollView addSubview:self.weatherLabel];
    self.weatherLabel.textColor = grayColor;
    //位置
    self.locationLabel.font=[PublicClass fangsongAndSize:18];
    self.locationLabel = [[UILabel alloc] init];
    self.locationLabel.text = self.model.location;
    self.locationLabel.textAlignment = NSTextAlignmentRight;
    self.locationLabel.font = [PublicClass fangsongAndSize:18];
    [self.scrollView addSubview:self.locationLabel];
    self.locationLabel.textColor = grayColor;
    
    [self.dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@[self.locationLabel,self.weatherLabel]);
        make.top.equalTo(@[self.locationLabel,self.weatherLabel]);
        make.top.equalTo(self.scrollView).with.offset(8);
        make.left.equalTo(self.scrollView.mas_left).with.offset(8);
        make.height.mas_equalTo([PublicClass fangsongAndSize:20].lineHeight);
        make.width.mas_equalTo(80);
    }];
    
    [self.locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).with.offset(-8);
        make.width.mas_equalTo(100);
    }];
    [self.weatherLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.dayLabel.mas_right).with.offset(0);
        make.right.equalTo(self.locationLabel.mas_left).with.offset(0);
      
    }];
    
    
    self.contentLabel = [[UILabel alloc] init];
    [self.scrollView addSubview:self.contentLabel];
    self.contentLabel.text = self.model.content;
    self.contentLabel.numberOfLines =0;
    self.contentLabel.font= [PublicClass fangsongAndSize:18];
    
    //计算内容大小
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dayLabel.mas_bottom).with.offset(16);
        make.left.equalTo(self.scrollView.mas_left).with.offset(8);
        make.right.equalTo(self.view.mas_right).with.offset(0);
//        make.height.equalTo(@(size.height));
    }];
    UIEdgeInsets padding = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(padding);
        make.bottom.equalTo(self.contentLabel.mas_bottom).with.offset(0);
    }];
    
}
-(void)rightButtonClick:(UIBarButtonItem *)sender;
{
    
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
