//
//  WriteWordViewController.h
//  Notebook
//
//  Created by 韩金波 on 16/4/14.
//  Copyright © 2016年 Psylife. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,InputType){
    InputTypeTextfield,
    InputTypeTextview,
};
@interface WriteWordViewController : UIViewController

@end




@interface CellModel : NSObject
@property(nonatomic,assign)InputType type;
@property(nonatomic,assign)CGFloat height;
@property(nonatomic,copy)NSString *content;
@property(nonatomic,copy)NSString *placeHolderStr;

@end

@interface ItemCellOne : UITableViewCell<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textinput;
@property(nonatomic,strong) CellModel *model;
@end
@class ItemCellTwo;
@protocol CellTextViewHeightDelegate <NSObject>

-(void)celltextViewHeightChange:(ItemCellTwo *)cell didChangeText:(NSString *)text;

@end

@interface ItemCellTwo : UITableViewCell<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property(nonatomic,strong) CellModel *model;
@property(nonatomic,assign) id<CellTextViewHeightDelegate> delegate;
@end

