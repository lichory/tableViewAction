//
//  WXTableViewController.h
//  优化滑动
//
//  Created by apple on 16/6/28.
//  Copyright © 2016年 李重阳. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WXTableViewController;

/* 交互的代理 **/
@protocol WXTableViewControllerDelegate <NSObject>

@optional
/* 滚动的代理 **/
- (void)wxTableViewDidScrollWithTableViewVC:(WXTableViewController *)tableViewVC;

@end


/* 数据的代理**/
@protocol WXTableViewControllerDataSource <NSObject>

@optional
//tableView的 内容偏移量是
- (CGFloat)wxTableViewContentInsetTop;

@end


@interface WXTableViewController : UITableViewController


@property (nonatomic,weak) id<WXTableViewControllerDelegate> delegate;
@property (nonatomic,weak) id<WXTableViewControllerDataSource>dataSource;

@property (nonatomic,assign) CGFloat preOffsetY;

@end
