//
//  ViewController.m
//  YYCache_Copy
//
//  Created by 张楷鸿 on 2020/6/17.
//  Copyright © 2020 张楷鸿. All rights reserved.
//

#import "ViewController.h"

static NSString * const Cell_Id = @"cellId";

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation ViewController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Home";
    
    self.tableView = ({
        UITableView *tableV = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        tableV.dataSource = self;
        tableV.delegate = self;
        tableV.rowHeight = 60;
        tableV.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        [tableV registerClass:UITableViewCell.class forCellReuseIdentifier:Cell_Id];
        [self.view addSubview:tableV];
        tableV;
    });
}


#pragma mark - UITableViewDataSource && UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Cell_Id];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Cell_Id];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"第 %ld 行", indexPath.row];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
