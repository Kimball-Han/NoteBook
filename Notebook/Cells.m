//
//  Cells.m
//  Notebook
//
//  Created by admin on 16/4/16.
//  Copyright © 2016年 Psylife. All rights reserved.
//

#import "Cells.h"
#import "Models.h"
#import <Masonry.h>
#import "PublicClass.h"
@implementation Cells

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end


@implementation DiaryCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self =[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
         [self configUI];
    }
    return self;
}


-(void)configUI
{
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    UILabel *weekDayLabel = [[UILabel alloc] init];
    weekDayLabel.font = [PublicClass fangsongAndSize:22.0];
    weekDayLabel.textAlignment = NSTextAlignmentCenter;
    
    UILabel *line = [[UILabel alloc] init];
    line.backgroundColor = [UIColor lightGrayColor];
    
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.numberOfLines =2;
    contentLabel.font = [PublicClass fangsongAndSize:16];
    
    
    UILabel *dateTimeLabel = [[UILabel alloc] init];
    dateTimeLabel.font = [PublicClass fangsongAndSize:13];
    dateTimeLabel.textColor = [UIColor lightGrayColor];
    UILabel *weatherLabel = [[UILabel alloc] init];
    weatherLabel.font = [PublicClass fangsongAndSize:13];
    weatherLabel.textColor = [UIColor lightGrayColor];
    weatherLabel.textAlignment = NSTextAlignmentCenter;
    UILabel *geographicalPositionLabel = [[UILabel alloc] init];
    geographicalPositionLabel.font = [PublicClass fangsongAndSize:13];
    geographicalPositionLabel.textColor = [UIColor lightGrayColor];
    geographicalPositionLabel.textAlignment = NSTextAlignmentRight;
    
    
    [self addSubview:weekDayLabel];
    [self addSubview:line];
    [self addSubview:contentLabel];
    [self addSubview:dateTimeLabel];
    [self addSubview:weatherLabel];
    [self addSubview:geographicalPositionLabel];
    
    
    self.weekDayLabel = weekDayLabel;
    self.contentLabel = contentLabel;
    self.dateTimeLabel = dateTimeLabel;
    self.weatherLabel = weatherLabel;
    self.geographicalPositionLabel = geographicalPositionLabel;
    
    
    [weekDayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(10);
        make.left.equalTo(self.mas_left).with.offset(15);
        make.width.mas_equalTo(72);
        make.bottom.equalTo(self.dateTimeLabel.mas_top).offset(-8);
    }];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(10);
        make.left.equalTo(self.weekDayLabel.mas_right).with.offset(8);
        make.width.mas_equalTo(1);
        make.bottom.equalTo(self.dateTimeLabel.mas_top).offset(-8);
    }];
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(10);
        make.left.equalTo(line.mas_right).with.offset(8);
        make.right.equalTo(self.mas_right).with.offset(-8);
        make.bottom.equalTo(self.weatherLabel.mas_top).with.offset(-8);
    }];
    [dateTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(@[weatherLabel,geographicalPositionLabel]);
        make.width.equalTo(@[weatherLabel,geographicalPositionLabel]);
        make.height.equalTo(@[weatherLabel,geographicalPositionLabel]);
        make.left.equalTo(self.mas_left).with.offset(15);
        make.height.mas_equalTo(18);
        make.bottom.equalTo(self.mas_bottom).with.offset(-2);
    }];
    
    [geographicalPositionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).with.offset(-8);
    }];
    
    [weatherLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.dateTimeLabel.mas_right);
        make.right.equalTo(self.geographicalPositionLabel.mas_left);
    }];

}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(DiaryModel *)model
{
    _model = model;
    self.weekDayLabel.text =model.weekday;
    self.geographicalPositionLabel.text =model.location;
    self.weatherLabel.text = model.weather;
    self.dateTimeLabel.text = model.datetime;
    self.contentLabel.text = model.content;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end


@implementation EssayCell



-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configUI];
    }
    return self;
}
-(void)configUI{
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    UILabel *itemLabel = [[UILabel alloc] init];
    [self.contentView addSubview:itemLabel];
    itemLabel.font = [PublicClass fangsongAndSize:20];
    itemLabel.numberOfLines =0;
    self.itemLabel = itemLabel;

    
    UILabel *desLabel = [[UILabel alloc] init];
    [self.contentView addSubview:desLabel];
    desLabel.font = [PublicClass fangsongAndSize:13];
    desLabel.textColor = [UIColor lightGrayColor];
    self.deslabel = desLabel;
    
    UILabel *contentLabel =[[UILabel alloc] init];
    [self.contentView addSubview:contentLabel];
    contentLabel.font = [PublicClass fangsongAndSize:18];
    contentLabel.numberOfLines =2;
    self.contentLabel = contentLabel;



    
    [itemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).with.offset(15);
        make.top.equalTo(self.contentView.mas_top).with.offset(8);
        make.right.equalTo(self.contentView.mas_right).with.offset(0);
    }];
    
    [desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(itemLabel.mas_bottom).with.offset(4);
        make.left.equalTo(self.contentView.mas_left).with.offset(15);
        make.right.equalTo(self.contentView.mas_right).with.offset(-8);
        make.height.mas_equalTo(@15);
//        make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-8);
    }];
    
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(desLabel.mas_bottom).with.offset(4);
        make.left.equalTo(self.contentView.mas_left).with.offset(15);
        make.right.equalTo(self.contentView.mas_right).offset(0);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-8);
        
    }];
    
  
    
    
  
   
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(EssayModel *)model
{
    _model=model;
    self.itemLabel.text = [NSString stringWithFormat:@"%@",model.title];
    self.contentLabel.text = [NSString stringWithFormat:@"%@",model.content];
    self.deslabel.text = [NSString stringWithFormat:@"%@    字数：%@",model.datetime,model.wordnumber];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


@end


@implementation WordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configUI];
    }
    return self;
}
-(void)configUI
{    UILabel *contentLabel = [[UILabel alloc] init];
     UILabel *paraphraseLabel = [[UILabel alloc] init];
     UILabel *numlabel = [[UILabel alloc] init];
    [self addSubview:contentLabel];
    [self addSubview:paraphraseLabel];
    [self addSubview:numlabel];
    self.contentLabel = contentLabel;
    self.paraphraseLabel = paraphraseLabel;
    self.numlabel = numlabel;
    self.contentLabel.font = [PublicClass fangsongAndSize:22];
    self.paraphraseLabel.font = [PublicClass fangsongAndSize:18];
    self.numlabel.font = [PublicClass fangsongAndSize:14];
    self.numlabel.textColor = [UIColor lightGrayColor];
    self.numlabel.textAlignment = NSTextAlignmentRight;
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(15);
        make.top.equalTo(self.mas_top).with.offset(8);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(30);
    }];
    [self.paraphraseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(15);
        make.top.equalTo(self.contentLabel.mas_bottom).with.offset(4);
        make.bottom.equalTo(self.mas_bottom).with.offset(-4);
        make.right.equalTo(self.numlabel.mas_left).with.offset(-8);
    }];
    [self.numlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(40);
        make.bottom.equalTo(self.mas_bottom).with.offset(-8);
        make.right.equalTo(self.mas_right).with.offset(-8);
    }];
}
-(void)setModel:(WordModel *)model
{
    _model =model;
    self.contentLabel.text = model.wordname;
    self.paraphraseLabel.text = [NSString stringWithFormat:@"释义：%@",model.paraphrase];
    self.numlabel.text = [NSString stringWithFormat:@"%@次",model.num];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
