//
//  CustomTabBar.m
//  Notebook
//
//  Created by 韩金波 on 16/4/6.
//  Copyright © 2016年 Psylife. All rights reserved.
//

#import "CustomTabBar.h"

@implementation CustomTabBar

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)init
{
    self = [super init];
    if (self) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"tabBar_publish_icon"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"tabBar_publish_click_icon"] forState:UIControlStateSelected];
        [button sizeToFit];
        [self addSubview:button];
        self.addButton = button;
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    self.addButton.center = CGPointMake(width*0.5, height *0.5);
    
    CGFloat tabBarItemW = width/5.0;
    CGFloat tabBarItemH = height;
    CGFloat tabBarItemY = 0;
    NSInteger index = 0;
    NSArray *items = self.subviews;
    for (UIView * item in items) {
        if ([NSStringFromClass(item.classForCoder) isEqualToString:@"UITabBarButton"]) {
            CGFloat x = index * tabBarItemW;
            if (index >= 2) {
                x += tabBarItemW;
            }
            item.frame = CGRectMake(x, tabBarItemY, tabBarItemW, tabBarItemH);
            index +=1;
        }
    }
}
@end
