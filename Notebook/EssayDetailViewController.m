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
@property(nonatomic,strong)UITextView *textView;
@end

@implementation EssayDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}

//-(void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    self.navigationController.navigationBarHidden =NO;
//}


-(void)initUI{
    self.textView = [[UITextView alloc] init];
    [self.view addSubview:self.textView];
 
    
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n\n",self.model.title]];
    [attributeString addAttribute:NSFontAttributeName value:[PublicClass fangsongAndSize:20] range:NSMakeRange(0, attributeString.length)];
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"    %@",self.model.content]];
    [content addAttribute:NSFontAttributeName value:[PublicClass fangsongAndSize:16] range:NSMakeRange(0, content.length)];
    [attributeString appendAttributedString:content];
    
    self.textView.attributedText = attributeString;
    self.textView.editable = NO;
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(8, 8, 8, 8));
    }];
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(rightButtonClick:)];
    self.navigationItem.rightBarButtonItem =right;
    
//    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:73/255.0 green:187/255.0 blue:199/255.0 alpha:1.0];
   
    
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
