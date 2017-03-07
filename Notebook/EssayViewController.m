//
//  EssayViewController.m
//  Notebook
//
//  Created by 韩金波 on 16/4/6.
//  Copyright © 2016年 Psylife. All rights reserved.
//

#import "EssayViewController.h"
#import <UIScrollView+EmptyDataSet.h>
#import <MJRefresh.h>
#import "AppConfig.h"
#import "PublicClass.h"
#import "FMDBManager.h"
#import "WriteEssayViewController.h"
#import "Cells.h"
#import "EssayDetailViewController.h"
#import "SearchTableViewController.h"
//#import <IQKeyboardManager.h>
@interface EssayViewController ()<UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate,UISearchResultsUpdating,SearchTableViewControllerDeleagte>
@property (strong, nonatomic)  UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *essayArray;
@property (assign, nonatomic) NSInteger page;
@property (assign, nonatomic) BOOL isUpdate;

@property (strong,nonatomic)UISearchController *searchController;

@end

@implementation EssayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}
-(void)initUI
{
    self.automaticallyAdjustsScrollViewInsets = NO;
   

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,64, SCREEN_WIDTH, SCREEN_HEIGHT-64-49)];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.tableView registerClass:[EssayCell class] forCellReuseIdentifier:@"essayCell"];
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    __weak typeof (self) weakSelf = self;
    
    self.tableView.mj_header =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 0;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [weakSelf getEssay];
            
        });
        
    }];
    self.isUpdate =NO;
    [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.page ++;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [weakSelf getEssay];
            
        });
        
    }];
    //更新通知
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willUpdateEssay) name:@"updateEssay" object:nil];
    
    if (!self.tableView.emptyDataSetDelegate) {
        self.tableView.emptyDataSetDelegate = self;
        self.tableView.emptyDataSetSource = self;
    }
    SearchTableViewController *vc=[[SearchTableViewController alloc] init];
    
    vc.delegate = self;
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:vc];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation =YES;
    [self.searchController.searchBar sizeToFit];
    self.tableView.tableHeaderView =  self.searchController.searchBar;
    self.searchController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    
    
}
-(void)willUpdateEssay
{
    self.isUpdate=YES;
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updateEssay" object:nil];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.isUpdate) {
         [self.tableView.mj_header beginRefreshing];
    }
    self.tabBarController.navigationItem.title = @"随笔";
     self.tabBarController.navigationItem.rightBarButtonItem = nil;
   
}
-(void)getEssay
{
    NSMutableArray *array = [[FMDBManager manager] fetchOutTheTable:KBFMDBTableEssay AndPage:self.page];
    
    if (self.page ==0) {
        self.essayArray = array;
    }else{
        [self.essayArray addObjectsFromArray:array];
        
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        self.isUpdate = NO;
        [self.tableView reloadData];
    });

}

#pragma mark - UITableViewDataSource&UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.essayArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EssayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"essayCell"];
    cell.model = self.essayArray[indexPath.row];
    return cell;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
//-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return UITableViewAutomaticDimension;
//}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[FMDBManager manager] deleteModel:self.essayArray[indexPath.row]]) {
        
        // 从数据源中删除
        [self.essayArray removeObjectAtIndex:indexPath.row];
        // 从列表中删除
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        if (self.essayArray.count ==0) {
           [tableView reloadData];
        }
       
        
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    EssayDetailViewController *vc = [[EssayDetailViewController alloc] init];
    vc.model = self.essayArray[indexPath.row];
    [self.tabBarController.navigationController pushViewController:vc animated:YES];
}

#pragma mark - DZNEmptyDataSetSource&DZNEmptyDataSetDelegate>
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
    NSString *text = @"赶快去写随笔吧";
    
    NSDictionary *attributes = @{NSFontAttributeName: [PublicClass fangsongAndSize:20],
                                 NSForegroundColorAttributeName: [PublicClass mainColor]};
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
- (void)emptyDataSetDidTapButton:(UIScrollView *)scrollView{
    WriteEssayViewController *vc = [[WriteEssayViewController alloc] init];
    [self.tabBarController presentViewController:vc animated:YES completion:nil];
}


#pragma mark - search
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    
    NSMutableArray *array= [[FMDBManager manager] searchInfoFromTable:@"t_essay" forText:searchController.searchBar.text];
    [searchController.searchResultsController setValue:array forKey:@"array"];
    
}
-(void)SearchTableViewControllerClickCellForModel:(id)model
{
    EssayDetailViewController *vc = [[EssayDetailViewController alloc] init];
    vc.model = model;
    [self.tabBarController.navigationController pushViewController:vc animated:YES];
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
