//
//  WriteEssayViewController.m
//  Notebook
//
//  Created by 韩金波 on 16/4/14.
//  Copyright © 2016年 Psylife. All rights reserved.
//

#import "WriteEssayViewController.h"
#import <Masonry.h>
#import "PublicClass.h"
#import "FMDBManager.h"
#import "PublicClass.h"
#import <SVProgressHUD.h>
#import "Models.h"
#import "Cells.h"
#import "AppConfig.h"
//#import <IQKeyboardManager.h>
@interface WriteEssayViewController ()<UITextViewDelegate>
@property(weak,nonatomic) UILabel *numberOfWordLabel;

@property(nonatomic,weak) UIScrollView *scrollview;
@property(nonatomic,weak) UITextView *itemTextView;
@property(nonatomic,weak) UITextView *contentTextView;

@property(weak,nonatomic) UILabel  *itemPlaceholder;
@property(weak,nonatomic) UILabel  *contentPlaceholder;

@end


@implementation WriteEssayViewController
{
    CGFloat lastHeight;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self initUI];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:nil];
}
-(void)initUI
{
//     [[IQKeyboardManager sharedManager] disableToolbarInViewControllerClass:[self class]];
    
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
    
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:scrollView];
   
    UIFont *itemFont =[PublicClass fangsongAndSize:22];
    UILabel *itemPlaceholder = [[UILabel alloc] init];
    itemPlaceholder.text = @"请输入标题！";
    itemPlaceholder.textColor = [UIColor lightGrayColor];
    [scrollView addSubview:itemPlaceholder];
    itemPlaceholder.font =itemFont;
    self.itemPlaceholder = itemPlaceholder;
    
    
    UITextView *itemTextView = [[UITextView alloc] init];
    [scrollView addSubview:itemTextView];
    self.scrollview = scrollView;
    self.itemTextView = itemTextView;
    self.itemTextView.backgroundColor = [UIColor clearColor];
    itemTextView.font =itemFont;
    self.itemTextView.showsHorizontalScrollIndicator =NO;
    self.itemTextView.delegate = self;
    self.itemTextView.scrollEnabled = NO;
    
    UILabel *line = [[UILabel alloc] init];
    line.backgroundColor = [UIColor lightGrayColor];
    [scrollView addSubview:line];
    
    UIFont *contentFont = [PublicClass fangsongAndSize:18];
    UILabel *contentPlaceholder = [[UILabel alloc] init];
    contentPlaceholder.text = @"请输入正文!";
    contentPlaceholder.textColor = [UIColor lightGrayColor];
    contentPlaceholder.font =contentFont;
    [scrollView addSubview:contentPlaceholder];
    self.contentPlaceholder = contentPlaceholder;
    
    UITextView *contentTextView = [[UITextView alloc] init];
    [scrollView addSubview:contentTextView];
    self.contentTextView =contentTextView;
    self.contentTextView.font = contentFont;
    self.contentTextView.backgroundColor = [UIColor clearColor];
    self.contentTextView.scrollEnabled = NO;
    self.contentTextView.showsHorizontalScrollIndicator =NO;
    self.contentTextView.delegate= self;
    
    [self.itemTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scrollView).offset(8);
        make.left.equalTo(scrollView.mas_left).with.offset(8);
        make.right.equalTo(self.view.mas_right).with.offset(-8);
        make.height.mas_equalTo(@40);
    }];
 
    [itemPlaceholder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scrollView).offset(8+8);
        make.left.equalTo(scrollView.mas_left).with.offset(8+5);
        make.width.mas_equalTo(@200);
        make.height.mas_equalTo(itemFont.lineHeight);
    }];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.itemTextView.mas_bottom).with.offset(4);
        make.left.equalTo(scrollView.mas_left).with.offset(8);
        make.right.equalTo(self.view.mas_right).with.offset(-8);
        make.height.mas_equalTo(@0.5);
    }];
    
    [self.contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).with.offset(4);
        make.left.equalTo(scrollView.mas_left).with.offset(8);
        make.right.equalTo(self.view.mas_right).with.offset(-8);
        CGFloat height=  [UIScreen mainScreen].bounds.size.height;
        make.height.mas_equalTo(@(height-56-64));
    }];
    [contentPlaceholder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).with.offset(4+8);
        make.left.equalTo(scrollView.mas_left).with.offset(8+5);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(@(contentFont.lineHeight));
    }];
   
    
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_bottom).with.offset(0);
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
        make.bottom.equalTo(self.contentTextView).with.offset(0);
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewTextDidChange:) name:UITextViewTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillChangeframe:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
}

-(void)keyBoardWillHide:(NSNotification *)notification
{
    [self.view setNeedsUpdateConstraints];
    
    [self.scrollview mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
    }];
     [self.view layoutIfNeeded];
}
-(void)keyBoardWillChangeframe:(NSNotification *)notification
{
    CGRect frame =[notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [self.view setNeedsUpdateConstraints];
    //调整scrollview的大小
    [self.scrollview mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).with.offset(- frame.size.height);
    }];
    
    
    CGSize itemSize=  [self.itemTextView sizeThatFits:CGSizeMake(CGRectGetWidth(self.itemTextView.frame), 10000.0f)];
    
     CGFloat itemHeight = itemSize.height > 40? itemSize.height : 40;
    //调整itemTextView
    [self.itemTextView mas_updateConstraints:^(MASConstraintMaker *make) {
          make.height.mas_equalTo(@(itemHeight));
    }];
    
    CGFloat height=  [UIScreen mainScreen].bounds.size.height;
    CGFloat ch=  height-frame.size.height- itemHeight-16-64 > 40 ? height-frame.size.height- itemHeight-16 -64: 40;
     lastHeight = ch;
    CGSize contentSize =  [self.contentTextView sizeThatFits:CGSizeMake(CGRectGetWidth(self.contentTextView.frame), 10000.0f)];
    ch = contentSize.height > ch ? contentSize.height:ch;
   
//   调整contentTextView
    [self.contentTextView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@(ch));
    }];
    [self.view layoutIfNeeded];
    if ([self.contentTextView isFirstResponder]) {
        //获取光标焦点位置
        CGPoint cursorPosition = [self.contentTextView caretRectForPosition:self.contentTextView.selectedTextRange.start].origin;
        cursorPosition.y += self.contentTextView.frame.origin.y;
        CGFloat lineH = self.contentTextView.font.lineHeight;
        
        if (cursorPosition.y + lineH *1.5 - self.scrollview.contentOffset.y > self.scrollview.frame.size.height) {
            //调整ScrollView的偏移
            [self.scrollview setContentOffset:CGPointMake(0, cursorPosition.y-self.scrollview.frame.size.height+lineH *1.5) animated:YES];
        }
        
    }
}
-(void)textViewTextDidChange:(NSNotification *)notification
{
    CGSize itemSize=  [self.itemTextView sizeThatFits:CGSizeMake(CGRectGetWidth(self.itemTextView.frame), 10000.0f)];
    CGSize contentSize =  [self.contentTextView sizeThatFits:CGSizeMake(CGRectGetWidth(self.contentTextView.frame), 10000.0f)];
    CGFloat itemHeight = itemSize.height > 40? itemSize.height : 40;
   
    
    [self.view setNeedsUpdateConstraints];
    
    [self.itemTextView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(itemHeight);
    }];
    
    CGFloat  ch = contentSize.height > lastHeight ? contentSize.height:lastHeight;
    
    [self.contentTextView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@(ch));
    }];
    
    [self.view layoutIfNeeded];
    if ([self.itemTextView isFirstResponder]) {
        self.itemPlaceholder.hidden = self.itemTextView.hasText;
        
    }
    
    if (([self.contentTextView isFirstResponder])) {
        self.contentPlaceholder.hidden = self.contentTextView.hasText;
        self.numberOfWordLabel.text=[NSString stringWithFormat:@"%ld字",(long)self.contentTextView.text.length];
        
        //光标位置调整
        CGPoint cursorPosition = [self.contentTextView caretRectForPosition:self.contentTextView.selectedTextRange.start].origin;
        cursorPosition.y += self.contentTextView.frame.origin.y;
        CGFloat lineH = self.contentTextView.font.lineHeight;
        if (cursorPosition.y + lineH *1.5 - self.scrollview.contentOffset.y > self.scrollview.frame.size.height) {
            [self.scrollview setContentOffset:CGPointMake(0, cursorPosition.y-self.scrollview.frame.size.height+lineH *1.5) animated:YES];
        }
    }
    
    
}
//-(CGSize)sizeWithString:(NSString *)string font:(UIFont *)font
//{
//    CGRect rect = [string boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 16, 8000)//限制最大的宽度和高度
//                                       options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  |NSStringDrawingUsesLineFragmentOrigin// 采用换行模式
//                                    attributes:@{NSFontAttributeName: font}//传人的字体字典
//                                       context:nil];
//    return rect.size;
//}
#pragma mark - click event
-(void)closeButtonclick:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)saveButtonClick:(UIButton *)sender
{
    if (self.itemTextView.text.length >0 && self.contentTextView.text.length >0) {
        [SVProgressHUD showWithStatus:@"正在保存..."];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            EssayModel *model = [[EssayModel alloc] init];
            model.datetime = [PublicClass getTodayStr];
            model.timestr  = [PublicClass getTimeStr];
            model.weekday  = [PublicClass currentWeekDayStr];
            model.title  = self.itemTextView.text;
            model.content = self.contentTextView.text;
            model.wordnumber = self.numberOfWordLabel.text;
//            NSString *content = [NSString stringWithFormat:@"\n\t\t%@\n%@\n",model.title,model.content];
//          BOOL ret1=  [PublicClass saveTheContent:content toPath:[PublicClass getEssayPath:model.timestr]];
//            if (ret1) {
                BOOL ret2= [[FMDBManager manager] insertModel:model];
                if (ret2) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self dismissViewControllerAnimated:YES completion:nil];
                        [SVProgressHUD dismiss];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateEssay" object:nil];
                    });
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [SVProgressHUD setMinimumDismissTimeInterval:0.5];
                        [SVProgressHUD showErrorWithStatus:@"保存出错"];
                        
                    });
                }
//            }else{
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [SVProgressHUD setMinimumDismissTimeInterval:0.5];
//                    [SVProgressHUD showErrorWithStatus:@"保存出错"];
//                    
//                });
//            }
           
            
        });
        
    }
}

@end
