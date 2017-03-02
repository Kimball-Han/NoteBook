//
//  SelectMenuViewController.m
//  Notebook
//
//  Created by 韩金波 on 16/4/7.
//  Copyright © 2016年 Psylife. All rights reserved.
//

#import "SelectMenuViewController.h"
#import "PublicClass.h"
#import "AppConfig.h"
#import <Chameleon.h>
@interface SelectMenuViewController ()

@property (weak, nonatomic)  UIView *writeDiaryView;
@property (weak, nonatomic)  UIView *writeEssayView;
@property (weak, nonatomic)  UIView *writeWordView;
@end

@implementation SelectMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(15,84, SCREEN_WIDTH, 40)];
    dateLabel.font = [PublicClass fangsongAndSize:20];
    [self.view addSubview:dateLabel];
    dateLabel.text = [PublicClass getTodayStr] ;

    UILabel *dateLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(15,124, SCREEN_WIDTH,40 )];
    dateLabel2.font = [PublicClass fangsongAndSize:20];
    [self.view addSubview:dateLabel2];
    
   ;
    dateLabel2.text = [PublicClass currentWeekDayStr] ;
    self.view.backgroundColor = FlatWhite;
    self.writeDiaryView =[self createButtonWithImageName:@"diaryss" andTitle:@"日记" andTag:10];
    self.writeEssayView =[self createButtonWithImageName:@"essayss" andTitle:@"随笔" andTag:11];;
  

    self.writeWordView =[self createButtonWithImageName:@"wordss" andTitle:@"单词" andTag:12];;
    
    CGFloat width = self.view.frame.size.width/3.0;
    for (int i=0; i<3; i++) {
        UIButton *button = [self.view viewWithTag:i+10];
        button.center = CGPointMake((i+0.5)*width, self.view.frame.size.height+60);
    }
    
   
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView animateWithDuration:0.7 animations:^{
        CGFloat width = self.view.frame.size.width/3.0;
        for (int i=0; i<3; i++) {
            UIButton *button = [self.view viewWithTag:i+10];
            button.center = CGPointMake((i+0.5)*width, self.view.frame.size.height*0.6+60);
        }
    } completion:^(BOOL finished) {
        UIImageView *close = [[UIImageView alloc] initWithImage:[PublicClass image:[UIImage imageNamed:@"close"] WithColor:FlatWatermelon]];
        close.frame = CGRectMake(0, 0, 50 ,50);
        close.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT-40);
        [self.view addSubview:close];
    }];
    
}
-(UIButton *)createButtonWithImageName:(NSString *)img  andTitle:(NSString *)title andTag:(NSInteger)tag{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 80, 120);
    button.tag = tag;
    [self.view addSubview:button];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *markImg = [[UIImageView alloc] initWithFrame:CGRectMake(5, 10, 70, 70)];
    markImg.image = [PublicClass image:[UIImage imageNamed:img]  WithColor:[UIColor whiteColor]];
    markImg.backgroundColor = FlatWatermelon;
    markImg.contentMode = UIViewContentModeCenter;
    markImg.layer.cornerRadius = 35.0f;
    [button addSubview:markImg];
    
    UILabel *label =[[UILabel alloc] initWithFrame:CGRectMake(0, 85, 80, 30)];
    [button addSubview:label];
    label.font = [PublicClass fangsongAndSize:18];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = title;
    
    
    
    return button;
}
-(UIImage*) OriginImage:(UIImage *)image scaleToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);  //size 为CGSize类型，即你所需要的图片尺寸
    
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;   //返回的就是已经改变的图片
}

-(void)buttonClick:(UIButton *)sender
{

  
        [self dismissViewControllerAnimated:NO completion:^(){
            if([self.delegate respondsToSelector:@selector(SelectMenuView:)]){
                [self.delegate SelectMenuView:sender.tag];
            }
        }];
        
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self dismissViewControllerAnimated:NO completion:nil];

}
//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    if ([segue.identifier isEqualToString:@"writeDiary"]) {
//        WriteViewController *vc=segue.destinationViewController;
//        vc.superVC = self;
//    }else if([segue.identifier isEqualToString:@"writeEssay"]){
//        
//    }else if ([segue.identifier isEqualToString:@"writeWord"]){
//        
//    }
//}
- (IBAction)cancelButtonClick:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    [self dismissViewControllerAnimated:YES completion:nil];
//}
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
