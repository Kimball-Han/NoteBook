//
//  SettingViewController.m
//  Notebook
//
//  Created by 韩金波 on 16/4/6.
//  Copyright © 2016年 Psylife. All rights reserved.
//

#import "SettingViewController.h"
#import "AppConfig.h"
#import "AESCrypt.h"
#import <SVProgressHUD.h>
@interface SettingViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *sspassword;
@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}
-(void)initUI
{
    self.titleLabel.text=@"欢迎使用\n\n请填写资料";
    self.titleLabel.numberOfLines = 0;
    self.username.delegate = self;
    self.password.delegate = self;
    self.sspassword.delegate = self;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.sspassword) {
         [self verificationAndGenerateUserInformation];
    }
    [textField resignFirstResponder];
    return YES;
    
}

- (IBAction)enterButtonClick:(UIButton *)sender {
    
    [self verificationAndGenerateUserInformation];
    
}

-(void)verificationAndGenerateUserInformation
{
    if (!(self.username.text.length > 0)) {
        [self alertViewTitle:@"昵称不能为空！" andMessage:nil cancelButtonTitle:@"确定"];
        return;
    }else if (!(self.password.text.length >=6 && self.password.text.length <=16)){
         [self alertViewTitle:@"请输入6~16位密码！" andMessage:nil cancelButtonTitle:@"确定"];
        return;
    }else if (![self.password.text isEqualToString:self.sspassword.text]){
          [self alertViewTitle:@"两次填写的密码不一致！" andMessage:nil cancelButtonTitle:@"确定"];
        return;
    }
    [SVProgressHUD showWithStatus:@"正在初始化..."];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSUserDefaults *userDe = [NSUserDefaults standardUserDefaults];
        NSString *username = [AESCrypt encrypt:self.username.text password:AES_PASSWORD];
        NSString *password = [AESCrypt encrypt:self.password.text password:AES_PASSWORD];
        [userDe setObject:username forKey:@"username"];
        [userDe setObject:password forKey:@"password"];
        [userDe synchronize];
        UIImage *originImage = [self buttonImageFromColor:[UIColor colorWithRed:247/255.0 green:154/255.0 blue:181/255.0 alpha:1.0]];
        UIImage *headImage = [self watermarkImage:originImage withName:self.username.text];
        NSString *headPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Library"] stringByAppendingPathComponent:@"head.png"];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSData *data=UIImagePNGRepresentation(headImage);
        if ([fileManager createFileAtPath:headPath contents:data attributes:nil]) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                 [self verificationSuccess];
                 [SVProgressHUD dismiss];
            });
        } ;
        
    });
   
   
}

#pragma mark  - 系统提示
-(void)alertViewTitle:(NSString *)title andMessage:(NSString *)message cancelButtonTitle:(NSString *)cancelButton
{
    if (IOS8) {
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:title  message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * action = [UIAlertAction actionWithTitle:cancelButton style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:cancelButton otherButtonTitles: nil];
        [alert show];
    }
    
}
-(void)verificationSuccess
{
    [self.navigationController performSegueWithIdentifier:@"testSuccess" sender:self.navigationController];

}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(UIImage *)watermarkImage:(UIImage *)img withName:(NSString *)name
{
    NSString* mark = name;
    int w = img.size.width;
    int h= img.size.height;
    UIGraphicsBeginImageContext(img.size);
    [img drawInRect:CGRectMake(0, 0, w, h)];
    
    NSDictionary *attr = @{
                           NSFontAttributeName: [UIFont boldSystemFontOfSize:40],
                           NSForegroundColorAttributeName : [UIColor whiteColor],
                           
                           };
    CGSize size = [self sizeWithString:name font:[UIFont boldSystemFontOfSize:40]];
    [mark drawInRect:CGRectMake((200-size.width)/2.0, (200-size.height)/2,size.width,size.height) withAttributes:attr];
    
    UIImage *aimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return aimg;
}

- (UIImage *)buttonImageFromColor:(UIColor *)color{
    
    CGRect rect = CGRectMake(0, 0, 200, 200);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext(); return img;
}
-(CGSize)sizeWithString:(NSString *)string font:(UIFont *)font
{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(200, 8000)//限制最大的宽度和高度
                                       options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  |NSStringDrawingUsesLineFragmentOrigin// 采用换行模式
                                    attributes:@{NSFontAttributeName: font}//传人的字体字典
                                       context:nil];
    return rect.size;
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
