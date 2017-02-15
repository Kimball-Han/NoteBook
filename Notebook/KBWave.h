//
//  KBWave.h
//  GIFDemo
//
//  Created by 韩金波 on 16/9/2.
//  Copyright © 2016年 Psylife. All rights reserved.
//

#import <UIKit/UIKit.h>
#define KBColor(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]


typedef void(^KBWaveBlock)(CGFloat currentY);
@interface KBWave : UIView

@property(nonatomic,assign)CGFloat waveCurvature;

@property(nonatomic,assign)CGFloat waveSpeed;

@property(nonatomic,assign)CGFloat waveHeight;

@property(nonatomic,strong)UIColor *realWaveColor;

@property(nonatomic,strong)UIColor *maskWaveColor;

@property(nonatomic,copy)KBWaveBlock waveBlock;

-(void)stopWaveAnimation;

-(void)startWaveAnimation;


@end
