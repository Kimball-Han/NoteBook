//
//  SelectMenuViewController.h
//  Notebook
//
//  Created by 韩金波 on 16/4/7.
//  Copyright © 2016年 Psylife. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger,SelectMenuViewType) {
    SelectMenuViewTypeDiary = 10,
    SelectMenuViewTypeEssay = 11,
    SelectMenuViewTypeWord  = 12,
};

@protocol SelectMenuViewDelegate <NSObject>

-(void)SelectMenuView:(SelectMenuViewType)type;

@end
@interface SelectMenuViewController : UIViewController
@property(nonatomic,assign)id<SelectMenuViewDelegate>delegate;
@end
