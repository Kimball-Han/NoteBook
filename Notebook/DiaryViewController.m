//
//  DiaryViewController.m
//  Notebook
//
//  Created by 韩金波 on 16/4/6.
//  Copyright © 2016年 Psylife. All rights reserved.
//

#import "DiaryViewController.h"
#import <UIScrollView+EmptyDataSet.h>
#import <MJRefresh.h>
#import "WriteViewController.h"
#import "AppConfig.h"
#import "PublicClass.h"
#import "FMDBManager.h"
#import "Cells.h"
#import "DiaryDeatilViewController.h"
#import "CalendarViewController.h"
#import "MainViewController.h"
@interface DiaryViewController ()<DZNEmptyDataSetDelegate,DZNEmptyDataSetSource,UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic)  UITableView *tableView;
@property(nonatomic,assign)NSInteger page;
@property(nonatomic,strong)NSMutableArray *diaryArray;
@property(nonatomic,assign)BOOL isUpdate;

@end

@implementation DiaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
  
   
}
-(void)initUI
{
//    self.edgesForExtendedLayout = UIRectEdgeNone;
   

    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64-49)];
    [self.view addSubview:self.tableView];
   self.tableView.tableFooterView = [[UIView alloc] init];
  [self.tableView registerClass:[DiaryCell class] forCellReuseIdentifier:@"diaryCell"];
    __weak typeof (self) weakSelf = self;
    
    self.tableView.mj_header =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        weakSelf.page = 0;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [weakSelf getDiary];
        });
        
    }];
  self.isUpdate =NO;
  [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.page ++;
    
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [weakSelf getDiary];

        });
        
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willUpdateDiary) name:@"updateDiary" object:nil];
    
    self.tableView.delegate = self;
    self.tableView.dataSource= self;
    if (!self.tableView.emptyDataSetDelegate) {
        self.tableView.emptyDataSetDelegate = self;
        self.tableView.emptyDataSetSource = self;
    }
    
}
-(void)willUpdateDiary
{
    self.isUpdate=YES;
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updateDiary" object:nil];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.isUpdate) {
        [self.tableView.mj_header beginRefreshing];
    }
    self.tabBarController.navigationItem.title = @"日记";
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"日历" style:UIBarButtonItemStylePlain target:self action:@selector(calendarButtonClick:)];
    self.tabBarController.navigationItem.rightBarButtonItem = rightButton;
}

-(void)getDiary
{
    NSMutableArray *array = [[FMDBManager manager] fetchOutTheTable:KBFMDBTableDiary AndPage:self.page];
    
    if (self.page ==0) {
        self.diaryArray = array;
    }else{
        [self.diaryArray addObjectsFromArray:array];
        
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
        self.isUpdate =NO;
    });
}

#pragma mark  - UITableViewDelegate&UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.diaryArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DiaryCell *cell=[tableView dequeueReusableCellWithIdentifier:@"diaryCell"];
    cell.model = self.diaryArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    DiaryDeatilViewController *vc = [[DiaryDeatilViewController alloc] init];
    vc.model =self.diaryArray[indexPath.row];
    [self.tabBarController.navigationController pushViewController:vc animated:YES];
    
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[FMDBManager manager] deleteModel:self.diaryArray[indexPath.row]]) {
        
        // 从数据源中删除
        [self.diaryArray removeObjectAtIndex:indexPath.row];
        // 从列表中删除
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        if (self.diaryArray.count ==0) {
            [tableView reloadData];
        }
        
  
    }
}
#pragma mark - DZNEmptyDataSetDelegate,DZNEmptyDataSetSource
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"head"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"主人，这儿什么没有，/(ㄒoㄒ)/~~";
    
    NSDictionary *attributes = @{NSFontAttributeName: [PublicClass fangsongAndSize:16],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
-(NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
    NSString *text = @"赶快去写篇日记";
    
    NSDictionary *attributes = @{NSFontAttributeName: [PublicClass fangsongAndSize:20],
                                 NSForegroundColorAttributeName: [PublicClass mainColor]};
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
- (void)emptyDataSetDidTapButton:(UIScrollView *)scrollView{
    
    [(MainViewController *)self.tabBarController OperationModel:OperationModelPresentWriteDiary];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)calendarButtonClick:(UIButton *)sender {
    CalendarViewController *vc =[[CalendarViewController alloc] init];
    [self.tabBarController.navigationController pushViewController:vc animated:YES];
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
