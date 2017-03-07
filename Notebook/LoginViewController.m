//
//  LoginViewController.m
//  Notebook
//
//  Created by 韩金波 on 16/4/6.
//  Copyright © 2016年 Psylife. All rights reserved.
//

#import "LoginViewController.h"
#import "AESCrypt.h"
#import "AppConfig.h"
#import "SettingViewController.h"
#import <SVProgressHUD.h>
#import "PublicClass.h"
@interface LoginViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@property (weak, nonatomic) IBOutlet UILabel *desTwoLabel;
@property (weak, nonatomic) IBOutlet UITextField *password;

@property (copy, nonatomic)  NSString *spassword;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initApp];
}
-(void)initApp
{
    
 
    NSUserDefaults *userDe = [NSUserDefaults standardUserDefaults];
    NSString * username =[userDe objectForKey:@"username"];
    self.spassword=[userDe objectForKey:@"password"];
    self.password.delegate = self;
    
    if (username.length>0 && self.spassword.length >0) {
        
        username = [AESCrypt decrypt:username password:AES_PASSWORD];
        self.spassword = [AESCrypt decrypt:self.spassword password:AES_PASSWORD];
        
           self.desLabel.text = [NSString stringWithFormat:@"%@,%@",[PublicClass getTodayStr],[PublicClass currentWeekDayStr]];
        
        NSString *headPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Library"] stringByAppendingPathComponent:@"head.png"];
        NSFileManager *fileManger = [NSFileManager defaultManager];
        if ([fileManger fileExistsAtPath:headPath]) {
            self.headImage.image = [UIImage imageWithContentsOfFile:headPath];
        }else{
            self.headImage.image = [UIImage imageNamed:@"head"];
        }
        
        
        
        self.headImage.layer.cornerRadius = self.headImage.frame.size.width/2;
        self.headImage.clipsToBounds = YES;
        self.headImage.layer.masksToBounds = YES;
    }else{
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        SettingViewController *vc=[storyboard instantiateViewControllerWithIdentifier:@"setting"];
        [self.navigationController pushViewController:vc animated:NO];
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if([self.password.text isEqualToString:self.spassword]){
        [self.navigationController performSegueWithIdentifier:@"testSuccess" sender:self.navigationController];
    }else{
        [SVProgressHUD setMinimumDismissTimeInterval:0.5];
        [SVProgressHUD showErrorWithStatus:@"密码错误"];
        
    }
    return YES;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)testSuccess:(UIButton *)sender {
    
    if([self.password.text isEqualToString:self.spassword]){
    [self.navigationController performSegueWithIdentifier:@"testSuccess" sender:self.navigationController];
    }else{
         [SVProgressHUD setMinimumDismissTimeInterval:1.0];
        [SVProgressHUD showErrorWithStatus:@"密码错误"];
       
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
