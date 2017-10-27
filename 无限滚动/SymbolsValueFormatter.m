//
//  SymbolsValueFormatter.m
//

#import "SymbolsValueFormatter.h"

@implementation SymbolsValueFormatter
-(id)init{
    if (self = [super init]) {
        
    }
    return self;
}
//返回y轴的数据
- (NSString *)stringForValue:(double)value axis:(ChartAxisBase *)axis
{
    
    return [NSString stringWithFormat:@"%ld%%",(NSInteger)value];
}
@end
