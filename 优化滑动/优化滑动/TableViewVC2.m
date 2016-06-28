//
//  TableViewVC2.m
//  优化滑动
//
//  Created by apple on 16/6/28.
//  Copyright © 2016年 李重阳. All rights reserved.
//

#import "TableViewVC2.h"

@interface TableViewVC2 ()

@end

@implementation TableViewVC2

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"vc_2_%@",@(indexPath.row)];
    return cell;
}

@end
