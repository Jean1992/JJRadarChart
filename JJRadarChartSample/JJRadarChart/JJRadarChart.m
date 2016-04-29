//
//  JJRadarChart.m
//  JJRadarChartSample
//
//  Created by 四威 on 16/4/26.
//  Copyright © 2016年 JeanLeo. All rights reserved.
//

#import "JJRadarChart.h"


JJRadarChartRankInfo JJRadarChartRankInfoMake(NSInteger totalNumber, NSInteger currentNumber) {
    JJRadarChartRankInfo info;
    info.totalNumber = totalNumber;
    info.currentNumber = currentNumber;
    return info;
}
CGFloat half(CGFloat floatValue) {
    return floatValue * 0.5;
}
UIColor* colorRGB(CGFloat r, CGFloat g, CGFloat b) {
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1];
}

#define c1 colorRGB(66,87,214) //样式随便搞, 赶着实现功能随便搞
//#define c2 colorRGB(78,111,204)
//#define c3 colorRGB(85,120,204)
#define c2 colorRGB(105,136,207)
//#define c5 colorRGB(115,147,218)
#define c4 colorRGB(152,175,229)
#define c3 colorRGB(180,200,245)

@interface JJRadarChart () {
    NSInteger _itemsNumber;
    NSMutableArray *_arrayMaxCounts;
    NSMutableArray *_arrayRanks;
    CGFloat tWH;
    CGContextRef ctx;
    CGFloat maxRadius;
}
@end

@implementation JJRadarChart

#pragma mark - struct
- (instancetype)init {
    if (self = [super init]) {
        [self initialize];
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initialize];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if ( self = [super initWithFrame:frame]) {
        [self initialize];
    }
    return self;
}
- (void)initialize {
    self.backgroundColor = [UIColor clearColor];
}
#pragma mark - setter
- (void)setDataSource:(id<JJRadarChartDataSource>)dataSource {
    _dataSource = dataSource;
    [self resetData];
}
#pragma mark - superMethod

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, rect);
    maxRadius = half(self.frame.size.height) * 0.6;
    tWH = half(self.frame.size.height) * 0.35;
    CGFloat margin = maxRadius / 3;
    CGFloat fixedMargin = margin;
    [self drawPolygonWithRadius:maxRadius color:c3 isMain:true];
    [self drawPolygonWithRadius:maxRadius - margin color:c2 isMain:false];
    margin += fixedMargin;
    [self drawPolygonWithRadius:maxRadius - margin color:c1 isMain:false];
//    margin += fixedMargin;
//    [self drawPolygonWithRadius:maxRadius - margin color:c4];
//    margin += fixedMargin;
//    [self drawPolygonWithRadius:maxRadius - margin color:c5];
//    margin += fixedMargin;
//    [self drawPolygonWithRadius:maxRadius - margin color:c6];
//    margin += fixedMargin;
//    [self drawPolygonWithRadius:maxRadius - margin color:c7];
    
    [self drawLine];
}
#pragma mark - function
- (void)resetData {
    _arrayMaxCounts = [NSMutableArray array];
    _arrayRanks = [NSMutableArray array];
    _itemsNumber = 0;
    if ([_dataSource respondsToSelector:@selector(numberOfItemsInRadarChart:)]) {
        _itemsNumber = [_dataSource numberOfItemsInRadarChart:self];
    }
    if ([_dataSource respondsToSelector:@selector(radarChart:maxCountAtIndex:)]) {
        for (NSInteger i = 0; i < _itemsNumber; i++) {
            NSNumber *maxCount = @([_dataSource radarChart:self maxCountAtIndex:i]);
            [_arrayMaxCounts addObject:maxCount];
        }
    }
    if ([_dataSource respondsToSelector:@selector(radarChart:rankAtIndex:)]) {
        for (NSInteger i = 0; i < _itemsNumber; i++) {
            NSNumber *rank = @([_dataSource radarChart:self rankAtIndex:i]);
            [_arrayRanks addObject:rank];
        }
    }
}
- (void)reloadData {
    [self resetData];
    [self setNeedsDisplay];
}

- (void)drawPolygonWithRadius:(CGFloat)radius color:(UIColor *)color isMain:(BOOL)isMain{
    //获取上下文
    NSInteger num = _itemsNumber;
    CGFloat x = half(self.frame.size.width);
    CGFloat y = half(self.frame.size.height);
    ctx = UIGraphicsGetCurrentContext();
    [color setFill];
    CGContextSetLineWidth(ctx, 2);
    CGContextMoveToPoint(ctx, x + radius, y);
    NSMutableArray *topPionts = [NSMutableArray array];
    for (NSInteger i = 1; i <= num; i++) {
        //计算顶点的位置
        CGPoint point = CGPointMake(x + radius * cos( 2 * M_PI * i / num), y + radius * sin(2 * M_PI * i / num));
        [topPionts addObject:[NSValue valueWithCGPoint:point]];
        if (isMain) {
            if ([self.delegate respondsToSelector:@selector(radarChart:didDisplayMaxPoint:atIndex:)]) {
                [self.delegate radarChart:self didDisplayMaxPoint:point atIndex:i - 1];
            }
            //演示用, 不喜欢可以去掉
//            UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
//            lbl.layer.cornerRadius = half(lbl.frame.size.width);
//            lbl.layer.masksToBounds = true;
//            lbl.backgroundColor = [UIColor orangeColor];
//            lbl.textColor = [UIColor whiteColor];
//            lbl.center = point;
//            lbl.text = [NSString stringWithFormat:@"%zd", i - 1];
//            lbl.textAlignment = NSTextAlignmentCenter;
//            [self addSubview:lbl];
        }
        //连线
        CGContextAddLineToPoint(ctx, point.x, point.y);
    }
    CGContextFillPath(ctx);
    NSMutableArray *itemCenters = [NSMutableArray array];
    for (NSInteger i = 0; i < topPionts.count; i++) {
        ctx = UIGraphicsGetCurrentContext();
        [c4 setStroke];
        CGContextSetLineWidth(ctx, 2);
        CGContextMoveToPoint(ctx, x, y);
        NSValue *vPoint = topPionts[i];
        CGPoint point = vPoint.CGPointValue;
        CGPoint itemCenter;
        if (isMain) {
            if (point.x == x && point.y == y - maxRadius) {//正上方
                itemCenter = CGPointMake(point.x, point.y - half(tWH));
            }else if (point.x == x && point.y == y + maxRadius) {//正下方
                itemCenter = CGPointMake(point.x, point.y + half(tWH));
            }else if (point.y == y && point.x == x - maxRadius) {//正左方
                itemCenter = CGPointMake(point.x - half(tWH), point.y);
            }else if (point.y == y && point.x == x + maxRadius) {//正右方
                itemCenter = CGPointMake(point.x + half(tWH), point.y);
            }else if (point.x < x && point.x > x - maxRadius && point.y < y && point.y > y - maxRadius) {//左上
                itemCenter = CGPointMake(point.x - half(tWH), point.y - half(tWH));
            }else if (point.x > x && point.x < x + maxRadius && point.y < y && point.y > y - maxRadius) {//右上
                itemCenter = CGPointMake(point.x + half(tWH), point.y - half(tWH));
            }else if (point.x < x && point.x > x - maxRadius && point.y > y && point.y < y + maxRadius) {//左下
                itemCenter = CGPointMake(point.x - half(tWH), point.y + half(tWH));
            }else if (point.x > x && point.x < x + maxRadius && point.y > y && point.y < y + maxRadius) {//右下
                itemCenter = CGPointMake(point.x + half(tWH), point.y + half(tWH));
            }else {
                itemCenter = CGPointMake(point.x + half(tWH), point.y - half(tWH));
            }
            [itemCenters addObject:[NSValue valueWithCGPoint:itemCenter]];
        }
        CGContextAddLineToPoint(ctx, point.x, point.y);
        CGContextStrokePath(ctx);
    }
    
    for (NSInteger i = 0; i < itemCenters.count; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, tWH, tWH)];
        btn.tag = 200 + i;
        NSValue *pValue = itemCenters[i];
        CGPoint bCenter = pValue.CGPointValue;
        btn.center = bCenter;
        [btn setBackgroundColor:[UIColor clearColor]];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        if ([_dataSource respondsToSelector:@selector(radarChart:titleOfItemAtIndex:)]) {
            [btn setTitle:[_dataSource radarChart:self titleOfItemAtIndex:i] forState:UIControlStateNormal];
        }
        [btn.titleLabel setFont:[UIFont systemFontOfSize:16 weight:UIFontWeightBold]];
        [self addSubview:btn];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}
- (void)btnClick:(UIButton *)btn {
    if ([_delegate respondsToSelector:@selector(radarChart:didSelectedItemAtIndex:)]) {
        [_delegate radarChart:self didSelectedItemAtIndex:btn.tag - 200];
    }
}
- (void)drawLine {
    CGFloat radius;
    NSInteger num = _itemsNumber;
    CGFloat x = half(self.frame.size.width);
    CGFloat y = half(self.frame.size.height);
    ctx = UIGraphicsGetCurrentContext();
    [colorRGB(255, 200, 0) setFill];
    CGContextSetAlpha(ctx, 0.6);
    CGContextSetLineWidth(ctx, 3);
    radius = maxRadius / ((NSNumber *)_arrayMaxCounts.lastObject).integerValue * ((NSNumber *)_arrayRanks.lastObject).integerValue;
    CGContextMoveToPoint(ctx, x + radius, y);
    for (NSInteger i = 1; i <= num; i++) {
        radius = maxRadius / ((NSNumber *)_arrayMaxCounts[i - 1]).integerValue * ((NSNumber *)_arrayRanks[i - 1]).integerValue;
        //计算当前点的位置
        CGPoint point = CGPointMake(x + radius * cos( 2 * M_PI * i / num), y + radius * sin(2 * M_PI * i / num));
        if ([self.delegate respondsToSelector:@selector(radarChart:didDisplayCurrentPoint:atIndex:)]) {
            [self.delegate radarChart:self didDisplayCurrentPoint:point atIndex:i - 1];
        }
        //连线
        CGContextAddLineToPoint(ctx, point.x, point.y);
    }
    CGContextFillPath(ctx);
    
//    ctx = UIGraphicsGetCurrentContext();
//    [colorRGB(255, 178, 0) setStroke];
//    CGContextSetLineWidth(ctx, 3);
//    radius = maxRadius / ((NSNumber *)_arrayMaxCounts.lastObject).integerValue * ((NSNumber *)_arrayRanks.lastObject).integerValue;
//    CGContextMoveToPoint(ctx, x + radius, y);
//    for (NSInteger i = 1; i <= num; i++) {
//        radius = maxRadius / ((NSNumber *)_arrayMaxCounts[i - 1]).integerValue * ((NSNumber *)_arrayRanks[i - 1]).integerValue;
//        //计算当前点的位置
//        CGPoint point = CGPointMake(x + radius * cos( 2 * M_PI * i / num), y + radius * sin(2 * M_PI * i / num));
//        //连线
//        CGContextAddLineToPoint(ctx, point.x, point.y);
//    }
//    CGContextStrokePath(ctx);
}
- (UIButton *)radarItemAtIndex:(NSInteger)index {
    UIButton *btn = (UIButton *)[self viewWithTag:200 + index];
    return btn;
}
- (CGFloat)percentageAtIndex:(NSInteger)index {
    NSNumber *max = _arrayMaxCounts[index];
    NSNumber *cur = _arrayRanks[index];
    CGFloat maxF = max.floatValue, curF = cur.floatValue;
    CGFloat percentage = curF / maxF * 100;
    return percentage;
}
- (JJRadarChartRankInfo)rankInfoAtIndex:(NSInteger)index {
    NSInteger total = ((NSNumber *)_arrayMaxCounts[index]).integerValue;
    NSInteger current = ((NSNumber *)_arrayRanks[index]).integerValue;
    return JJRadarChartRankInfoMake(total, current);
}
@end
