//
//  WXSectionView.h
//  tableView_huadong
//
//  Created by apple on 16/6/27.
//  Copyright © 2016年 李重阳. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WXSectionViewDelegate <NSObject>

- (void)wxSectionViewSelectedIndex:(NSInteger)index;

@end

@interface WXSectionView : UIView

@property (nonatomic,copy) NSArray * titleArr;

@property (nonatomic,weak) id <WXSectionViewDelegate>delegate;

/* 滑动到 某个地方 **/
- (void)setupSelectedIndex:(NSInteger)index;

@end
