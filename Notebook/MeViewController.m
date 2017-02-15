//
//  MeViewController.m
//  Notebook
//
//  Created by 韩金波 on 16/4/6.
//  Copyright © 2016年 Psylife. All rights reserved.
//

#import "MeViewController.h"
#import "FMDBManager.h"
#import <Masonry.h>
#import "AESCrypt.h"
#import "AppConfig.h"
#import "PublicClass.h"
#import "KBWave.h"
@interface MeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic)  UITableView *tableView;
@end

@implementation MeViewController
{
    NSArray *_arrayItem;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
   
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [(HeaderView *)self.tableView.tableHeaderView getcount];
    
    NSUserDefaults *userDe = [NSUserDefaults standardUserDefaults];
    NSString *user = [userDe objectForKey:@"username"];
    user = [AESCrypt decrypt:user  password:AES_PASSWORD];
    
    self.navigationController.navigationBarHidden = YES;
    
    self.tabBarController.navigationItem.title = [NSString stringWithFormat:@"%@",user];
    self.tabBarController.navigationItem.rightBarButtonItem = nil;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}
-(void)initUI
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.tableView.bounces = NO;
    [self.view addSubview:self.tableView];
    
    self.tableView.tableFooterView= [[UIView alloc] init];
    HeaderView * headerView = [[HeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 220+60)];
    self.tableView.tableHeaderView = headerView;
    
//    ,@"备份",@"导出"
    _arrayItem = @[@"修改密码",@"欢迎评分",@"联系我们"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrayItem.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"meId"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"meId"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        cell.textLabel.text = _arrayItem[indexPath.row];
        cell.textLabel .font =[PublicClass fangsongAndSize:20];
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 8;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
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


@implementation HeaderView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initUI];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
          [self initUI];
    }
    return self;
}
-(UIImageView *)header
{
    if (!_header) {
       
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width-80.0)/2,0 , 80, 80)];
        [self addSubview:image];
        image.layer.cornerRadius = 40;
        image.layer.masksToBounds = YES;
        NSString *headPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Library"] stringByAppendingPathComponent:@"head.png"];
        NSFileManager *fileManger = [NSFileManager defaultManager];
        if ([fileManger fileExistsAtPath:headPath]) {
            image.image = [UIImage imageWithContentsOfFile:headPath];
        }else{
            image.image = [UIImage imageNamed:@"head"];
        }

        _header= image;
       
    }
    return _header;
}


-(UILabel *)diaryLabel
{
    if (!_diaryLabel) {
        UILabel *label = [[UILabel alloc ] init];
        label.numberOfLines =0;
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"0篇\n日记";
        [self addSubview:label];
        label.font =[PublicClass fangsongAndSize:20];
        _diaryLabel = label;
    }
    return _diaryLabel;
}

-(UILabel *)essayLabel
{
    if (!_essayLabel) {
        UILabel *label = [[UILabel alloc ] init];
        [self addSubview:label];
         label.numberOfLines =0;
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"0篇\n随笔";
        label.font =[PublicClass fangsongAndSize:20];
        _essayLabel = label;
    }
    return _essayLabel;
}

-(UILabel *)wordLabel
{
    if (!_wordLabel) {
        UILabel *label = [[UILabel alloc ] init];
        [self addSubview:label];
         label.numberOfLines =0;
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"0个\n单词";
        label.font =[PublicClass fangsongAndSize:20];
        _wordLabel = label;
    }
    return _wordLabel;
}
-(void)initUI{
    CGFloat upHeight = 120+60;
    KBWave *upview = [[KBWave alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, upHeight)];
    upview.backgroundColor = [UIColor colorWithRed:94/255.0 green:196/255.0 blue:207/255.0 alpha:1.0];
    [self addSubview:upview];
//    [upview mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.mas_top).with.offset(0);
//        make.left.equalTo(self.mas_left).with.offset(0);
//        make.right.equalTo(self.mas_right).with.offset(0);
//        make.height.mas_equalTo(@150);
//    }];
    CGFloat waveHeight = upview.waveHeight;
    __weak typeof(self)weakSelf = self;
    upview.waveBlock =^(CGFloat currentY){
         CGRect headFrame = [weakSelf.header frame];
        headFrame.origin.y = (upHeight - 80 + currentY - waveHeight);
        weakSelf.header.frame = headFrame;
    };
    [upview startWaveAnimation];
//    [self.header mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//         make.center.equalTo(upview);
////        make.left.equalTo(upview.mas_left).with.offset(40);
//        make.size.mas_equalTo(CGSizeMake(80, 80));
//    }];
    
    
  
    NSString *headPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Library"] stringByAppendingPathComponent:@"head.png"];
    NSFileManager *fileManger = [NSFileManager defaultManager];
    if ([fileManger fileExistsAtPath:headPath]) {
        self.header.image = [UIImage imageWithContentsOfFile:headPath];
    }else{
        self.header.image = [UIImage imageNamed:@"head"];
    }
    
   
    int padding1 = 1;
    [self.diaryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
          make.top.equalTo(upview.mas_bottom).with.offset(0);
        
        make.centerY.equalTo(@[self.essayLabel,self.wordLabel]);
        make.left.equalTo(self.mas_left).with.offset(padding1);
        make.height.mas_equalTo(@80);
        make.width.equalTo(@[self.essayLabel,self.wordLabel]);
      
    }];
    
    [self.essayLabel mas_makeConstraints:^(MASConstraintMaker *make) {

        make.left.equalTo(self.diaryLabel.mas_right).with.offset(padding1);
        make.right.equalTo(self.wordLabel.mas_left).with.offset(-padding1);
        make.height.mas_equalTo(@80);
    }];
    [self.wordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).with.offset(-padding1);
        make.height.mas_equalTo(@80);
    }];
    
}

-(void)getcount
{
    NSNumber *d=  [[FMDBManager manager] statisticsTotalNumForTable:@"t_diary"];
    NSNumber *e=   [[FMDBManager manager] statisticsTotalNumForTable:@"t_essay"];
    NSNumber *w=   [[FMDBManager manager] statisticsTotalNumForTable:@"t_word"];
    self.diaryLabel.text = [NSString stringWithFormat:@"%@篇\n日记",d];
    self.essayLabel.text = [NSString stringWithFormat:@"%@篇\n随笔",e];
    self.wordLabel.text = [NSString stringWithFormat:@"%@个\n单词",w];
}

@end
