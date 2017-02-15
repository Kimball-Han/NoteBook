//
//  WordDetailViewController.m
//  Notebook
//
//  Created by 韩金波 on 16/7/18.
//  Copyright © 2016年 Psylife. All rights reserved.
//

#import "WordDetailViewController.h"
#import "PublicClass.h"
#import <Masonry.h>
#import "FMDBManager.h"
@interface WordDetailViewController ()
@property(nonatomic,strong)UITextView *textView;
@end

@implementation WordDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(rightButtonClick:)];
    self.navigationItem.rightBarButtonItem = rightButton;
   
    
    
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n\n",self.model.wordname]];
    [attributeString addAttribute:NSFontAttributeName value:[PublicClass fangsongAndSize:20] range:NSMakeRange(0, attributeString.length)];
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"释义：%@\n\n",self.model.paraphrase]];
    [content addAttribute:NSFontAttributeName value:[PublicClass fangsongAndSize:16] range:NSMakeRange(0, content.length)];
    
    NSMutableAttributedString *exmple = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"例句：%@",self.model.examplesentence]];
     [exmple addAttribute:NSFontAttributeName value:[PublicClass fangsongAndSize:16] range:NSMakeRange(0, exmple.length)];
    
    
    [attributeString appendAttributedString:content];
    [attributeString appendAttributedString:exmple];
    self.textView = [[UITextView alloc] init];
    self.textView.attributedText = attributeString;
    self.textView.editable = NO;
    [self.view addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(8, 8, 8, 8));
    }];
}
//-(void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    self.navigationController.navigationBarHidden = NO;
//}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.model.num = @(self.model.num.integerValue +1);
    [[FMDBManager manager] updateWordTablenum:self.model];
}
-(void)rightButtonClick:(UIBarButtonItem *)sender
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
