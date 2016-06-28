//
//  UIView+Extra.h
//  WEIXUE_IOS
//
//  Created by apple on 15/4/30.
//  Copyright (c) 2015年 李重阳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extra)
/**
 *  可以直接设置 x,y,center .width ,height ,size,origin 的 大小
 *  加快开发速度 
 */

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize  size;
@property (nonatomic, assign) CGPoint origin;

/*
 *新增
 */
- (CGFloat)max_Y;
- (CGFloat)max_X;
- (CGFloat)min_Y;
- (CGFloat)min_X;

@end
