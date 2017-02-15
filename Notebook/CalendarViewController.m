//
//  CalendarViewController.m
//  Notebook
//
//  Created by 韩金波 on 16/7/20.
//  Copyright © 2016年 Psylife. All rights reserved.
//

#import "CalendarViewController.h"
#import <JTCalendar/JTCalendar.h>
#import <Masonry.h>
#import "Cells.h"
#import "FMDBManager.h"
#import "DiaryDeatilViewController.h"
@interface CalendarViewController ()<JTCalendarDelegate,UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)JTCalendarMenuView *calendarMenuView;
@property(strong, nonatomic)  JTHorizontalCalendarView *calendarContentView;

@property (strong, nonatomic) JTCalendarManager *calendarManager;
@property(nonatomic,strong)UITableView *tableview;
@property(nonatomic,strong)NSMutableArray *searchArray;
@end

@implementation CalendarViewController
{
    NSDate *_todayDate;
    NSDate *_minDate;
    NSDate *_maxDate;
    
    NSDate *_dateSelected;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}
//-(void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    self.navigationController.navigationBarHidden =NO;
//    //    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
//}

-(void)initUI{
      self.title = @"日历";
    self.view.backgroundColor = [UIColor whiteColor];
    self.calendarManager =[[JTCalendarManager alloc] init];
    self.calendarManager.delegate = self;
    
    [self createMinAndMaxDate];
    
    
    self.calendarMenuView = [[JTCalendarMenuView alloc] init];
    [self.view addSubview:self.calendarMenuView];
    
    self.calendarContentView = [[JTHorizontalCalendarView alloc] init];
    [self.view addSubview:self.calendarContentView];
    
    self.tableview = [[UITableView alloc] init];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview registerClass:[DiaryCell class] forCellReuseIdentifier:@"diaryCell"];
    [self.view addSubview:self.tableview];
    
    
    [self.calendarMenuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(64);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(50);
        
    }];
    [self.calendarContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.calendarMenuView.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(300);
    }];
   
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.calendarContentView.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    
    
    [_calendarManager setMenuView:_calendarMenuView];
    [_calendarManager setContentView:_calendarContentView];
    [_calendarManager setDate:_todayDate];
    
    
}
#pragma mark - CalendarManager delegate

// Exemple of implementation of prepareDayView method
// Used to customize the appearance of dayView
- (void)calendar:(JTCalendarManager *)calendar prepareDayView:(JTCalendarDayView *)dayView
{
    // Today
    
    if([_calendarManager.dateHelper date:[NSDate date] isTheSameDayThan:dayView.date]){
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = [UIColor colorWithRed:73/255.0 green:187/255.0 blue:199/255.0 alpha:1.0];
        dayView.dotView.backgroundColor = [UIColor whiteColor];
        dayView.textLabel.textColor = [UIColor whiteColor];
    }
    // Selected date
    else if(_dateSelected && [_calendarManager.dateHelper date:_dateSelected isTheSameDayThan:dayView.date]){
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = [UIColor redColor];
        dayView.dotView.backgroundColor = [UIColor whiteColor];
        dayView.textLabel.textColor = [UIColor whiteColor];
    }
    // Other month
    else if(![_calendarManager.dateHelper date:_calendarContentView.date isTheSameMonthThan:dayView.date]){
        dayView.circleView.hidden = YES;
        dayView.dotView.backgroundColor = [UIColor redColor];
        dayView.textLabel.textColor = [UIColor lightGrayColor];
    }
    // Another day of the current month
    else{
        dayView.circleView.hidden = YES;
        dayView.dotView.backgroundColor = [UIColor redColor];
        dayView.textLabel.textColor = [UIColor blackColor];
    }
  
    if([self haveDiaryForDay:dayView.date].count){
        dayView.dotView.hidden = NO;
        
    }
    else{
        dayView.dotView.hidden = YES;
    }
}

-(NSMutableArray *)haveDiaryForDay:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy年MM月dd日";
  NSMutableArray *array=  [[FMDBManager manager] fetchOutDiaryfromT_diaryForDay:[formatter stringFromDate:date]];
    return array;
}

- (void)calendar:(JTCalendarManager *)calendar didTouchDayView:(JTCalendarDayView *)dayView
{
    _dateSelected = dayView.date;
      self.searchArray  =[self haveDiaryForDay:dayView.date];
    
    [self.tableview reloadData];
    // Animation for the circleView
    dayView.circleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
    [UIView transitionWithView:dayView
                      duration:.3
                       options:0
                    animations:^{
                        dayView.circleView.transform = CGAffineTransformIdentity;
                        [_calendarManager reload];
                    } completion:nil];
    
    
    // Don't change page in week mode because block the selection of days in first and last weeks of the month
    if(_calendarManager.settings.weekModeEnabled){
        return;
    }
    
    // Load the previous or next page if touch a day from another month
    
    if(![_calendarManager.dateHelper date:_calendarContentView.date isTheSameMonthThan:dayView.date]){
        if([_calendarContentView.date compare:dayView.date] == NSOrderedAscending){
            [_calendarContentView loadNextPageWithAnimation];
        }
        else{
            [_calendarContentView loadPreviousPageWithAnimation];
        }
    }
}
#pragma mark - CalendarManager delegate - Page mangement

// Used to limit the date for the calendar, optional//限制日历范围
- (BOOL)calendar:(JTCalendarManager *)calendar canDisplayPageWithDate:(NSDate *)date
{
    return [_calendarManager.dateHelper date:date isEqualOrAfter:_minDate andEqualOrBefore:_maxDate];
}

//自定义月份显示
- (void)calendar:(JTCalendarManager *)calendar prepareMenuItemView:(UILabel *)menuItemView date:(NSDate *)date
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"yyyy年MM月";
        
        dateFormatter.locale = _calendarManager.dateHelper.calendar.locale;
        dateFormatter.timeZone = _calendarManager.dateHelper.calendar.timeZone;
    }
    
    menuItemView.text = [dateFormatter stringFromDate:date];
}

- (void)calendarDidLoadNextPage:(JTCalendarManager *)calendar
{
    //    NSLog(@"Next page loaded");
}

- (void)calendarDidLoadPreviousPage:(JTCalendarManager *)calendar
{
    //    NSLog(@"Previous page loaded");
}

#pragma mark - Fake data

- (void)createMinAndMaxDate
{
    _todayDate = [NSDate date];
    
    self.searchArray  =[self haveDiaryForDay:_todayDate];
    NSDateFormatter *formatter = [self dateFormatter];
    _minDate = [formatter dateFromString:@"01-01-2016"];
//    _minDate = [_calendarManager.dateHelper addToDate:_todayDate months:-1000];
    
    //    // Max date will be 2 month after today
    _maxDate = [_calendarManager.dateHelper addToDate:_todayDate months:1];
    
}

// Used only to have a key for _eventsByDate
- (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"dd-MM-yyyy";
    }
    
    return dateFormatter;
}

//- (BOOL)haveEventForDay:(NSDate *)date
//{
//    NSString *key = [[self dateFormatter] stringFromDate:date];
//    
//    if(_eventsByDate[key] && [_eventsByDate[key] count] > 0){
//        return YES;
//    }
//    
//    return NO;
//    
//}
#pragma mark - UITableViewDelegate&&UITableDataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DiaryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"diaryCell"];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.model = self.searchArray[indexPath.row];
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.searchArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DiaryDeatilViewController *vc = [[DiaryDeatilViewController alloc] init];
    vc.model =self.searchArray[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
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
