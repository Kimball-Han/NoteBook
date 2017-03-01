//
//  KBWave.m
//  GIFDemo
//
//  Created by 韩金波 on 16/9/2.
//  Copyright © 2016年 Psylife. All rights reserved.
//

#import "KBWave.h"

@interface KBWave ()

@property(nonatomic, strong)CADisplayLink *timer;

@property(nonatomic, strong)CAShapeLayer *realWaveLayer;

@property(nonatomic, strong)CAShapeLayer *maskWaveLayer;

@property(nonatomic, assign)CGFloat offset;

@end

@implementation KBWave

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self initData];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initData];
    }
    return self;
}

-(void)initData
{
    self.waveSpeed = 0.5;
    self.waveCurvature = 1.5;
    self.waveHeight = 4.0;
    self.realWaveColor = [UIColor whiteColor];
    self.maskWaveColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4];
    
    [self.layer addSublayer:self.realWaveLayer];
    [self.layer addSublayer:self.maskWaveLayer];
}

-(CAShapeLayer *)realWaveLayer
{
    if (!_realWaveLayer) {
        _realWaveLayer = [CAShapeLayer layer];
        CGRect frame = [self bounds];
        frame.origin.y = frame.size.height - self.waveHeight;
        frame.size.height = self.waveHeight;
        _realWaveLayer.frame = frame;
        _realWaveLayer.fillColor = self.realWaveColor.CGColor;
    }
    return _realWaveLayer;
}

-(CAShapeLayer *)maskWaveLayer
{
    if (!_maskWaveLayer) {
        _maskWaveLayer = [CAShapeLayer layer];
        CGRect frame = [self bounds];
        frame.origin.y = frame.size.height - self.waveHeight;
        frame.size.height = self.waveHeight;
        _maskWaveLayer.frame = frame;
        _maskWaveLayer.fillColor = self.maskWaveColor.CGColor;
    }
    return _maskWaveLayer;
}

-(void)setWaveHeight:(CGFloat)waveHeight
{
    _waveHeight = waveHeight;
    CGRect frame = [self bounds];
    frame.origin.y = frame.size.height-self.waveHeight;
    frame.size.height = self.waveHeight;
    _realWaveLayer.frame = frame;
    
    CGRect frame1 = [self bounds];
    frame1.origin.y = frame1.size.height-self.waveHeight;
    frame1.size.height = self.waveHeight;
    _maskWaveLayer.frame = frame1;
    
}

-(void)startWaveAnimation
{
    self.timer = [CADisplayLink displayLinkWithTarget:self selector:@selector(wave)];
    [self.timer addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

-(void)stopWaveAnimation
{
    self.timer.paused = YES;
    [self.timer invalidate];
    self.timer = nil;
}

-(void)wave{
    
    self.offset += self.waveSpeed;
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = self.waveHeight;
    
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, height);
    CGFloat y = 0.f;
    
    
    CGMutablePathRef maskPath = CGPathCreateMutable();
    CGPathMoveToPoint(maskPath, NULL, 0, height);
    CGFloat maskY = 0.f;
    
    for (CGFloat x=0.f; x<= width; x++) {
        y = height *sinf(0.01 *self.waveCurvature *x +self.offset *0.045);
        CGPathAddLineToPoint(path, NULL, x, y);
        
        maskY = -y;
        CGPathAddLineToPoint(maskPath, NULL, x, maskY);
    }
    
    CGFloat w = self.bounds.size.width/3;
    CGFloat Y1 = height *sinf(0.01 *self.waveCurvature *w*0.5 + self.offset *0.045);
    CGFloat Y2 = height *sinf(0.01 *self.waveCurvature *w*1.5 + self.offset *0.045);
    CGFloat Y3 = height *sinf(0.01 *self.waveCurvature *w*2.5 + self.offset *0.045);

    if (self.waveBlock) {
        self.waveBlock(Y1,Y2,Y3);
    }
    
    
    CGPathAddLineToPoint(path, NULL, width, height);
    CGPathAddLineToPoint(path, NULL, 0, height);
    CGPathCloseSubpath(path);
    self.realWaveLayer.path = path;
    self.realWaveLayer.fillColor = self.realWaveColor.CGColor;
    CGPathRelease(path);
    
    CGPathAddLineToPoint(maskPath, NULL, width, height);
    CGPathAddLineToPoint(maskPath, NULL, 0, height);
    CGPathCloseSubpath(maskPath);
    self.maskWaveLayer.path = maskPath;
    self.maskWaveLayer.fillColor = self.maskWaveColor.CGColor;
    CGPathRelease(maskPath);
}

-(void)dealloc
{
    [self stopWaveAnimation];
    if (_realWaveLayer) {
        [_realWaveLayer removeFromSuperlayer];
        _realWaveLayer = nil;
    }
    if (_maskWaveLayer) {
        [_maskWaveLayer removeFromSuperlayer];
        _maskWaveLayer = nil;
    }
}
@end
