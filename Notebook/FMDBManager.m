//
//  FMDBManager.m
//  Notebook
//
//  Created by 韩金波 on 16/4/14.
//  Copyright © 2016年 Psylife. All rights reserved.
//
/**
 datetime ,timestr, weekday, weather, content ,wordnumber ,location
 
 datetime, timestr , weekday , title , content ,wordnumber
 
 datetime, timestr, weekday  , wordname , paraphrase ,examplesentence
 
 */
#import "FMDBManager.h"
#import <FMDB.h>
#import "AppConfig.h"
#import "Models.h"
@implementation FMDBManager
{
    FMDatabase *_db;
}
+(instancetype)manager
{
    static FMDBManager *manager = nil;
    static  dispatch_once_t once;
    dispatch_once(&once, ^{
        manager = [[FMDBManager alloc] init];
    });
    return manager;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        //初始化操作
        NSString *dbPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"user.sqlite"];
        
       _db = [FMDatabase  databaseWithPath:dbPath];
        if ([_db open]) {
            BOOL result = [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_diary (id integer PRIMARY KEY AUTOINCREMENT, datetime text NOT NULL, timestr text NOT NULL, weekday text NOT NULL, weather text NOT NULL, content text NOT NULL,wordnumber text NOT NULL ,location text NOT NULL)"];
            if (result){
                KBLog(@"创建日记表成功");
            }
            result = [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_essay (id integer PRIMARY KEY AUTOINCREMENT, datetime text NOT NULL, timestr text NOT NULL, weekday text NOT NULL, title text NOT NULL, content text NOT NULL,wordnumber text NOT NULL)"];
            if (result){
                KBLog(@"创建随笔表成功");
            }
            result = [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_word (id integer PRIMARY KEY AUTOINCREMENT, datetime text NOT NULL, timestr text NOT NULL, weekday text NOT NULL, wordname text NOT NULL, paraphrase text NOT NULL,examplesentence text ,num integer)"];
            if (result){
                KBLog(@"创建单词表成功");
            }
            
        }
        
        
    }
    return self;
}

-(BOOL)insertModel:(id)model
{

    if ([[model class] isSubclassOfClass:[DiaryModel class]]) {
        DiaryModel *smodel = (DiaryModel *)model;
        
        return [_db executeUpdateWithFormat:@"insert into t_diary (datetime ,timestr, weekday, weather, content ,wordnumber,location) values (%@,%@,%@,%@,%@,%@,%@);",smodel.datetime,smodel.timestr,smodel.weekday,smodel.weather,smodel.content,smodel.wordnumber,smodel.location];
    }else if ([[model class] isSubclassOfClass:[EssayModel class]]){
        EssayModel *smodel = (EssayModel *)model;
        return [_db executeUpdateWithFormat:@"insert into t_essay (datetime, timestr , weekday , title , content ,wordnumber) values (%@,%@,%@,%@,%@,%@);",smodel.datetime,smodel.timestr,smodel.weekday,smodel.title,smodel.content,smodel.wordnumber];
        
    }else if ([[model class] isSubclassOfClass:[WordModel class]]){
        WordModel *smodel = (WordModel *)model;
        return [_db executeUpdateWithFormat:@"insert into t_word (datetime, timestr, weekday  , wordname , paraphrase ,examplesentence,num) values (%@,%@,%@,%@,%@,%@,%@);",smodel.datetime,smodel.timestr,smodel.weekday,smodel.wordname,smodel.paraphrase,smodel.examplesentence,smodel.num];
    }
  return   NO;
    
    
}
-(BOOL)deleteModel:(id)model
{
    NSString *sql;
    if ([[model class] isSubclassOfClass:[DiaryModel class]]) {
        DiaryModel *smodel = (DiaryModel *)model;
        
        sql = [NSString stringWithFormat:@"delete from t_diary where timeStr = '%@'",smodel.timestr];
    }else if ([[model class] isSubclassOfClass:[EssayModel class]]){
        EssayModel *smodel = (EssayModel *)model;
        sql = [NSString stringWithFormat:@"delete from t_essay where timeStr = '%@'",smodel.timestr];
    }else if ([[model class] isSubclassOfClass:[WordModel class]]){
        WordModel *smodel = (WordModel *)model;
       sql = [NSString stringWithFormat:@"delete from t_word where timeStr = '%@'",smodel.timestr];
    }
    BOOL ret = [_db executeUpdate:sql];
    return   ret;
}

-(NSMutableArray *)fetchOutTheTable:(KBFMDBTable)table AndPage:(NSInteger)page
{
    NSMutableArray *dataArray = [NSMutableArray array];
    NSString *tablename ;
//    NSArray *arrayKey;
    NSString *modelClass;
    switch (table) {
        case KBFMDBTableDiary:
            tablename = @"t_diary";
//            arrayKey = @[ @"datetime" ,@"timestr", @"weekday", @"weather",@"content" ,@"wordnumber",@"location"];
            modelClass=@"DiaryModel";
            break;
        case KBFMDBTableEssay:
            tablename = @"t_essay";
//            arrayKey = @[@"datetime",@"timestr" ,@"weekday" ,@"title" , @"content" ,@"wordnumber"];
            modelClass = @"EssayModel";
            break;
        case KBFMDBTableWord:
            tablename = @"t_word";
//            arrayKey =@[@"datetime",@"timestr",@"weekday", @"wordname",@"paraphrase",@"examplesentence"];
            modelClass = @"WordModel";
            break;

        default:
            break;
    }
    NSString *sql =[NSString stringWithFormat:@"select * from %@ order by id desc limit %ld,%ld ",tablename,(long)(page *10),(long)((page+1) *10)];
    FMResultSet * result = [_db executeQuery:sql];
    while ([result next]) {

        id model = [[NSClassFromString(modelClass) alloc] init];
        [model setValue:@([result intForColumn:@"id"]) forKey:@"ids"];
        [model setValuesForKeysWithDictionary:result.resultDictionary];
        [dataArray addObject:model];
        
    }
    
    return dataArray;
}
//查找
-(NSMutableArray *)fetchOutDiaryfromT_diaryForDay:(NSString *)date
{
    NSMutableArray *array = [NSMutableArray array];
    NSString *sql = [NSString stringWithFormat:@"select *from t_diary where datetime = '%@'",date];
    FMResultSet *resultSet = [_db executeQuery:sql];
    while ([resultSet next]) {
        DiaryModel *model = [[DiaryModel alloc] init];
        [model setValuesForKeysWithDictionary:resultSet.resultDictionary];
        [array addObject:model];
    }
    return array;
}
//统计
-(NSNumber *)statisticsTotalNumForTable:(NSString *)tablename
{
    NSString *sql = [NSString stringWithFormat:@"SELECT COUNT(*) FROM %@",tablename];
    FMResultSet *resultSet = [_db executeQuery:sql];
    while ([resultSet next]) {
        NSInteger s = [resultSet intForColumnIndex:0];
        return @(s);
    }
    return @0;
}
//检索
-(NSMutableArray *)searchInfoFromTable:(NSString *)tablename forText:(NSString *)text
{
    NSMutableArray *array = [NSMutableArray array];
    NSString *sql;
    NSString *modelClass;
    if ([tablename isEqualToString:@"t_essay"]) {
        sql= [NSString stringWithFormat:@"select *from t_essay where title like'%%%@%%'",text];
        modelClass = @"EssayModel";
    }else{
       sql= [NSString stringWithFormat:@"select *from t_word where wordname like'%%%@%%'",text];
       modelClass = @"WordModel";
    }
    FMResultSet * result = [_db executeQuery:sql];
    while ([result next]) {
        id model = [[NSClassFromString(modelClass) alloc] init];
        [model setValue:@([result intForColumn:@"id"]) forKey:@"ids"];
        [model setValuesForKeysWithDictionary:result.resultDictionary];
        [array addObject:model];
    }
    return array;
}

-(BOOL)updateWordTablenum:(WordModel *)model;
{
    NSString * sql= [NSString stringWithFormat:@"update t_word set num = %@ where id = %@",model.num,model.ids];
    if ( [_db executeUpdate:sql]) {
        return YES;
    }
    return NO;
}
@end
