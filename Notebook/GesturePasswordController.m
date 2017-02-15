//
//  GesturePasswordController.m
//  Notebook
//
//  Created by 韩金波 on 2016/12/29.
//  Copyright © 2016年 Psylife. All rights reserved.
//

#import "GesturePasswordController.h"
#import <Chameleon.h>
@interface GesturePasswordController ()
@property(strong,nonatomic)NSMutableArray *buttonArray;
@property(strong,nonatomic)NSMutableArray *selectorArray;
@property(assign,nonatomic)CGPoint endPoint;
@property(strong,nonatomic)UIImageView *imageView;
@property(weak,nonatomic)UILabel *alertLabel;
@end

@implementation GesturePasswordController
{
    CGFloat screenWidth;
    CGFloat screenHeight;
    CGFloat width ;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.model = GesturePasswordModelSetting;
    [self configUI];
}

-(NSMutableArray *)selectorArray
{
    if (!_selectorArray) {
        _selectorArray = [NSMutableArray array];
    }
    return _selectorArray;
}

-(void)configUI{
    CGSize size = [UIScreen mainScreen].bounds.size;
    screenWidth = size.width;
    screenHeight = size.height;
    width = 80 *screenWidth/375;
    
    
    NSArray *color = @[FlatSkyBlue,FlatMint];
    self.view.backgroundColor = GradientColor(UIGradientStyleTopToBottom, self.view.frame, color);
    
    if (!_buttonArray) {
        _buttonArray = [[NSMutableArray alloc] initWithCapacity:9];
    }
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    
    UILabel * alertLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight*0.2)];
    [self.view addSubview:alertLabel];
    self.alertLabel = alertLabel;
    
    
    
    CGFloat space =(screenWidth-3*width)/4;
    [self.view addSubview:self.imageView];
    for (int i=0; i<3; i++) {
        for (int j=0; j<3; j++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(0, 0, width, width);
            button.center = CGPointMake((space+width)*(j+1)-width/2, screenHeight*0.2+(space+width)*(i+1)-width/2);
            button.userInteractionEnabled = NO;
            [button setImage:[UIImage imageNamed:@"gesture_nor"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"gesture_sel"] forState:UIControlStateHighlighted];
            button.tag = i*3+j+10;
            [self.buttonArray addObject:button];
            [self.imageView addSubview:button];
        }
    }
}

#pragma mark - 开始移动
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    if (touch) {
        for (UIButton *btn in self.buttonArray) {
            CGPoint po = [touch locationInView:btn];
            
            if ([btn pointInside:po withEvent:nil]) {
                [self.selectorArray addObject:btn];
                btn.highlighted = YES;

            }
        }
    }
}

#pragma mark - 手势移动中
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    if (touch) {
        self.endPoint = [touch locationInView:self.imageView];
        
        for (UIButton *btn in self.buttonArray) {
            CGPoint po = [touch locationInView:btn];
            if ([btn pointInside:po withEvent:nil]) {
                if (![self.selectorArray containsObject:btn]) {
                    [self.selectorArray addObject:btn];
                }
            }
            
        }
        
    }
    if (self.selectorArray.count>0) {
        [self drawLineWithLineColor:FlatGreen];//每次移动过程中都要调用这个方法，把画出的图输出显示
    }
    
    
}

#pragma mark - 手势结束
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    
    NSString *password = [self getSelectorArrayPassword];
    if (password) {
        if (self.model == GesturePasswordModelSetting) {
            if (self.oldPassword) {
                if ([self.oldPassword isEqualToString:password]) {
                    NSLog(@"验证通过");
                }else{
                    self.oldPassword = nil;
                    self.alertLabel.text = @"错误，重新输入！";
                }
                
            }else{
                self.oldPassword = password;
                self.alertLabel.text = @"请再次录入！";

            }
            
        }else if(self.model == GesturePasswordModelVerify){
            
            
            
        }else if (self.model == GesturePasswordModelReset){
            
            
            
        }
    }
    [self removeLine];
    
}

-(NSString *)getSelectorArrayPassword
{
    NSString *string =@"";
    for (UIButton *button in self.selectorArray) {
      string=  [string stringByAppendingString:@(button.tag).stringValue];
    }
    [self.selectorArray removeAllObjects];

    return string;
}

#pragma mark - 画图
-(void )drawLineWithLineColor:(UIColor *)lineColor;
{
    UIImage *image = nil;
    
    UIGraphicsBeginImageContext(self.imageView.frame.size);//设置画图的大小
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 10);
    CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
    
    
    for (int i=0 ;i<self.selectorArray.count;i++) {
        UIButton *btn =self.selectorArray[i];
        CGPoint btnPo = btn.center;
        btn.highlighted = YES;
        
        if (i ==0) {
            CGContextMoveToPoint(context, btnPo.x, btnPo.y);//设置划线的起点
        }else{
            
            CGContextAddLineToPoint(context, btnPo.x, btnPo.y);
            CGContextMoveToPoint(context, btnPo.x, btnPo.y);
            
        }
    }
    CGContextAddLineToPoint(context, self.endPoint.x, self.endPoint.y);
    
    
    CGContextStrokePath(context);
    
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    self.imageView.image = image;
    
}

-(void)removeLine{
    
    self.imageView.image = nil;
    for (UIButton *button in self.buttonArray) {
        button.highlighted = NO;
    }
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
