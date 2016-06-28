//
//  ViewController.m
//  优化滑动
//
//  Created by apple on 16/6/28.
//  Copyright © 2016年 李重阳. All rights reserved.
//

#import "ViewController.h"
#import "TableViewVC1.h"
#import "TableViewVC2.h"
#import "WXSectionView.h"

#define KScreenH [UIScreen mainScreen].bounds.size.height
#define KScreenW [UIScreen mainScreen].bounds.size.width
#define KNavH   64.0

static const NSInteger addTag = 1000;

@interface ViewController ()<WXTableViewControllerDelegate,WXTableViewControllerDataSource,WXSectionViewDelegate,UIScrollViewDelegate>

@property (nonatomic,strong) UILabel * navView;

@property (nonatomic,strong) UIView * headerView;
@property (nonatomic,strong) WXSectionView * segmentView;
@property (nonatomic,strong) UIScrollView * baseScrollView;




/* tableView 滚动的时候的偏移量 **/
@property (nonatomic,assign) CGFloat maxTableViewOffsetY; //最大的偏移量
@property (nonatomic,assign) CGFloat minTableViewOffsetY;// 最少的偏移量

@end

@implementation ViewController

#pragma mark ----------------  VC生命周期  ------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*初始化视图**/
    [self setupSubViews];
    /* 初始化 子控制器 **/
    [self setupChildVCs];
    
    
}
#pragma mark ----------------    代理      ------------------

#pragma mark - WXTableViewController 交互的代理 和 数据的代理

- (void)wxTableViewDidScrollWithTableViewVC:(WXTableViewController *)tableViewVC {
    
    // 获取当前偏移量
    CGFloat offsetY = tableViewVC.tableView.contentOffset.y;
    // 获取偏移量差值
    CGFloat delta = offsetY - tableViewVC.preOffsetY;
    NSLog(@"offsetY = %f,delta = %f",offsetY,delta);
    /* 记录上一个值 **/
    tableViewVC.preOffsetY = offsetY;
    
    NSLog(@"offsetY = %f,min = %f,max = %f",offsetY,self.minTableViewOffsetY,self.maxTableViewOffsetY);
    /*
     //offsetY 默认是segment 的maxY 值 = 264
     //1.当往上滑动的时候，偏移量的值是增加的 eg：-264 、-250、-(导航高度 +segmentH)，当增加到 -(64+segmentH) +x 的时候我们需要判断 不能再大了
     //2.当往下滑动的时候，偏移量是减少的 从 0、-100、-150、-264（也就是刚开始的segment 的maxY 值） ，这是就不能再减少了
     **/
    
    if (offsetY >= -self.minTableViewOffsetY) {
        
        _segmentView.y = self.minTableViewOffsetY - _segmentView.height;
        
    }else if (offsetY <= -self.maxTableViewOffsetY ) {
        
        _segmentView.y = self.maxTableViewOffsetY - _segmentView.height;
        
    }else {
        _segmentView.y -= delta;
    }
    _headerView.y = _segmentView.y - _headerView.height;
    
    // 计算透明度
    /*
     * alpha的间距 其实就是 初始的segment 的maxY - 导航条的 =》(self.maxTableViewOffsetY - self.minTableViewOffsetY)
     * 变量就是 segment的 y值 到 导航的距离
     **/
    CGFloat alpha = 1- (_segmentView.y - self.navView.height) / (self.maxTableViewOffsetY - self.minTableViewOffsetY);
    self.navView.alpha = alpha;
    
}

- (CGFloat)wxTableViewContentInsetTop {
    
    return self.maxTableViewOffsetY;
}

#pragma WXSectionViewDelegate
- (void)wxSectionViewSelectedIndex:(NSInteger)index {
    
    [self showSubTableViewWithIndex:index];
    
    [self.baseScrollView setContentOffset:CGPointMake(index*self.baseScrollView.width, 0) animated:YES];
    
}

#pragma mark - baseScrollView的delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    NSInteger index = (NSInteger)(scrollView.contentOffset.x/scrollView.width);
    
    [self showSubTableViewWithIndex:index];
    
    [self.segmentView setupSelectedIndex:index];
    
    
}


#pragma mark ----------------   私有方法    ------------------
 /*初始化视图**/
- (void)setupSubViews {
    
    //baseScrollView;
    _baseScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, KScreenH)];
    _baseScrollView.delegate = self;
    _baseScrollView.pagingEnabled = YES;
    _baseScrollView.showsVerticalScrollIndicator = NO;
    _baseScrollView.showsHorizontalScrollIndicator = NO;
    _baseScrollView.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:_baseScrollView];
    
    //navView
    _navView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, KScreenW, KNavH)];
    _navView.text = @"导航条";
    _navView.backgroundColor = [UIColor grayColor];
    _navView.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_navView];
    //headerView;
    _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, 214)];
    _headerView.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:_headerView];
    //segment
    _segmentView = [[WXSectionView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(self.headerView.frame), KScreenW, 50)];
    _segmentView.backgroundColor = [UIColor blueColor];
    _segmentView.delegate = self;
    [self.view addSubview:_segmentView];
    
    self.maxTableViewOffsetY = CGRectGetMaxY(_segmentView.frame);
    self.minTableViewOffsetY = _navView.height + _segmentView.height;
    
    [self.view bringSubviewToFront:_navView];
    
}

/* 初始化 子控制器 **/
- (void)setupChildVCs {
    
    
    TableViewVC1 * vc1 = [[TableViewVC1 alloc]init];
    vc1.delegate = self;
    vc1.dataSource = self;
    [self addChildViewController:vc1];
    
    TableViewVC2 * vc2 = [[TableViewVC2 alloc]init];
    vc2.delegate = self;
    vc2.dataSource = self;
    [self addChildViewController:vc2];
    
    [self showSubTableViewWithIndex:0];
    
    self.baseScrollView.contentSize = CGSizeMake(self.segmentView.width * self.childViewControllers.count, 0);
    self.segmentView.titleArr = @[@"table1",@"table2"];
}

/* 只有在显示的时候才加入**/
- (void)showSubTableViewWithIndex:(NSInteger)index {
    
    /*切换的时候 防止 当前的tableview 还在滑动 ，然后切换后，就可能影响切换后的滑动 **/
    for (WXTableViewController * vc in self.childViewControllers) {
        vc.delegate = nil;
    }
    WXTableViewController * vc = self.childViewControllers[index];
    vc.delegate = self;
    UITableView * tableView = [self.baseScrollView viewWithTag:addTag+index];
    /* 就不用每次都添加 **/
    if (tableView == nil) {
        tableView = (UITableView *)vc.view;
        tableView.tag = addTag + index;
        tableView.frame = CGRectMake(self.baseScrollView.width * index, 0, self.baseScrollView.width, self.baseScrollView.height);
        [self.baseScrollView addSubview:tableView];
    }
    
    [self wxTableViewDidScrollWithTableViewVC:vc];
}

#pragma mark ----------------  公共方法  ------------------



#pragma mark ----------------  触发点击方法  ------------------

@end
