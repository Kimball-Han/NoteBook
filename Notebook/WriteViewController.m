//
//  WriteViewController.m
//  Notebook
//
//  Created by 韩金波 on 16/4/7.
//  Copyright © 2016年 Psylife. All rights reserved.
//

#import "WriteViewController.h"
#import <Masonry.h>
#import "PublicClass.h"
#import "Models.h"
#import "FMDBManager.h"
#import <SVProgressHUD.h>
#import "AppDelegate.h"

@interface WriteViewController ()<UITextViewDelegate>
@property (weak, nonatomic)  UILabel *numberOfWordLabel;

@property (weak, nonatomic)  UILabel *dateDesLabel;
@property (weak, nonatomic)  UILabel *weekDesLabel;
@property (weak, nonatomic)  UILabel *weatherDesLabel;
@property (weak, nonatomic)  UILabel *placehoderLabel;
@property (weak, nonatomic)  UITextView *txtInputView;



@property (weak,nonatomic)   UIView *titleView;
@end

@implementation WriteViewController
{
    
    BOOL _wasKeyboardManagerEnabled;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    _wasKeyboardManagerEnabled = [[IQKeyboardManager sharedManager] isEnabled];
//    [[IQKeyboardManager sharedManager] setEnable:NO];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [[IQKeyboardManager sharedManager] setEnable:_wasKeyboardManagerEnabled];
    
}
-(void)initUI
{
    
    
    self.view.backgroundColor= [UIColor whiteColor];
    UIView *topView =[[UIView alloc] init];
    
    [self.view addSubview:topView];
    
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(0);
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
        make.height.mas_equalTo(64);
    }];
    
    
    UIButton *closeButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton addTarget:self action:@selector(closeButtonclick:) forControlEvents:UIControlEventTouchUpInside];
    [closeButton setTitle:@"关闭" forState:UIControlStateNormal];
    [closeButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    closeButton.titleLabel.font = [PublicClass fangsongAndSize:20];
    
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveButton addTarget:self action:@selector(saveButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [saveButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
     saveButton.titleLabel.font = [PublicClass fangsongAndSize:20];
    
    UILabel *lengthLabel = [[UILabel alloc] init];
    lengthLabel.textAlignment = NSTextAlignmentCenter;
    lengthLabel.font = [PublicClass fangsongAndSize:16];
    
    [topView addSubview:lengthLabel];
    [topView addSubview:closeButton];
    [topView addSubview:saveButton];
    
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_top).with.offset(20);
        make.left.equalTo(topView.mas_left).with.offset(10);
        make.width.mas_equalTo(44);
        make.height.mas_equalTo(44);
    }];
    
    [saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_top).with.offset(20);
        make.right.equalTo(topView.mas_right).with.offset(-10);
        make.width.mas_equalTo(44);
        make.height.mas_equalTo(44);
    }];
    [lengthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_top).with.offset(20);
        make.centerX.equalTo(topView);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(44);
    }];
    self.numberOfWordLabel = lengthLabel;
    lengthLabel.text = @"0字";
    lengthLabel.textColor = [UIColor lightGrayColor];
    
    UIView *titleView=[[UIView alloc] init];
    [self.view addSubview:titleView];
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_bottom).with.offset(0);
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
        make.height.mas_equalTo(40);
    }];
    self.titleView = titleView;
    UILabel *dateLabel = [[UILabel alloc] init];
    UILabel *weekLabel = [[UILabel alloc] init];
    UILabel *weatherLabel = [[UILabel alloc] init];
    UILabel *line = [[UILabel alloc] init];
    line.backgroundColor= [UIColor lightGrayColor];
    [titleView addSubview:dateLabel];
    [titleView addSubview:weekLabel];
    [titleView addSubview:weatherLabel];
    [titleView addSubview:line];
    weekLabel.textAlignment = NSTextAlignmentRight;
    weatherLabel.textAlignment = NSTextAlignmentRight;
    self.dateDesLabel = dateLabel;
    self.weekDesLabel = weekLabel;
    self.weatherDesLabel = weatherLabel;
     UIFont *font = [PublicClass fangsongAndSize:18];
    dateLabel.font = font;
    weatherLabel.font = font;
    weekLabel.font = font;
   
   
  
    
    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleView.mas_top).with.offset(0);
        make.left.equalTo(titleView.mas_left).with.offset(8);
        make.bottom.equalTo(titleView.mas_bottom).with.offset(-8);
        make.width.mas_equalTo(@140);
    }];
  
    [weatherLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleView.mas_top).with.offset(0);
        make.right.equalTo(titleView.mas_right).with.offset(-8);
        make.bottom.equalTo(titleView.mas_bottom).with.offset(-8);
        make.width.mas_equalTo(@100);
    }];
    [weekLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleView.mas_top).with.offset(0);
        make.right.equalTo(weatherLabel.mas_left).with.offset(-8);
        make.bottom.equalTo(titleView.mas_bottom).with.offset(-8);
        make.width.mas_equalTo(@60);
    }];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleView.mas_left).with.offset(8);
        make.right.equalTo(titleView.mas_right).with.offset(-8);
        make.bottom.equalTo(titleView.mas_bottom).with.offset(0);
        make.height.mas_equalTo(@1);
    }];
    
    
   
    UILabel *placeholder = [[UILabel alloc] init];
    [self.view addSubview:placeholder];
//  CGRectMake(13, 120, 100, font.lineHeight)
    [placeholder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleView.mas_bottom).with.offset(16);
        make.left.equalTo(self.view.mas_left).with.offset(13);
        make.width.mas_equalTo(@100);
        make.height.mas_equalTo(@(font.lineHeight));
    }];
    placeholder.textColor = [UIColor lightGrayColor];
    placeholder.text = @"说点什么吧";
    placeholder.font = font;
    self.placehoderLabel = placeholder;
//    CGSize size= [UIScreen mainScreen].bounds.size;
    UITextView *inputView = [[UITextView alloc] init];
    [self.view addSubview:inputView];

//    Frame:CGRectMake(8, 104+8,size.width-16 , size.height-104-8-8)
    [inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleView.mas_bottom).with.offset(8);
        make.left.equalTo(self.view.mas_left).with.offset(8);
        make.right.equalTo(self.view.mas_right).with.offset(-8);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-8);
    }];
    inputView.backgroundColor = [UIColor clearColor];
    inputView.font = font;
    inputView.delegate= self;
    inputView.returnKeyType = UIReturnKeyDone;
    self.txtInputView = inputView;
    
    AppDelegate *app=[UIApplication sharedApplication].delegate;
    weatherLabel.text = [NSString stringWithFormat:@"天气：%@",app.weatherInfo];
    [app addObserver:self forKeyPath:@"weatherInfo" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    self.dateDesLabel.text = [PublicClass getTodayStr];
    self.weekDesLabel.text = [PublicClass currentWeekDayStr];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextViewTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if([keyPath isEqualToString:@"weatherInfo"])
    {
        AppDelegate *app=[UIApplication sharedApplication].delegate;
        self.weatherDesLabel.text = app.weatherInfo;
    }
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
     [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
     [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    AppDelegate *app=[UIApplication sharedApplication].delegate;
    [app removeObserver:self forKeyPath:@"weatherInfo" context:nil];
}
- (void)keyboardWillHide:(NSNotification *)notification{
//    CGSize size= [UIScreen mainScreen].bounds.size;
    [self.view setNeedsUpdateConstraints];
    [self.txtInputView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.titleView.mas_bottom).with.offset(8);
//            make.left.equalTo(self.view.mas_left).with.offset(8);
//            make.right.equalTo(self.view.mas_right).with.offset(-8);
            make.bottom.equalTo(self.view.mas_bottom).with.offset(-8);
    
    }];
   
    [UIView animateWithDuration:[notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] integerValue] animations:^{
      
        [self.view layoutIfNeeded];

    }];
}

- (void)keyboardFrameWillChange:(NSNotification *)notification{
    
    CGRect frame =[notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [self.view setNeedsUpdateConstraints];
    [self.txtInputView mas_updateConstraints:^(MASConstraintMaker *make) {
   
//        make.top.equalTo(self.titleView.mas_bottom).with.offset(8);
//        make.left.equalTo(self.view.mas_left).with.offset(8);
//        make.right.equalTo(self.view.mas_right).with.offset(-8);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-8-frame.size.height);
    }];
    
    [UIView animateWithDuration:[notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        

        [self.view layoutIfNeeded];
       
        
    }];
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        [self.txtInputView resignFirstResponder];
        //在这里做你响应return键的代码
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)textDidChange:(NSNotification *)note{
    // 是否隐藏
    self.placehoderLabel.hidden = self.txtInputView.hasText;
   NSInteger num= self.txtInputView.text.length;
    self.numberOfWordLabel.text=[NSString stringWithFormat:@"%ld字",(long)num];
}

- (void)closeButtonclick:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)saveButtonClick:(UIButton *)sender {
    if (self.txtInputView.text.length >0) {
        [SVProgressHUD showWithStatus:@"正在保存..."];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            DiaryModel *model = [[DiaryModel alloc] init];
            model.datetime = self.dateDesLabel.text;
            model.weekday = self.weekDesLabel.text;
            model.weather = self.weatherDesLabel.text;
            model.timestr = [PublicClass getTimeStr];
            model.content = self.txtInputView.text;
            model.wordnumber = self.numberOfWordLabel.text;
            AppDelegate *app = [UIApplication sharedApplication].delegate;
            model.location = app.locationInfo;
           BOOL ret= [[FMDBManager manager] insertModel:model];
            
            
            if (ret) {
//                NSString *content=[NSString stringWithFormat:@"%@\t\t\t%@\t%@\n%@",model.datetime,model.weekday,model.weather,model.content];
//                BOOL ret2 = [PublicClass saveTheContent:content toPath:[PublicClass getDiaryPath:model.timestr]];
//                if (ret2) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self dismissViewControllerAnimated:YES completion:nil];
                        [SVProgressHUD dismiss];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateDiary" object:nil];
                    });
//                }else{
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [SVProgressHUD setMinimumDismissTimeInterval:0.5];
//                        [SVProgressHUD showErrorWithStatus:@"保存出错"];
//                        
//                    });
//                }
               
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SVProgressHUD setMinimumDismissTimeInterval:0.5];
                    [SVProgressHUD showErrorWithStatus:@"保存出错"];
                   
                });
            }
            
            
        });
       
        
    }
   
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
