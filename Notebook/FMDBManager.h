//
//  FMDBManager.h
//  Notebook
//
//  Created by 韩金波 on 16/4/14.
//  Copyright © 2016年 Psylife. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,KBFMDBTable) {
    KBFMDBTableDiary,
    KBFMDBTableEssay,
    KBFMDBTableWord
};
@class WordModel;
@interface FMDBManager : NSObject
+(instancetype)manager;

-(BOOL)insertModel:(id)model;
-(BOOL)deleteModel:(id)model;

-(NSMutableArray *)fetchOutTheTable:(KBFMDBTable)table AndPage:(NSInteger )page;

//查找
-(NSMutableArray *)fetchOutDiaryfromT_diaryForDay:(NSString *)date;
//统计
-(NSNumber *)statisticsTotalNumForTable:(NSString *)tablename;

//检索
-(NSMutableArray *)searchInfoFromTable:(NSString *)tablename forText:(NSString *)text;

-(BOOL)updateWordTablenum:(WordModel *)model;
@end
