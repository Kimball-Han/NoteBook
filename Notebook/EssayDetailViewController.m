//
//  EssayDetailViewController.m
//  Notebook
//
//  Created by 韩金波 on 16/7/18.
//  Copyright © 2016年 Psylife. All rights reserved.
//

#import "EssayDetailViewController.h"
#import "PublicClass.h"
#import <Masonry.h>
@interface EssayDetailViewController ()
//@property(nonatomic,strong)UILabel *contentLabel;
//@property(nonatomic,strong)UILabel *titleLabel;
//@property(nonatomic,strong)UILabel *describeLabel;

@end

@implementation EssayDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}




-(void)initUI{
    self.title = self.model.title;
    
    UIScrollView *scrollview = [[UIScrollView alloc] init];
    [self.view addSubview:scrollview];
    
    //title
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.numberOfLines =0;
    titleLabel.font = [UIFont systemFontOfSize:20];
    titleLabel.text = self.model.title;
    [scrollview addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scrollview.mas_top).with.offset(8);
        make.left.equalTo(scrollview.mas_left).with.offset(8);
        make.right.equalTo(self.view.mas_right).with.offset(-8);
    }];
    
    //描述
    UILabel *describeLabel = [[UILabel alloc] init];
    describeLabel.text = [NSString stringWithFormat:@"%@    字数：%@",self.model.datetime,self.model.wordnumber];
    describeLabel.textColor = [UIColor grayColor];
    describeLabel.font = [PublicClass fangsongAndSize:13];
    [scrollview addSubview:describeLabel];
    [describeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).with.offset(8);
        make.left.equalTo(scrollview.mas_left).with.offset(8);
        make.right.equalTo(self.view.mas_right).with.offset(-8);
        make.height.mas_equalTo(@25);
    }];
    //内容
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.numberOfLines = 0;
    contentLabel.font = [PublicClass fangsongAndSize:18];
    [scrollview addSubview:contentLabel];
    contentLabel.text = self.model.content;
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(describeLabel.mas_bottom).with.offset(8);
        make.left.equalTo(scrollview.mas_left).with.offset(8);
        make.right.equalTo(self.view.mas_right).with.offset(0);
        
    }];
    
    [scrollview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsZero);
        make.bottom.equalTo(contentLabel.mas_bottom).with.offset(0);

    }];
    
    
    
    //     make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(8, 8, 8, 0));
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(rightButtonClick:)];
    self.navigationItem.rightBarButtonItem =right;
    
    
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
