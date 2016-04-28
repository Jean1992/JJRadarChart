//
//  JJRadarChart.h
//  JJRadarChartSample
//
//  Created by 四威 on 16/4/26.
//  Copyright © 2016年 JeanLeo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JJRadarChart;
/**
 *  数据源方法(必须实现)
 */
@protocol JJRadarChartDataSource <NSObject>
@required
/**
 *  一共多少组数据
 *
 *  @param radarChart 控件本身
 *
 *  @return 组数
 */
- (NSInteger)numberOfItemsInRadarChart:(JJRadarChart *)radarChart;
/**
 *  某一组最大数值(整形)
 *
 *  @param index      该组序号
 *  @param radarChart 控件本身
 *
 *  @return 数值
 */
- (NSInteger)radarChart:(JJRadarChart *)radarChart maxCountAtIndex:(NSInteger)index;
/**
 *  某一组当前数值
 *
 *  @param index      该组序号
 *  @param radarChart 控件本身
 *
 *  @return 数值
 */
- (NSInteger)radarChart:(JJRadarChart *)radarChart rankAtIndex:(NSInteger)index;
/**
 *  某一组数据的标题
 *
 *  @param radarChart 控件自身
 *  @param index      该组序号
 *
 *  @return 标题
 */
- (NSString *)radarChart:(JJRadarChart *)radarChart titleOfItemAtIndex:(NSInteger)index;
@end

/**
 *  代理方法(可选)
 */
@protocol JJRadarChartDelegate <NSObject>
@optional
/**
 *  正多边形的某一个顶点
 *
 *  @param radarChart 控件本身
 *  @param point      顶点值(CGPoint)
 *  @param index      对应序号
 */
- (void)radarChart:(JJRadarChart *)radarChart didDisplayMaxPoint:(CGPoint)point atIndex:(NSInteger)index;
/**
 *  某一组的当前数值所在点
 *
 *  @param radarChart 控件本身
 *  @param point      所在点点值(CGPoint)
 *  @param index      对应序号
 */
- (void)radarChart:(JJRadarChart *)radarChart didDisplayCurrentPoint:(CGPoint)point atIndex:(NSInteger)index;
/**
 *  某一组数据标题被选中
 *
 *  @param radarChart 控件本身
 *  @param index      对应序号
 */
- (void)radarChart:(JJRadarChart *)radarChart didSelectedItemAtIndex:(NSInteger)index;
@end

/**
 *  取半方法
 *
 *  @param floatValue 浮点型
 *
 *  @return 取半结果
 */
CGFloat half(CGFloat floatValue);
/**
 *  根据rgb生成颜色
 *
 *  @param r red
 *  @param g green
 *  @param b blue
 *
 *  @return 结果颜色
 */
UIColor* colorRGB(CGFloat r, CGFloat g, CGFloat b);

@interface JJRadarChart : UIControl

//数据源属性
@property (nonatomic, weak) id<JJRadarChartDataSource>dataSource;
//代理属性
@property (nonatomic, weak) id<JJRadarChartDelegate>delegate;

/**
 *  更新数据, 刷新视图
 */
- (void)reloadData;
/**
 *  取出对应序号的item
 *
 *  @param index 序号
 *
 *  @return UIButton类型
 */
- (UIButton *)radarItemAtIndex:(NSInteger)index;
/**
 *  取出对应序号的百分比值
 *
 *  @param index 序号
 *
 *  @return 数值
 */
- (CGFloat)percentageAtIndex:(NSInteger)index;

@end
