//
//  BarValueFormatter.m
//  无限滚动
//

#import "BarValueFormatter.h"

@implementation BarValueFormatter

- (NSString * _Nonnull)stringForValue:(double)value entry:(ChartDataEntry * _Nonnull)entry dataSetIndex:(NSInteger)dataSetIndex viewPortHandler:(ChartViewPortHandler * _Nullable)viewPortHandler {
//    NSString *resultStr = [@(value) stringValue];
//    if (value > 99999999) {
//        double midValue = value/10000000;
//        resultStr = [NSString stringWithFormat:@"%.2f千万", midValue];
//    } else if (value > 9999) {
//        double midValue = value/10000;
//        resultStr = [NSString stringWithFormat:@"%.2f万", midValue];
//    }
//    return resultStr;

    return [NSString stringWithFormat:@"%ld%%",(NSInteger)value];
}

- (NSString * _Nonnull)stringForValue:(double)value axis:(ChartAxisBase * _Nullable)axis {
//    NSString *resultStr = [NSString stringWithFormat:@"%.2f", value];
//    if (value > 99999999) {
//        double midValue = value/10000000;
//        resultStr = [NSString stringWithFormat:@"%.2f千万", midValue];
//    } else if (value > 9999) {
//        double midValue = value/10000;
//        resultStr = [NSString stringWithFormat:@"%.2f万", midValue];
//    }
//    return resultStr;
    return [NSString stringWithFormat:@"%ld%%",(NSInteger)value];
}

@end
