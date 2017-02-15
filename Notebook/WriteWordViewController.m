//
//  WriteWordViewController.m
//  Notebook
//
//  Created by 韩金波 on 16/4/14.
//  Copyright © 2016年 Psylife. All rights reserved.
//

#import "WriteWordViewController.h"
#import "AppConfig.h"
#import "Models.h"
#import "PublicClass.h"
#import "FMDBManager.h"
@interface WriteWordViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong) NSMutableArray *dataArray;
@property(nonatomic,weak)   UIButton *paraphraseButton;
@property(nonatomic,weak)   UIButton *exampleButton;
@end

@implementation WriteWordViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
   
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self initUI];
    
}
-(void)dealloc
{
   
}
-(void)initUI{
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addButton.backgroundColor = [UIColor greenColor];
    addButton.frame = CGRectMake(SCREEN_WIDTH - 64, SCREEN_HEIGHT-64, 44, 44);
    addButton.layer.cornerRadius = 22;
    [addButton addTarget:self action:@selector(addButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addButton];
    
    CALayer *hl = [CALayer layer];
    hl.frame = CGRectMake(20, 7, 4, 30);
    hl.backgroundColor = [UIColor whiteColor].CGColor;
    hl.cornerRadius = 2;
    
    [addButton.layer addSublayer:hl];
    CALayer *vl = [CALayer layer];
    vl.frame = CGRectMake(7, 20, 30, 4);
    vl.cornerRadius = 2;
    
    vl.backgroundColor = [UIColor whiteColor].CGColor;
    [addButton.layer addSublayer:vl];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(UIButton *)paraphraseButton{
    if (!_paraphraseButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor redColor];
        button.frame = CGRectMake(SCREEN_WIDTH - 64, SCREEN_HEIGHT-64, 44, 44);
        [button setTitle:@"释义" forState:UIControlStateNormal];
        button.layer.cornerRadius = 22;
        [self.view addSubview:button];
        [button addTarget:self action:@selector(menuButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _paraphraseButton = button;
    }
    return _paraphraseButton;
}
-(UIButton *)exampleButton
{
    if (!_exampleButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor brownColor];
        button.frame = CGRectMake(SCREEN_WIDTH - 64, SCREEN_HEIGHT-64, 44, 44);
        button.layer.cornerRadius = 22;
        [button setTitle:@"例句" forState:UIControlStateNormal];
        [self.view addSubview:button];
  
        [button addTarget:self action:@selector(menuButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _exampleButton = button;
    }
    return _exampleButton;
}
-(void)addButtonClick:(UIButton *)sender{
    
    typeof(self) weakSelf = self;
    if (_paraphraseButton) {
        sender.userInteractionEnabled = NO;
        [UIView animateWithDuration:0.5 animations:^{
            weakSelf.paraphraseButton.frame = CGRectMake(SCREEN_WIDTH - 64 , SCREEN_HEIGHT-64, 44, 44);
            weakSelf.exampleButton.frame = CGRectMake(SCREEN_WIDTH - 64 , SCREEN_HEIGHT-64, 44, 44);
            
        } completion:^(BOOL finished) {
            [weakSelf.paraphraseButton removeFromSuperview];
            [weakSelf.exampleButton removeFromSuperview];
            sender.userInteractionEnabled = YES;
        }];
    }else{
       
        [weakSelf.view insertSubview:self.exampleButton belowSubview:sender];
         [weakSelf.view insertSubview:self.paraphraseButton belowSubview:sender];
        sender.userInteractionEnabled = NO;
        [UIView animateWithDuration:0.5 animations:^{
           weakSelf.paraphraseButton.frame = CGRectMake(SCREEN_WIDTH - 64 , SCREEN_HEIGHT-64-60, 44, 44);
            weakSelf.exampleButton.frame = CGRectMake(SCREEN_WIDTH - 64 , SCREEN_HEIGHT-64- 60 *2, 44, 44);
          
        } completion:^(BOOL finished) {
             sender.userInteractionEnabled = YES;
        }];
        
    }
    
}

-(void)menuButtonClick:(UIButton *)sender{
    typeof(self) weakSelf = self;
         weakSelf.view.userInteractionEnabled = NO;
        [UIView animateWithDuration:0.5 animations:^{
            weakSelf.paraphraseButton.frame = CGRectMake(SCREEN_WIDTH - 64 , SCREEN_HEIGHT-64, 44, 44);
            weakSelf.exampleButton.frame = CGRectMake(SCREEN_WIDTH - 64 , SCREEN_HEIGHT-64, 44, 44);
            
        } completion:^(BOOL finished) {
            [weakSelf.paraphraseButton removeFromSuperview];
            [weakSelf.exampleButton removeFromSuperview];
            weakSelf.view.userInteractionEnabled = YES;
        }];
    CellModel *model = [[CellModel alloc] init];
    if(sender == _paraphraseButton){
        model.type =  InputTypeTextfield;
        model.placeHolderStr = @"释义";
    }else if (sender == _exampleButton){
        model.type = InputTypeTextview;
        model.placeHolderStr = @"例句";
        model.height = 53;
    }
    [self.dataArray addObject:model];
    [self.tableView reloadData];

}
- (IBAction)saveButtonClick:(UIButton *)sender {

    //    @[@"datetime",@"timestr",@"weekday", @"wordname",@"paraphrase",@"examplesentence"];
    WordModel *model = [[WordModel alloc] init];
    model.datetime = [PublicClass getTodayStr ];
    model.timestr = [PublicClass getTimeStr];
    model.weekday = [PublicClass currentWeekDayStr];
    NSString *paraphrase ;
    NSString *examplesentence ;
    for (CellModel *mod in self.dataArray) {
        if ([mod.placeHolderStr isEqualToString:@"单词"]&& mod.content.length>0) {
            model.wordname = mod.content;
        }else if ([mod.placeHolderStr isEqualToString:@"释义"]&& mod.content.length>0) {
            if (paraphrase) {
                paraphrase= [paraphrase stringByAppendingString:@"\n"];
                paraphrase= [paraphrase stringByAppendingString:mod.content];
            }else{
                paraphrase = mod.content;
            }
        }else if ([mod.placeHolderStr isEqualToString:@"例句"]&& mod.content.length>0) {
            if (examplesentence) {
                examplesentence = [examplesentence stringByAppendingString:@"\n"];
                examplesentence =[examplesentence stringByAppendingString:mod.content];
            }else{
                examplesentence = mod.content;
            }
        }
    }
    model.paraphrase = paraphrase;
    if (examplesentence.length >0) {
         model.examplesentence = examplesentence;
    }else{
        model.examplesentence = @"";
    }
   
    model.num = @0;
    if (model.wordname.length > 0 && model.paraphrase.length>0) {
        if ([[FMDBManager manager] insertModel:model]) {
             [[NSNotificationCenter defaultCenter] postNotificationName:@"updateWord" object:nil];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
   

}


- (IBAction)closeButton:(UIButton *)sender {
   [self dismissViewControllerAnimated:YES completion:nil];
    
}
-(NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        CellModel *model = [[CellModel alloc] init];
        model.type = InputTypeTextfield;
        model.placeHolderStr = @"单词";
        [_dataArray addObject:model];
        CellModel *model2 = [[CellModel alloc] init];
        model2.type =  InputTypeTextfield;
        model2.placeHolderStr = @"释义";
        [_dataArray addObject:model2];
    }
    return _dataArray;
}
//#pragma mark - 键盘监听事件
//-(void)keyboardWillShow:(NSNotification *)notification
//{
//    
//}
//-(void)keyboardWillHide:(NSNotification *)notification
//{
//    
//}

#pragma mark - UITableViewDelegate&UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return   self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    CellModel *model = self.dataArray[indexPath.row];
    if (model.type == InputTypeTextfield) {
      cell = [tableView dequeueReusableCellWithIdentifier:@"cellOne"];
    }else{
       cell = [tableView dequeueReusableCellWithIdentifier:@"cellTwo"];
//        ((ItemCellTwo *)cell).delegate = self;;
       
    }
    [cell setValue:model forKey:@"model"];
    return cell;
}
//-(void)celltextViewHeightChange:(ItemCellTwo *)cell didChangeText:(NSString *)text
//{
//    [self.tableView reloadRowsAtIndexPaths:@[[self.tableView indexPathForCell:cell]] withRowAnimation:UITableViewRowAnimationNone];
//    
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
      CellModel *model = self.dataArray[indexPath.row];
    if (model.height>50) {
        return model.height;
    }
      return 50;
    
    
    
}
//-(void)dealloc
//{
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//
//}

@end


@implementation CellModel


-(void)setValue:(id)value forUndefinedKey:(nonnull NSString *)key
{
    
}
@end

#pragma mark - ItemCellOne
@implementation ItemCellOne

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
      self.textinput.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange) name:UITextFieldTextDidChangeNotification object:nil];
}
-(void)setModel:(CellModel *)model
{
    _model = model;
    if ([_model.placeHolderStr isEqualToString:@"单词"]) {
        self.textinput.keyboardType = UIKeyboardTypeASCIICapable;
    }else{
        self.textinput.keyboardType = UIKeyboardTypeDefault;
    }
    self.textinput.text = model.content;
    self.textinput.placeholder = model.placeHolderStr;
}
-(void)textFieldDidChange{
    _model.content = self.textinput.text;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
-(void)dealloc
{
    
}

@end
#pragma mark - ItemCellTwo
@implementation ItemCellTwo

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.textView.delegate = self;
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}
-(void)setModel:(CellModel *)model
{
    _model = model;
    self.placeholderLabel.text = model.placeHolderStr;
    self.textView.text = _model.content;
    self.textView.keyboardType = UIKeyboardTypeASCIICapable;
    self.placeholderLabel.hidden = self.textView.hasText;
    
}
-(void)textViewDidChange:(UITextView *)textView
{
     self.model.content = self.textView.text;
    self.placeholderLabel.hidden = self.textView.hasText;
    
    CGSize size = [textView sizeThatFits:CGSizeMake(textView.frame.size.width, 1000.0)];
    if (size.height+16 > self.model.height) {

        self.model.height = size.height+16;
        UITableView *tableView = [self tableView];
        [tableView beginUpdates];
        [self layoutIfNeeded];
        [tableView endUpdates];
       
    }
    
    
}

- (UITableView *)tableView
{
    UIView *tableView = self.superview;
    while (![tableView isKindOfClass:[UITableView class]] && tableView) {
        tableView = tableView.superview;
    }
    return (UITableView *)tableView;
}

//-(CGSize)sizeWithString:(NSString *)string font:(UIFont *)font
//{
//    CGRect rect = [string boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 16, 8000)//限制最大的宽度和高度
//                                       options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  |NSStringDrawingUsesLineFragmentOrigin// 采用换行模式
//                                    attributes:@{NSFontAttributeName: font}//传人的字体字典
//                                       context:nil];
//    return rect.size;
//}
-(BOOL)textView:(UITextView *)textView shouldChangeText·InRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


@end


