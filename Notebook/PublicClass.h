//
//  PublicClass.h
//  Notebook
//
//  Created by 韩金波 on 16/4/14.
//  Copyright © 2016年 Psylife. All rights reserved.
//

#import <Foundation/Foundation.h>


#import <UIKit/UIKit.h>
@interface PublicClass : NSObject
+(NSString *)getTodayStr;
+(NSString *)getTimeStr;
+(NSString *)currentWeekDayStr;
+(UIColor *)mainColor;
+(UIFont *)fangsongAndSize:(CGFloat)size;

+(BOOL)saveTheContent:(NSString *)content toPath:(NSString *)path;

+(NSString *)getDiaryPath:(NSString *)name;
+(NSString *)getEssayPath:(NSString *)name;
+(NSString *)getWordPath:(NSString *)name;
//截图
+(UIImage *)takeImageFromView:(UIView*)currentView;
+ (UIImage *)snapshot:(UIView *)view;

+ (UIImage *)image:(UIImage *)image WithColor:(UIColor *)color;
@end
