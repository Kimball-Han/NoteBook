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
#import <Chameleon.h>
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
    [(HeaderView *)self.tableView.tableHeaderView startAnimation];
    [(HeaderView *)self.tableView.tableHeaderView getcount];
    self.navigationController.navigationBarHidden = YES;

//    self.tabBarController.navigationItem.title = @"随笔";
//    self.tabBarController.navigationItem.rightBarButtonItem = nil;
//   
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    [(HeaderView *)self.tableView.tableHeaderView  stopAnimation];
}
-(void)initUI
{

  
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];

    self.tableView.bounces = NO;
    [self.view addSubview:self.tableView];
    
    self.tableView.tableFooterView= [[UIView alloc] init];
    
    HeaderView * headerView = [[HeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.width*0.618+20)];
    self.tableView.tableHeaderView = headerView;
    

    _arrayItem = @[@"修改密码",@"欢迎评分",@"联系我们",@"导出"];
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
    }
    return cell;
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
{
     CGFloat  element ;
    __weak KBWave *_wave;
}
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




-(UILabel *)diaryLabel
{
    if (!_diaryLabel) {
       
        _diaryLabel =  [self elementLabel];
    }
    return _diaryLabel;
}

-(UILabel *)essayLabel
{
   
    if (!_essayLabel) {
     
        _essayLabel = [self elementLabel];
    }
    return _essayLabel;
}

-(UILabel *)wordLabel
{
    if (!_wordLabel) {
      
        _wordLabel = [self elementLabel];
    }
    return _wordLabel;
}
-(UILabel *)elementLabel{
    UILabel *label = [[UILabel alloc ] initWithFrame:CGRectMake(0, 0, element, element)];
    label.layer.cornerRadius = element/2;
    label.layer.masksToBounds = YES;
    label.numberOfLines =0;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:19];
    [self addSubview:label];
    return label;
}
-(void)initUI{
    element = 70;//元素
    
    CGFloat upHeight = self.frame.size.height-10;
    
    KBWave *upview = [[KBWave alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, upHeight)];
    NSArray *color = @[FlatSkyBlue,FlatMint];
    upview.backgroundColor = GradientColor(UIGradientStyleTopToBottom, upview.frame, color);
    [self addSubview:upview];
    
    CGFloat w =self.frame.size.width/3.0;
    CGFloat waveheight = upview.waveHeight;
    __weak typeof(self)weakSelf = self;
    upview.waveBlock =^(CGFloat y1,CGFloat y2,CGFloat y3){
        weakSelf.diaryLabel.center = CGPointMake(w * 0.5,upHeight -waveheight-40+y1);
        weakSelf.essayLabel.center = CGPointMake(w * 1.5, upHeight -waveheight-40+y2);
        weakSelf.wordLabel.center = CGPointMake(w * 2.5, upHeight -waveheight-40+y3);

    };
    _wave = upview;

  
    for (int i = 0; i<50; i++) {
        CALayer *layer =[CAShapeLayer layer];
        layer.backgroundColor = [UIColor whiteColor].CGColor;
        layer.frame = CGRectMake(arc4random() % (int)(self.frame.size.width-2), arc4random()%90+2, 2, 2);
        layer.opacity =arc4random() % 10/10.0;
        [self.layer addSublayer:layer];

    }
    UIImageView *moon = [[UIImageView alloc] initWithImage:[PublicClass image:[UIImage imageNamed:@"moon_star"] WithColor:[UIColor flatWhiteColor]]];
    moon.frame = CGRectMake(w-30, 30, 15, 15);
    [self addSubview:moon];
}

-(NSAttributedString *)getAttributedStringWithString:(NSString *)string lineSpace:(CGFloat)lineSpace {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpace; // 调整行间距
    NSRange range = NSMakeRange(0, [string length]);
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:range];
    return attributedString;
}

-(void)getcount
{
    NSNumber *d=  [[FMDBManager manager] statisticsTotalNumForTable:@"t_diary"];
    NSNumber *e=   [[FMDBManager manager] statisticsTotalNumForTable:@"t_essay"];
    NSNumber *w=   [[FMDBManager manager] statisticsTotalNumForTable:@"t_word"];
    self.diaryLabel.attributedText = [self getAttributedStringWithString:[NSString stringWithFormat:@"%@\n日记",d] lineSpace:5.0];
    self.essayLabel.attributedText = [self getAttributedStringWithString:[NSString stringWithFormat:@"%@\n随笔",e] lineSpace:5.0];
    self.wordLabel.attributedText = [self getAttributedStringWithString:[NSString stringWithFormat:@"%@\n单词",w] lineSpace:5.0];
    self.diaryLabel.textAlignment = NSTextAlignmentCenter;
    self.essayLabel.textAlignment = NSTextAlignmentCenter;
    self.wordLabel.textAlignment = NSTextAlignmentCenter;



}

-(void)startAnimation
{
     [_wave startWaveAnimation];
}

-(void)stopAnimation
{
    [_wave stopWaveAnimation];
}

@end
