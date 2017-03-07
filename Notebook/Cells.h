//
//  Cells.h
//  Notebook
//
//  Created by admin on 16/4/16.
//  Copyright © 2016年 Psylife. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Cells : UITableViewCell

@end

@class DiaryModel;
@interface DiaryCell : UITableViewCell
@property (weak, nonatomic)  UILabel *weekDayLabel;

@property (weak, nonatomic)  UILabel *geographicalPositionLabel;
@property (weak, nonatomic)  UILabel *weatherLabel;
@property (weak, nonatomic)  UILabel *dateTimeLabel;
@property (weak, nonatomic)  UILabel *contentLabel;

@property (nonatomic,strong) DiaryModel *model;
@end

@class EssayModel;

@interface EssayCell : UITableViewCell
@property (weak, nonatomic)  UILabel *itemLabel;
@property (weak, nonatomic)  UILabel *contentLabel;
@property (weak, nonatomic)  UILabel *deslabel;


@property(nonatomic,strong) EssayModel *model;
@end

@class WordModel;
@interface WordCell : UITableViewCell
@property (weak, nonatomic)  UILabel *contentLabel;
@property (weak, nonatomic)  UILabel *paraphraseLabel;
@property (weak, nonatomic)  UILabel *numlabel;
@property (strong,nonatomic) WordModel *model;
@end
