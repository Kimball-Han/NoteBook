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
@property(nonatomic,strong)UILabel *weekLabel;
@property(nonatomic,strong)UILabel *weatherLabel;
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
//    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:73/255.0 green:187/255.0 blue:199/255.0 alpha:1.0];
//    [self.navigationItem.backBarButtonItem ti];

    
    self.dayLabel = [[UILabel alloc] init];
    self.dayLabel.text = self.model.datetime;
    [self.scrollView addSubview:self.dayLabel];
    self.dayLabel.font = [PublicClass fangsongAndSize:20];
    self.weekLabel = [[UILabel alloc] init];
    self.weekLabel.text = self.model.weekday;
    self.weekLabel.font = [PublicClass fangsongAndSize:20];
    self.weekLabel.textAlignment = NSTextAlignmentCenter;
    [self.scrollView addSubview:self.weekLabel];
    self.weatherLabel.font=[PublicClass fangsongAndSize:20];
    self.weatherLabel = [[UILabel alloc] init];
    self.weatherLabel.text = self.model.weather;
    self.weatherLabel.textAlignment = NSTextAlignmentRight;
    self.weatherLabel.font = [PublicClass fangsongAndSize:20];
    [self.scrollView addSubview:self.weatherLabel];
    [self.dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@[self.weatherLabel,self.weekLabel]);
        make.top.equalTo(@[self.weatherLabel,self.weekLabel]);
        make.top.equalTo(self.scrollView).with.offset(8);
        make.left.equalTo(self.scrollView.mas_left).with.offset(8);
        make.height.mas_equalTo([PublicClass fangsongAndSize:20].lineHeight);
        make.width.mas_equalTo(150);
    }];
    [self.weatherLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).with.offset(-8);
        make.width.mas_equalTo(100);
    }];
    [self.weekLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.dayLabel.mas_right).with.offset(0);
        make.right.equalTo(self.weatherLabel.mas_left).with.offset(0);
      
    }];
    self.contentLabel = [[UILabel alloc] init];
    [self.scrollView addSubview:self.contentLabel];
    self.contentLabel.text = [NSString stringWithFormat:@"    %@",_model.content];
    self.contentLabel.numberOfLines =0;
    self.contentLabel.font= [PublicClass fangsongAndSize:17];
    CGSize size=[self sizeWithString:self.contentLabel.text font:self.contentLabel.font];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dayLabel.mas_bottom).with.offset(8);
        make.left.equalTo(self.scrollView.mas_left).with.offset(8);
        make.right.equalTo(self.view.mas_right).with.offset(-8);
        make.height.equalTo(@(size.height));
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


-(CGSize)sizeWithString:(NSString *)string font:(UIFont *)font
{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 16, 8000)//限制最大的宽度和高度
                                       options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  |NSStringDrawingUsesLineFragmentOrigin// 采用换行模式
                                    attributes:@{NSFontAttributeName: font}//传人的字体字典
                                       context:nil];
    return rect.size;
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
