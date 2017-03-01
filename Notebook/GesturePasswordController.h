//
//  GesturePasswordController.h
//  Notebook
//
//  Created by 韩金波 on 2016/12/29.
//  Copyright © 2016年 Psylife. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,GesturePasswordModel) {
    GesturePasswordModelSetting =10,//设置
    GesturePasswordModelVerify,//验证
    GesturePasswordModelReset//重置
};
@class GesturePasswordController;
@protocol GesturePasswordControllerDelegate <NSObject>

-(void)gesturePasswordController:(GesturePasswordController *)vc OperationSuccessWithModel:(GesturePasswordModel )model;

@end

@interface GesturePasswordController : UIViewController
@property(nonatomic,assign)GesturePasswordModel model;
@property(copy,nonatomic)NSString *oldPassword;

@end
