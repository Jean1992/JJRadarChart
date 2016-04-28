![demonstrate](https://github.com/JeanKit/JJRadarChart/blob/master/demonstrate.png)

# 一款使用简单快捷的雷达图表控件, 继承于UIControl

- 数据源方法dataSource (必须实现)




- - 一共有多少数据




- - - -(NSInteger)numberOfItemsInRadarChart:(JJRadarChart*)radarChart;




- - 每组数据最大值




- - - -(NSInteger)radarChart:(JJRadarChart*)radarChart maxCountAtIndex:(NSInteger)index;




- - 每组数据当前数值




- - - -(NSInteger)radarChart:(JJRadarChart*)radarChart rankAtIndex:(NSInteger)index;




- - 每组数据标题




- - - -(NSString*)radarChart:(JJRadarChart *)radarChart titleOfItemAtIndex:(NSInteger)index;


 

 

- 代理方法delegate (可选)




- - 正多边形的所有顶点




- - - -(void)radarChart:(JJRadarChart*)radarChart didDisplayMaxPoint:(CGPoint)point atIndex:):(NSInteger)index;




- - 每组数据当前数值所在的点




- - - -(void)radarChart:(JJRadarChart*)radarChart didDisplayCurrentPoint:(CGPoint)point atIndex:(NSInteger)index;




- - 点击每组数据的标题




- - - -(void)radarChart:(JJRadarChart*)radarChart didSelectedItemAtIndex:(NSInteger)index;




- Method对象方法




- - 更新数据




- - - -(void)reloadData;




- - 取出序号对应的标题按钮




- - - -(UIButton*)radarItemAtIndex:(NSInteger)index;




- - 取出序号对应的值的百分比
  - - (CGFloat)percentageAtIndex:(NSInteger)index;


 

 

 