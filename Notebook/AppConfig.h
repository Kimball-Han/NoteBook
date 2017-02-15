//
//  AppConfig.h
//  Notebook
//
//  Created by 韩金波 on 16/4/13.
//  Copyright © 2016年 Psylife. All rights reserved.
//

#ifndef AppConfig_h
#define AppConfig_h

#define AES_PASSWORD @"HIIDnBVUITRCVBXDJLSJLAJSLJDHSSK"
#define SERVICE_NAME @"com.han.notebook"

#ifdef DEBUG
#define KBLog(...) NSLog(__VA_ARGS__)
#else
#define KBLog(...)
#endif


#define SCREEN_WIDTH    [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT   [UIScreen mainScreen].bounds.size.height

#define IOS7    (((int)[[[UIDevice currentDevice] systemVersion] floatValue] >= 7)?YES:NO)
#define IOS8    (((int)[[[UIDevice currentDevice] systemVersion] floatValue] >= 8)?YES:NO)
#define IOS9    (((int)[[[UIDevice currentDevice] systemVersion] floatValue] >= 9)?YES:NO)

#define WEATHER_URL @"http://wanapi.damai.cn/weather.json?cityname=%@&source=10345&useCash=false"
#endif /* AppConfig_h */
