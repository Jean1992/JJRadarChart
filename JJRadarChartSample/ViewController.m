//
//  ViewController.m
//  JJRadarChartSample
//
//  Created by 四威 on 16/4/26.
//  Copyright © 2016年 JeanLeo. All rights reserved.
//

#import "ViewController.h"
#import "JJRadarChart.h"

void msg(NSString *message) {
    [[[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
}

@interface ViewController () <JJRadarChartDataSource, JJRadarChartDelegate> {
    JJRadarChart *chart;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //根据frame创建雷达图表
    chart = [[JJRadarChart alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width)];
    chart.center = CGPointMake(half(self.view.frame.size.width), half(self.view.frame.size.height));
    //设置数据源
    chart.dataSource = self;
    //设置代理
    chart.delegate = self;
    //添加控件
    [self.view addSubview:chart];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(50, 50, 60, 30)];
    [btn setTitle:@"刷新" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor orangeColor];
    [btn addTarget:self action:sel_registerName("btnClick") forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}
- (void)btnClick {
    //刷新图表数据
    [chart reloadData];
}
#pragma mark - JJRadarChartDataSource
- (NSInteger)numberOfItemsInRadarChart:(JJRadarChart *)radarChart {
    //一共6组, 模拟
    return 6;
}
- (NSInteger)radarChart:(JJRadarChart *)radarChart maxCountAtIndex:(NSInteger)index {
    //每组最大100, 模拟
    return 100;
}
- (NSInteger)radarChart:(JJRadarChart *)radarChart rankAtIndex:(NSInteger)index {
    //随机数, 模拟数据
    NSInteger randNum = arc4random_uniform(94);
    return index + randNum;
}
- (NSString *)radarChart:(JJRadarChart *)radarChart titleOfItemAtIndex:(NSInteger)index {
    //模拟数据
    NSArray *arr = @[@"公交", @"食宿", @"日用", @"娱乐", @"购物", @"其他"];
    return arr[index];
}
#pragma mark - JJRadarChartDelegate
- (void)radarChart:(JJRadarChart *)radarChart didDisplayCurrentPoint:(CGPoint)point atIndex:(NSInteger)index {
//    NSLog(@"当前%zd点在%@", index, NSStringFromCGPoint(point));
}
- (void)radarChart:(JJRadarChart *)radarChart didDisplayMaxPoint:(CGPoint)point atIndex:(NSInteger)index {
//    NSLog(@"最大%zd点在%@", index, NSStringFromCGPoint(point));
}
- (void)radarChart:(JJRadarChart *)radarChart didSelectedItemAtIndex:(NSInteger)index {
    //取出对应序号的item
    UIButton *btn = [radarChart radarItemAtIndex:index];
    //取出对应序号当前数值百分比
    CGFloat percentage = [radarChart percentageAtIndex:index];
    //取出对应序号的总数和当前数
    JJRadarChartRankInfo info = [radarChart rankInfoAtIndex:index];
    //拼接字符串
    NSString *msgStr = [NSString stringWithFormat:@"最大%@为%zd, 当前%@为%zd, 占%.0f%%", btn.titleLabel.text, info.totalNumber, btn.titleLabel.text, info.currentNumber, percentage];
    //弹窗显示
    msg(msgStr);
}
@end
