//
//  PublicClass.m
//  Notebook
//
//  Created by 韩金波 on 16/4/14.
//  Copyright © 2016年 Psylife. All rights reserved.
//

#import "PublicClass.h"

@implementation PublicClass

+(NSString *)getTodayStr
{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat =@"yyyy年MM月dd日";
    NSString *str = [formatter stringFromDate:date];
    return str;
}
+(NSString *)getTimeStr
{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat =@"yyyyMMddHHmmss";
    NSString *str = [formatter stringFromDate:date];
    return str;
}
+ (NSString *)currentWeekDayStr
{
    NSString *weekDayStr = nil;
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat =@"yyyy-MM-dd";
    NSString *str = [formatter stringFromDate:date];
    if (str.length >= 10) {
        
        NSString *nowString = [str substringToIndex:10];
        NSArray *array = [nowString componentsSeparatedByString:@"-"];
        
        if (array.count == 0) {
            array = [nowString componentsSeparatedByString:@"/"];
        }
        
        if (array.count >= 3) {
            NSInteger year = [[array objectAtIndex:0] integerValue];
            NSInteger month = [[array objectAtIndex:1] integerValue];
            NSInteger day = [[array objectAtIndex:2] integerValue];
            
            [comps setYear:year];
            [comps setMonth:month];
            [comps setDay:day];
        }
    }
    
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *_date = [gregorian dateFromComponents:comps];
    NSDateComponents *weekdayComponents = [gregorian components:NSCalendarUnitWeekday fromDate:_date];
    NSInteger week = [weekdayComponents weekday];
    
    switch (week) {
        case 1:
            weekDayStr = @"星期日";
            break;
        case 2:
            weekDayStr = @"星期一";
            break;
        case 3:
            weekDayStr = @"星期二";
            break;
        case 4:
            weekDayStr = @"星期三";
            break;
        case 5:
            weekDayStr = @"星期四";
            break;
        case 6:
            weekDayStr = @"星期五";
            break;
        case 7:
            weekDayStr = @"星期六";
            break;
        default:
            weekDayStr = @"";
            break;
    }
    return weekDayStr;
}
+(UIColor *)mainColor
{
    return [UIColor colorWithRed:73/255.0 green:187/255.0 blue:199/255.0 alpha:1];
}
+(UIFont *)fangsongAndSize:(CGFloat)size
{
    return [UIFont fontWithName:@"FangSong_GB2312" size:size];
}

+(BOOL)saveTheContent:(NSString *)content toPath:(NSString *)path
{
    NSFileManager *fileManger = [NSFileManager defaultManager];
     NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
    BOOL ret = NO;
  
    if ([fileManger fileExistsAtPath:path]) {
       ret = [data writeToFile:path atomically:YES];
    }else{
        
       ret = [fileManger createFileAtPath:path contents:data attributes:nil];
    }
   
    
    return ret;
}
+(NSString *)getDiaryPath:(NSString *)name
{
    NSString *path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"日记"];
     NSFileManager *fileManger = [NSFileManager defaultManager];
    BOOL ret;
    if ([fileManger fileExistsAtPath:path isDirectory:&ret]) {
       
    }else{
        [fileManger createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    path = [path stringByAppendingFormat:@"/%@.txt",name];
    return path;
}
+(NSString *)getEssayPath:(NSString *)name
{
    NSString *path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"随笔"];
    NSFileManager *fileManger = [NSFileManager defaultManager];
    BOOL ret;
    if ([fileManger fileExistsAtPath:path isDirectory:&ret]) {
        
    }else{
        [fileManger createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    path = [path stringByAppendingFormat:@"/%@.txt",name];
    return path;
}
+(NSString *)getWordPath:(NSString *)name
{
    NSString *path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"日记"];
    NSFileManager *fileManger = [NSFileManager defaultManager];
    BOOL ret;
    if ([fileManger fileExistsAtPath:path isDirectory:&ret]) {
        
    }else{
        [fileManger createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    path = [path stringByAppendingFormat:@"/%@.txt",name];
    return path;
}

+(UIImage *)takeImageFromView:(UIView*)currentView
{
    UIGraphicsBeginImageContext(currentView.bounds.size);
    [currentView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageWriteToSavedPhotosAlbum(viewImage, nil, nil, nil);
    return viewImage;
}
+ (UIImage *)snapshot:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, 0);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
+(UIImage *)coreBlurImage:(UIImage *)image withBlurNumber:(CGFloat)blur
{
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage= [CIImage imageWithCGImage:image.CGImage];
    //设置filter
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey]; [filter setValue:@(blur) forKey: @"inputRadius"];
    //模糊图片
    CIImage *result=[filter valueForKey:kCIOutputImageKey];
    CGImageRef outImage=[context createCGImage:result fromRect:[result extent]];
    UIImage *blurImage=[UIImage imageWithCGImage:outImage];
    CGImageRelease(outImage);
    return blurImage;
}

//修改图片颜色
+ (UIImage *)image:(UIImage *)image WithColor:(UIColor *)color
{
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, image.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    CGContextClipToMask(context, rect, image.CGImage);
    [color setFill];
    CGContextFillRect(context, rect);
    UIImage*newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
@end
