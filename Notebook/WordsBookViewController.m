//
//  WordsBookViewController.m
//  Notebook
//
//  Created by 韩金波 on 16/4/6.
//  Copyright © 2016年 Psylife. All rights reserved.
//

#import "WordsBookViewController.h"
#import <UIScrollView+EmptyDataSet.h>
#import <MJRefresh.h>
#import "FMDBManager.h"
#import "PublicClass.h"
#import "AppConfig.h"
#import "WriteWordViewController.h"
#import "Models.h"
#import "Cells.h"
#import "WordDetailViewController.h"
#import "SearchTableViewController.h"
@interface WordsBookViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource,UISearchResultsUpdating,SearchTableViewControllerDeleagte>

@property(strong, nonatomic) UISearchController *searchController;
@property (strong, nonatomic)  UITableView *tableView;
@property(assign,nonatomic)NSInteger page;
@property(strong,nonatomic)NSMutableArray *wordArray;
@property(assign,nonatomic)BOOL isUpdate;

@end

@implementation WordsBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}
-(void)initUI
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.tableView registerClass:[WordCell class] forCellReuseIdentifier:@"wordCell"];
    
   
    self.page = 0;
    __weak typeof (self) weakSelf = self;
    
    self.tableView.mj_header =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        weakSelf.page = 0;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [weakSelf getWordTable];
            
        });
        
    }];
    self.isUpdate =NO;
    [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.page ++;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [weakSelf getWordTable];
            
        });
        
    }];
    //更新通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willUpdateDiary) name:@"updateWord" object:nil];
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
    
    self.automaticallyAdjustsScrollViewInsets = NO;

}

-(void)willUpdateDiary
{
    self.isUpdate=YES;
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updateWord" object:nil];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.isUpdate) {
        [self.tableView.mj_header beginRefreshing];
    }
    self.tabBarController.navigationItem.title = @"单词本";
      self.tabBarController.navigationItem.rightBarButtonItem = nil;
}
-(void)getWordTable
{
   NSMutableArray *array=  [[FMDBManager manager] fetchOutTheTable:KBFMDBTableWord AndPage:self.page];
    if (self.page ==0) {
        self.wordArray = array;
    }else{
        [self.wordArray addObjectsFromArray:array];
        
    }
    dispatch_async(dispatch_get_main_queue(), ^{
       
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
        self.isUpdate =NO;
    });

}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.wordArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WordCell *cell=[tableView dequeueReusableCellWithIdentifier:@"wordCell"];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
   cell.model = self.wordArray[indexPath.row];
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
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
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[FMDBManager manager] deleteModel:self.wordArray[indexPath.row]]) {
        
        // 从数据源中删除
        [self.wordArray removeObjectAtIndex:indexPath.row];
        // 从列表中删除
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        if (self.wordArray.count ==0) {
            [tableView reloadData];
        }
        
        
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    WordDetailViewController *VC = [[WordDetailViewController alloc] init];
    VC.model = self.wordArray[indexPath.row];
    [self.tabBarController.navigationController pushViewController:VC animated:YES];
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
    NSString *text = @"马上去添加几个单词吧";
    
    NSDictionary *attributes = @{NSFontAttributeName: [PublicClass fangsongAndSize:20],
                                 NSForegroundColorAttributeName: [PublicClass mainColor]};
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
- (void)emptyDataSetDidTapButton:(UIScrollView *)scrollView{
 
    [self.tabBarController performSegueWithIdentifier:@"writeWord" sender:self.tabBarController ];
}



#pragma mark - search
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSMutableArray *array= [[FMDBManager manager] searchInfoFromTable:@"t_word" forText:searchController.searchBar.text];
    [searchController.searchResultsController setValue:array forKey:@"array"];
    
}
-(void)SearchTableViewControllerClickCellForModel:(id)model
{
    WordDetailViewController *VC = [[WordDetailViewController alloc] init];
    VC.model = model;
    [self.tabBarController.navigationController pushViewController:VC animated:YES];
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
