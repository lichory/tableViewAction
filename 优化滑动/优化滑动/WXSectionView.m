//
//  WXSectionView.m
//  tableView_huadong
//
//  Created by apple on 16/6/27.
//  Copyright © 2016年 李重阳. All rights reserved.
//

#import "WXSectionView.h"
static const NSInteger addTag = 1000;

@interface WXSectionView ()

@property (nonatomic,strong) UIView * lineView;
@property (nonatomic,strong) UIColor * selectedColor;
@property (nonatomic,strong) UIColor * normalColor;

@property (nonatomic,strong) UIScrollView * baseScrollView;

@end


@implementation WXSectionView

#pragma mark - 生命周期
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.selectedColor = [UIColor redColor];
        self.normalColor  = [UIColor blackColor];
        
        [self addSubview:self.baseScrollView];
        
        [self.baseScrollView addSubview:self.lineView];
    }
    return self;
}

#pragma mark - 私有方法
- (void)tapClick:(UITapGestureRecognizer *)tap {
    
    NSInteger index = tap.view.tag - addTag;
    [self setupSelectedIndex:index];
    
    if ([self.delegate respondsToSelector:@selector(wxSectionViewSelectedIndex:)]) {
        [self.delegate wxSectionViewSelectedIndex:index];
    }
    
}

/* 滑动到 某个地方 **/
- (void)setupSelectedIndex:(NSInteger)index {
    
    for (UILabel * label in self.baseScrollView.subviews) {
        if ([label isKindOfClass:[UILabel class]]) {
            
            if (label.tag == index+addTag) {
                label.textColor = self.selectedColor;
                [self lineViewScrollToIndex:index];
            }else {
                label.textColor = self.normalColor;
            }
        }
    }
}

/* 底部的线 滑动到 某个地方 **/
- (void)lineViewScrollToIndex:(NSInteger)index {
    
    [UIView animateWithDuration:0.3 animations:^{
        
        [self setLineViewFrameWithIndex:index];
        //self.lineView.x = index*self.lineView.width;
        
    }completion:^(BOOL finished) {
        
        CGPoint point = self.baseScrollView.contentOffset;
        CGPoint lineViewToSelfPoint = [self.lineView.superview convertPoint:self.lineView.center toView:self];
        //把当前的滑动到中心点的距离
        CGFloat toScrollViewCenter = lineViewToSelfPoint.x - self.center.x;
        if (toScrollViewCenter <0) {//要向右边滑动contentOffset.x >=0
            // 这里表示scrollView向右滑动
            point.x += toScrollViewCenter;
            // 但是向右滑动不能小于0，否则将会出现第一个 也向右偏移
            if (point.x <0) {
                point.x = 0;
            }
        }else {//向左滑动 contentOffset.x <= relationValue
            //这里表示向左滑动
            //这个是最大的偏移X量
            CGFloat maxOffX = self.baseScrollView.contentSize.width - self.baseScrollView.width;
            point.x += toScrollViewCenter;
            // 如果向左滑动超出了它的最大偏移量
            if (point.x>maxOffX) {
                point.x = maxOffX;
            }
            
        }
        [self.baseScrollView setContentOffset:point animated:YES];
    }];
    
}


#pragma mark - get 方法

- (UIScrollView *)baseScrollView {
    
    if (_baseScrollView == nil) {
        
        _baseScrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
        _baseScrollView.showsHorizontalScrollIndicator = NO;
        _baseScrollView.showsVerticalScrollIndicator = NO;
        
    }
    return _baseScrollView;
    
}

- (UIView *)lineView {
    
    if (_lineView == nil) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = self.selectedColor;
    }
    return _lineView;
}

/* 根据 字的大小 来显示 lineView的宽度 **/
- (void)setLineViewFrameWithIndex:(NSInteger)index {
    
    NSString * text = self.titleArr[index];
    UILabel * label = [self.baseScrollView viewWithTag:addTag+index];
    CGSize textSize = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT)
                                         options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                      attributes:@{NSFontAttributeName:label.font}
                                         context:nil].size;
    self.lineView.width = textSize.width;
    self.lineView.centerX = label.centerX;
    
}



#pragma mark - 公共方法
- (void)setTitleArr:(NSArray *)items {
    
    _titleArr = items;
    CGFloat lineH = 2;
    CGFloat baseLineH = 1;
    NSInteger tempCount = items.count>=4?4:items.count;
    CGFloat itemW = self.width/tempCount;
    
    CGFloat itemH = self.frame.size.height - lineH - baseLineH;
    for (NSInteger i = 0; i<items.count; i++) {
        
        NSString * title = items[i];
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(i*itemW, 0, itemW, itemH)];
        label.userInteractionEnabled = YES;
        label.textAlignment = NSTextAlignmentCenter;
        label.tag  = i+addTag;
        label.text = title;
        label.font = [UIFont systemFontOfSize:15];
        //label.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1];
        if (i == 0) {//默认第一个
            label.textColor = self.selectedColor;
        }else {
            label.textColor = self.normalColor;
        }
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
        [label addGestureRecognizer:tap];
        [self.baseScrollView addSubview:label];
    }
    
    self.lineView.y = itemH;
    self.lineView.height = lineH;
    [self setLineViewFrameWithIndex:0];
    
    self.baseScrollView.contentSize = CGSizeMake(items.count*itemW, 0);
    
}


@end
