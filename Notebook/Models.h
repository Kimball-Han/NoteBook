//
//  Models.h
//  Notebook
//
//  Created by 韩金波 on 16/4/15.
//  Copyright © 2016年 Psylife. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 datetime timestr weekday weather content wordnumber
 
 datetime, timestr , weekday , title , content ,wordnumber
 
 datetime, timestr, weekday  , wordname , paraphrase ,examplesentence
 
 */
@interface Models : NSObject

@end

@interface DiaryModel : NSObject
@property(nonatomic,copy)NSString *ids;
@property(nonatomic,copy)NSString *datetime;
@property(nonatomic,copy)NSString *timestr;
@property(nonatomic,copy)NSString *weekday;
@property(nonatomic,copy)NSString *weather;
@property(nonatomic,copy)NSString *content;
@property(nonatomic,copy)NSString *wordnumber;
@property(nonatomic,copy)NSString *location;

@end

@interface EssayModel : NSObject
@property(nonatomic,copy)NSString *ids;
@property(nonatomic,copy)NSString *datetime;
@property(nonatomic,copy)NSString *timestr ;
@property(nonatomic,copy)NSString *weekday ;
@property(nonatomic,copy)NSString *title ;
@property(nonatomic,copy)NSString *content ;
@property(nonatomic,copy)NSString *wordnumber;
@end


@interface WordModel : NSObject
@property(nonatomic,copy)NSString *ids;
@property(nonatomic,copy)NSString *datetime;
@property(nonatomic,copy)NSString *timestr;
@property(nonatomic,copy)NSString *weekday;
@property(nonatomic,copy)NSString *wordname;
@property(nonatomic,copy)NSString *paraphrase;
@property(nonatomic,copy)NSString *examplesentence;
@property(nonatomic,strong)NSNumber *num;
@end