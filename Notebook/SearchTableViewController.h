//
//  SearchTableViewController.h
//  SearchDemo
//
//  Created by 韩金波 on 16/7/22.
//  Copyright © 2016年 Psylife. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol SearchTableViewControllerDeleagte  <NSObject>

-(void)SearchTableViewControllerClickCellForModel:(id)model;

@end
@interface SearchTableViewController : UITableViewController
@property(nonatomic,strong)NSMutableArray *array;
@property(assign,nonatomic)id<SearchTableViewControllerDeleagte>delegate;
@end
