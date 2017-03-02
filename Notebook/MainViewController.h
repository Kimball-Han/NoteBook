//
//  MainViewController.h
//  Notebook
//
//  Created by 韩金波 on 16/4/6.
//  Copyright © 2016年 Psylife. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,OperationModel) {
    OperationModelPresentWriteDiary = 10,
    OperationModelPresentWriteEssay,
    OperationModelPresentWriteWorld
};
@interface MainViewController : UITabBarController


-(void)OperationModel:(OperationModel )model;

@end
