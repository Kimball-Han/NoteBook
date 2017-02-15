//
//  MeViewController.h
//  Notebook
//
//  Created by 韩金波 on 16/4/6.
//  Copyright © 2016年 Psylife. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MeViewController : UIViewController

@end

@interface HeaderView : UIView
@property(nonatomic,weak)UIImageView *header;
@property(nonatomic,weak)UILabel *diaryLabel;
@property(nonatomic,weak)UILabel *essayLabel;
@property(nonatomic,weak)UILabel *wordLabel;
-(void)getcount;
@end