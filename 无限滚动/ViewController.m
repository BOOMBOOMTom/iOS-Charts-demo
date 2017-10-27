//
//  ViewController.m
//

#import "ViewController.h"
#import "SymbolsValueFormatter.h"
#import "DateValueFormatter.h"
#import "SetValueFormatter.h"
#import "BarValueFormatter.h"
#define screenWidth  [[UIScreen mainScreen] bounds].size.width
#define screenHeight [[UIScreen mainScreen] bounds].size.height

@import Charts;
@interface ViewController ()<ChartViewDelegate>
@property (nonatomic,strong) LineChartView * lineView;
@property (nonatomic,strong) BarChartView * barView;
@property (nonatomic,strong) PieChartView * pieView;
@property (nonatomic,strong) RadarChartView * radarView;
@property (nonatomic,strong) UILabel * markY;
@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIScrollView *sv = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    sv.contentSize = CGSizeMake(0, 1400);
    sv.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:sv];
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 20)];
    button.backgroundColor = [UIColor redColor];
    [button addTarget:self action:@selector(changeUpdate) forControlEvents:UIControlEventTouchUpInside];
    [sv addSubview:button];
    
    //折线图
    [sv addSubview:self.lineView];
    self.lineView.data = [self setData];
    //柱状图
    [sv addSubview:self.barView];
    self.barView.data  = [self setBarData];
    //饼状图
    [sv addSubview:self.pieView];
    self.pieView.data = [self setPieData];
    //雷达图
    [sv addSubview:self.radarView];
    self.radarView.data = [self setRadarData];
    [self.radarView renderer];
}

- (void)changeUpdate{
    self.lineView.data = [self setData];
    [self.lineView animateWithYAxisDuration:2.0];
}

- (UILabel *)markY{
    if (!_markY) {
        _markY = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 35, 25)];
        _markY.font = [UIFont systemFontOfSize:15.0];
        _markY.textAlignment = NSTextAlignmentCenter;
        _markY.text =@"";
        _markY.textColor = [UIColor whiteColor];
        _markY.backgroundColor = [UIColor grayColor];
    }
    return _markY;
}

#pragma mark 柱状图
- (BarChartView *)barView{
    
    if (!_barView) {
        _barView = [[BarChartView alloc] initWithFrame:CGRectMake(0, 400, screenWidth, 300)];
        _barView.delegate = self;
        _barView.chartDescription.enabled = NO; //------
        _barView.legend.enabled = NO; //-------
        _barView.noDataText = @"暂无数据";//没有数据时的文字提示
        _barView.drawValueAboveBarEnabled = YES;//数值显示在柱形的上面还是下面
        _barView.drawBarShadowEnabled = NO;//是否绘制柱形的阴影背景
        
        //交互设置
        _barView.scaleYEnabled = NO;//取消Y轴缩放
        _barView.doubleTapToZoomEnabled = NO;//取消双击缩放
        _barView.dragEnabled = YES;//启用拖拽图表
        _barView.dragDecelerationEnabled = YES;//拖拽后是否有惯性效果
        _barView.dragDecelerationFrictionCoef = 0.9;//拖拽后惯性效果的摩擦系数(0~1)，数值越小，惯性越不明显
        
        //X轴样式
        ChartXAxis *xAxis = _barView.xAxis;
        xAxis.axisLineWidth = 1;//设置X轴线宽
        xAxis.granularityEnabled = YES;//设置重复的值不显示
        xAxis.labelCount = 10; //labeld 的个数
        xAxis.labelPosition = XAxisLabelPositionBottom;//X轴的显示位置，默认是显示在上面的
        xAxis.drawGridLinesEnabled = NO;//不绘制网格线
        xAxis.labelTextColor = [UIColor brownColor];//label文字颜色
        xAxis.axisMinimum = 0;//X轴最小值从5开始
     //   xAxis.granularity = 5; //间隔尺寸
        
        //Y轴样式
        _barView.rightAxis.enabled = NO;//不绘制右边轴
        ChartYAxis *leftAxis = _barView.leftAxis;//获取左边Y轴
        leftAxis.labelCount = 5;//Y轴label数量，数值不一定，如果forceLabelsEnabled等于YES, 则强制绘制制定数量的label, 但是可能不平均
        leftAxis.forceLabelsEnabled = NO;//不强制绘制制定数量的label
    //    leftAxis.axisMinValue = 0;//设置Y轴的最小值
   //     leftAxis.axisMaxValue = 105;//设置Y轴的最大值
        leftAxis.inverted = NO;//是否将Y轴进行上下翻转
        leftAxis.axisLineWidth = 0.5;//Y轴线宽
        leftAxis.axisMinimum = 0; //Y轴最小值从原点开始
        leftAxis.axisLineColor = [UIColor blackColor];//Y轴颜色
        leftAxis.valueFormatter = [[SymbolsValueFormatter alloc] init];//自定义格式
        leftAxis.labelPosition = YAxisLabelPositionOutsideChart;//label位置
        leftAxis.labelTextColor = [UIColor brownColor];//文字颜色
        leftAxis.labelFont = [UIFont systemFontOfSize:10.0f];//文字字体
        
        //设置动画效果，可以设置X轴和Y轴的动画效果
        [_barView animateWithYAxisDuration:2.0f];
    }
    return _barView;
}
- (BarChartData *)setBarData{ 
    
    NSInteger xVals_count = 20;//X轴上要显示多少条数据
    //X轴上面需要显示的数据
    NSMutableArray *xVals = [[NSMutableArray alloc] init];
    
    for (int i = 1; i <= xVals_count; i++) {
        if (i<10) {
            [xVals addObject: [NSString stringWithFormat:@"02-%d",i]];
        }else{
            [xVals addObject: [NSString stringWithFormat:@"03-%d",i-19]];
        }
    }
    _barView.xAxis.valueFormatter = [[DateValueFormatter alloc]initWithArr:xVals];
    //对应Y轴上面需要显示的数据
    NSMutableArray *yVals = [[NSMutableArray alloc] init];
    for (int i = 0; i < xVals_count; i++) {
        int a = arc4random() % 100;
        BarChartDataEntry *entry = [[BarChartDataEntry alloc] initWithX:i y:a];
        [yVals addObject:entry];
    }
    
    BarChartDataSet *set = [[BarChartDataSet alloc]initWithValues:yVals label:nil];
    set.valueFormatter = [BarValueFormatter new];
//    [set setColor:[UIColor orangeColor]];
    set.colors = @[[UIColor greenColor],[UIColor orangeColor],[UIColor blueColor],[UIColor grayColor],[UIColor yellowColor]];
    [_barView zoomWithScaleX:0 scaleY:0 x:0 y:0];
    BarChartData *data = [[BarChartData alloc]initWithDataSet:set];
    
    [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:11.f]];//文字字体
    [data setValueTextColor:[UIColor blackColor]];//文字颜色
    return data;
}

#pragma mark 折线图
- (LineChartView *)lineView {
    if (!_lineView) {
        _lineView = [[LineChartView alloc] initWithFrame:CGRectMake(0, 50, screenWidth, 300)];
        _lineView.delegate = self;//设置代理
        _lineView.backgroundColor =  [UIColor whiteColor];
        _lineView.noDataText = @"暂无数据";
        _lineView.chartDescription.enabled = YES;
        _lineView.scaleYEnabled = NO;//取消Y轴缩放
        _lineView.doubleTapToZoomEnabled = NO;//取消双击缩放
        _lineView.dragEnabled = YES;//启用拖拽图标
        _lineView.dragDecelerationEnabled = YES;//拖拽后是否有惯性效果
        _lineView.dragDecelerationFrictionCoef = 0.9;//拖拽后惯性效果的摩擦系数(0~1)，数值越小，惯性越不明显
        
        //设置滑动时候标签
        ChartMarkerView *markerY = [[ChartMarkerView alloc] init];
        markerY.offset = CGPointMake(-999, -8);
        markerY.chartView = _lineView;
        _lineView.marker = markerY;
        [markerY addSubview:self.markY];
        
        _lineView.rightAxis.enabled = NO;//不绘制右边轴
        ChartYAxis *leftAxis = _lineView.leftAxis;//获取左边Y轴
        leftAxis.labelCount = 5;//Y轴label数量，数值不一定，如果forceLabelsEnabled等于YES, 则强制绘制制定数量的label, 但是可能不平均
        leftAxis.forceLabelsEnabled = NO;//不强制绘制指定数量的label
        // leftAxis.axisMinValue = 0;//设置Y轴的最小值
        //leftAxis.axisMaxValue = 105;//设置Y轴的最大值
        leftAxis.inverted = NO;//是否将Y轴进行上下翻转
        leftAxis.axisLineColor = [UIColor orangeColor];//Y轴颜色
        leftAxis.valueFormatter = [[SymbolsValueFormatter alloc]init];
        leftAxis.labelPosition = YAxisLabelPositionOutsideChart;//label位置
        leftAxis.labelTextColor = [UIColor blackColor];//文字颜色
        leftAxis.labelFont = [UIFont systemFontOfSize:10.0f];//文字字体
        leftAxis.gridColor = [UIColor grayColor];//网格线颜色
        leftAxis.gridAntialiasEnabled = NO;//开启抗锯齿
        leftAxis.axisMinimum = 0;//Y轴最小值从原点开始
        
        ChartXAxis *xAxis = _lineView.xAxis;
        xAxis.granularityEnabled = YES;//设置重复的值不显示
        xAxis.labelPosition= XAxisLabelPositionBottom;//设置x轴数据在底部
        xAxis.gridColor = [UIColor clearColor];
        xAxis.labelTextColor = [UIColor blackColor];//文字颜色
        xAxis.axisLineColor = [UIColor orangeColor];
        xAxis.labelCount = 10;
        xAxis.axisMinimum = 0;//X轴最小值从0开始
        _lineView.maxVisibleCount = 999;//
        //描述及图例样式
        [_lineView setDescriptionText:@""];
        _lineView.legend.enabled = NO;
        
        [_lineView animateWithYAxisDuration:2.0f];
    }
    return _lineView;
}
- (LineChartData *)setData{
    NSInteger xVals_count = 50;//X轴上要显示多少条数据
    //X轴上面需要显示的数据
    NSMutableArray *xVals = [[NSMutableArray alloc] init];
    
    for (int i = 1; i <= xVals_count; i++) {
        if (i<30) {
        [xVals addObject: [NSString stringWithFormat:@"02-%d",i]];
        }else{
        [xVals addObject: [NSString stringWithFormat:@"03-%d",i-29]];
        }
    }
    _lineView.xAxis.valueFormatter = [[DateValueFormatter alloc]initWithArr:xVals];
    //对应Y轴上面需要显示的数据
    NSMutableArray *yVals = [[NSMutableArray alloc] init];
    for (int i = 0; i < xVals_count; i++) {
        int a = arc4random() % 100;
        ChartDataEntry *entry = [[ChartDataEntry alloc] initWithX:i y:a];
        [yVals addObject:entry];
    }
    
    LineChartDataSet *set1 = nil;
    if (_lineView.data.dataSetCount > 0) {
        LineChartData *data = (LineChartData *)_lineView.data;
        set1 = (LineChartDataSet *)data.dataSets[0];
        set1.values = yVals;
        set1.valueFormatter = [[SetValueFormatter alloc]initWithArr:yVals];
        return data;
    }else{
        //创建LineChartDataSet对象
        set1 = [[LineChartDataSet alloc]initWithValues:yVals label:nil];
        //设置折线的样式
        set1.lineWidth = 2.0/[UIScreen mainScreen].scale;//折线宽度
        
        set1.drawValuesEnabled = YES;//是否在拐点处显示数据
        set1.valueFormatter = [[SetValueFormatter alloc]initWithArr:yVals];
        
        set1.valueColors = @[[UIColor brownColor]];//折线拐点处显示数据的颜色
        
        [set1 setColor:[UIColor greenColor]];//折线颜色
        set1.highlightColor = [UIColor redColor];
        set1.drawSteppedEnabled = NO;//是否开启绘制阶梯样式的折线图
        //折线拐点样式
        set1.drawCirclesEnabled = NO;//是否绘制拐点
        set1.drawFilledEnabled = NO;//是否填充颜色

        //将 LineChartDataSet 对象放入数组中
        NSMutableArray *dataSets = [[NSMutableArray alloc] init];
        [dataSets addObject:set1];
        
        //添加第二个LineChartDataSet对象
        
        NSMutableArray *yVals2 = [[NSMutableArray alloc] init];
        for (int i = 0; i <  xVals_count; i++) {
            int a = arc4random() % 80;
            ChartDataEntry *entry = [[ChartDataEntry alloc] initWithX:i y:a];
            [yVals2 addObject:entry];
        }
        LineChartDataSet *set2 = [set1 copy];
        set2.values = yVals2;
        set2.drawValuesEnabled = NO;
        [set2 setColor:[UIColor blueColor]];
        
        [dataSets addObject:set2];
        //创建 LineChartData 对象, 此对象就是lineChartView需要最终数据对象
        LineChartData *data = [[LineChartData alloc]initWithDataSets:dataSets];
        
        [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:11.f]];//文字字体
        [data setValueTextColor:[UIColor blackColor]];//文字颜色
        
        
        return data;
    }
    
}

#pragma mark 饼状图
- (PieChartView *)pieView{
    
    if (!_pieView) {
        _pieView = [[PieChartView alloc]initWithFrame:CGRectMake(0, 750, screenWidth, 300)];
        //基本样式
        _pieView.noDataText = @"无数据";
        [_pieView setExtraOffsetsWithLeft:30 top:0 right:30 bottom:0];//饼状图距离边缘的间隙
        _pieView.usePercentValuesEnabled = YES;//是否根据所提供的数据, 将显示数据转换为百分比格式
        _pieView.dragDecelerationEnabled = YES;//拖拽饼状图后是否有惯性效果
        _pieView.drawSliceTextEnabled = YES;//是否显示区块文本
        //空心饼状图样式
        _pieView.drawHoleEnabled = NO;//饼状图是否是空心  NO为实心
        _pieView.holeRadiusPercent = 0.5;//空心半径占比
        _pieView.holeColor = [UIColor clearColor];//空心颜色
        _pieView.transparentCircleRadiusPercent = 0.52;//半透明空心半径占比
        _pieView.transparentCircleColor = [UIColor colorWithRed:210/255.0 green:145/255.0 blue:165/255.0 alpha:0.3];//半透明空心的颜色
        //实心饼状图样式
        //self.pieChartView.drawHoleEnabled = NO;
        //饼状图中间描述
        if (_pieView.isDrawHoleEnabled == YES) {
            _pieView.drawCenterTextEnabled = YES;//是否显示中间文字
            //普通文本
            //self.pieChartView.centerText = @"饼状图";//中间文字
            //富文本
            NSMutableAttributedString *centerText = [[NSMutableAttributedString alloc] initWithString:@"饼状图"];
            [centerText setAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:16],NSForegroundColorAttributeName: [UIColor orangeColor]} range:NSMakeRange(0, centerText.length)];
            _pieView.centerAttributedText = centerText;
        }
        //饼状图描述
        _pieView.descriptionText = @"饼状图示例";
        _pieView.descriptionFont = [UIFont systemFontOfSize:10];
        _pieView.descriptionTextColor = [UIColor grayColor];
        //饼状图图例
        _pieView.legend.maxSizePercent = 1;//图例在饼状图中的大小占比, 这会影响图例的宽高
        _pieView.legend.formToTextSpace = 5;//文本间隔
        _pieView.legend.font = [UIFont systemFontOfSize:10];//字体大小
        _pieView.legend.textColor = [UIColor grayColor];//字体颜色
        _pieView.legend.position = ChartLegendPositionBelowChartCenter;//图例在饼状图中的位置
        _pieView.legend.form = ChartLegendFormCircle;//图示样式: 方形、线条、圆形
        _pieView.legend.formSize = 12;//图示大小
        
        //设置动画效果
        [_pieView animateWithXAxisDuration:1.0f easingOption:ChartEasingOptionEaseOutExpo];
    }
    return _pieView;
}
- (PieChartData *)setPieData{
    
    NSInteger xVals_count = 10;//X轴上要显示多少条数据
    //X轴上面需要显示的数据
    NSMutableArray *xVals = [[NSMutableArray alloc] init];
    
    for (int i = 1; i <= xVals_count; i++) {
        [xVals addObject: [NSNumber numberWithInt:i]];
    }
    NSMutableArray *pieEn = [NSMutableArray array];
    for (int i = 0; i < xVals.count; i ++) {
        PieChartDataEntry *entry = [[PieChartDataEntry alloc]initWithValue:[xVals[i] doubleValue] label:@""];
        [pieEn addObject:entry];
    }
    
    PieChartDataSet *set = [[PieChartDataSet alloc]initWithValues:pieEn label:@""];
  //  set.valueFormatter = [BarValueFormatter new];
    set.drawValuesEnabled = YES;
    set.sliceSpace = 0;//相邻区块之间的间距
    set.selectionShift = 8;//选中区块时, 放大的半径
    set.xValuePosition = PieChartValuePositionInsideSlice;//名称位置
    set.yValuePosition = PieChartValuePositionOutsideSlice;//数据位置
    //数据与区块之间的用于指示的折线样式
    set.valueLinePart1OffsetPercentage = 0.85;//折线中第一段起始位置相对于区块的偏移量, 数值越大, 折线距离区块越远
    set.valueLinePart1Length = 0.5;//折线中第一段长度占比
    set.valueLinePart2Length = 0.4;//折线中第二段长度最大占比
    set.valueLineWidth = 1;//折线的粗细
    set.valueLineColor = [UIColor brownColor];//折线颜色
    set.colors = @[[UIColor greenColor],[UIColor orangeColor],[UIColor blueColor],[UIColor grayColor],[UIColor yellowColor]];
    
    PieChartData *data = [[PieChartData alloc]initWithDataSet:set];
    
    [data setValueFormatter:[BarValueFormatter new]];//设置显示数据格式
    [data setValueTextColor:[UIColor brownColor]];
    [data setValueFont:[UIFont systemFontOfSize:10]];

    return data;
    
}

#pragma mark 雷达图
- (RadarChartView *)radarView{
    
    if (!_radarView) {
        _radarView = [[RadarChartView alloc]initWithFrame:CGRectMake(0, 1080, screenWidth, 300)];
        
        _radarView.delegate = self;
        _radarView.noDataText = @"无数据";
        _radarView.descriptionText = @"";//描述
        _radarView.rotationEnabled = YES;//是否允许转动
        _radarView.highlightPerTapEnabled = YES;//是否能被选中
        
        //雷达图线条样式
        _radarView.webLineWidth = 0.5;//主干线线宽
        _radarView.webColor = [UIColor orangeColor];//主干线线宽
        _radarView.innerWebLineWidth = 0.375;//边线宽度
        _radarView.innerWebColor = [UIColor grayColor];//边线颜色
        _radarView.webAlpha = 1;//透明度
        
        //设置 xAxi
        ChartXAxis *xAxis = _radarView.xAxis;
        xAxis.labelFont = [UIFont systemFontOfSize:15];//字体
        xAxis.labelTextColor = [UIColor redColor];//颜色
        
        //设置 yAxis
        ChartYAxis *yAxis = _radarView.yAxis;
        yAxis.axisMinValue = 0.0;//最小值
     //   yAxis.axisMaxValue = 150.0;//最大值
        yAxis.drawLabelsEnabled = NO;//是否显示 label
     //   yAxis.labelCount = 6;// label 个数
        yAxis.labelFont = [UIFont systemFontOfSize:9];// label 字体
        yAxis.labelTextColor = [UIColor lightGrayColor];// label 颜色
        
        //设置动画
        [_radarView animateWithYAxisDuration:0.1f];
        
    }
    return _radarView;
}
- (RadarChartData *)setRadarData{
    
    NSInteger xVals_count = 10;//X轴上要显示多少条数据
    //X轴上面需要显示的数据
    NSMutableArray *xVals = [[NSMutableArray alloc] init];
    
    for (int i = 1; i <= xVals_count; i++) {
        [xVals addObject: [NSNumber numberWithInt:i]];
    }
    NSMutableArray *radarEn = [NSMutableArray array];
    for (int i = 0; i < xVals.count; i ++) {
        RadarChartDataEntry *entry = [[RadarChartDataEntry alloc]initWithValue:[xVals[i] doubleValue]];
        [radarEn addObject:entry];
    }
    RadarChartDataSet *set = [[RadarChartDataSet alloc]initWithValues:radarEn label:nil];
    set.valueFormatter = [BarValueFormatter new];
    set.lineWidth = 0.5;//数据折线线宽
    [set setColor:[UIColor orangeColor]];//数据折线颜色
    set.drawFilledEnabled = YES;//是否填充颜色
    set.fillColor = [UIColor greenColor];//填充颜色
    set.fillAlpha = 0.25;//填充透明度
    set.drawValuesEnabled = YES;//是否绘制显示数据
    set.valueFont = [UIFont systemFontOfSize:9];//字体
    set.valueTextColor = [UIColor grayColor];//颜色

    RadarChartData *data = [[RadarChartData alloc]initWithDataSet:set];
    return data;
}



- (void)chartValueSelected:(ChartViewBase * _Nonnull)chartView entry:(ChartDataEntry * _Nonnull)entry highlight:(ChartHighlight * _Nonnull)highlight {
    
    if (chartView == _lineView) {
        _markY.text = [NSString stringWithFormat:@"%ld%%",(NSInteger)entry.y];
        //将点击的数据滑动到中间
        [_lineView centerViewToAnimatedWithXValue:entry.x yValue:entry.y axis:[_lineView.data getDataSetByIndex:highlight.dataSetIndex].axisDependency duration:1.0];
    }

    
}
- (void)chartValueNothingSelected:(ChartViewBase * _Nonnull)chartView {
    
    
}


@end
