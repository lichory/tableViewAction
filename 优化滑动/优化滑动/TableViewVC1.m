//
//  TableViewVC1.m
//  优化滑动
//
//  Created by apple on 16/6/28.
//  Copyright © 2016年 李重阳. All rights reserved.
//

#import "TableViewVC1.h"

@interface TableViewVC1 ()

@end

@implementation TableViewVC1

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
     cell.textLabel.text = [NSString stringWithFormat:@"vc_1_%@",@(indexPath.row)];
     return cell;
 }


@end
