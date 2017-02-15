//
//  SelectMenuViewController.m
//  Notebook
//
//  Created by 韩金波 on 16/4/7.
//  Copyright © 2016年 Psylife. All rights reserved.
//

#import "SelectMenuViewController.h"


@interface SelectMenuViewController ()

@property (weak, nonatomic) IBOutlet UIView *writeDiaryView;
@property (weak, nonatomic) IBOutlet UIView *writeEssayView;
@property (weak, nonatomic) IBOutlet UIView *writeWordView;
@end

@implementation SelectMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    self.writeDiaryView.tag =10;
    [self.writeDiaryView addGestureRecognizer:tap1];
    
      UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    self.writeEssayView.tag =11;
    [self.writeEssayView addGestureRecognizer:tap2];
  
      UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    self.writeWordView.tag =12;
    [self.writeWordView addGestureRecognizer:tap3];
}

-(void)tapGesture:(UITapGestureRecognizer *)sender
{
//    NSString *identifier;
//    switch (sender.view.tag) {
//        case SelectMenuViewTypeDiary:
//        {
//            identifier=@"writeDiary";
//        }
//            break;
//        case SelectMenuViewTypeEssay:
//        {
//            identifier=@"writeEssay";
//        }
//            break;
//        case SelectMenuViewTypeWord:
//        {
//            identifier=@"writeWord";
//        }
//            break;
//            
//        default:
//            break;
//    }
//    [self performSegueWithIdentifier:identifier sender:self];
    if([self.delegate respondsToSelector:@selector(SelectMenuView:)]){
        [self.delegate SelectMenuView:sender.view.tag];
        [self dismissViewControllerAnimated:NO completion:nil];
        
    }
}

//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    if ([segue.identifier isEqualToString:@"writeDiary"]) {
//        WriteViewController *vc=segue.destinationViewController;
//        vc.superVC = self;
//    }else if([segue.identifier isEqualToString:@"writeEssay"]){
//        
//    }else if ([segue.identifier isEqualToString:@"writeWord"]){
//        
//    }
//}
- (IBAction)cancelButtonClick:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    [self dismissViewControllerAnimated:YES completion:nil];
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
