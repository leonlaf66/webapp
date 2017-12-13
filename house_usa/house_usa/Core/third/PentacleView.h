

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, PentacleTouchArea) {
    PentacleTouchAreaLeft,
    PentacleTouchAreaMiddle,
    PentacleTouchAreaRight
};

@class PentacleView;
typedef void (^PertacleViewTapped)(PentacleView *pertacleView, PentacleTouchArea touchArea);

@interface PentacleView : UIView

@property (nonatomic, assign) CGFloat outRadius;     // 五角星外侧五个点到圆心的距离
@property (nonatomic, assign) CGFloat innerRadius;   // 五角星内侧五个点到圆心的距离

@property (nonatomic, strong) UIColor *strokeColor;  // 五边的颜色，默认为clearColor
@property (nonatomic, assign) CGFloat strokeWidth;  // 五边的宽度，默认为1

@property (nonatomic, assign) CGFloat fillPercent;      // 0~1，从左到右填充的百分比，默认为1
@property (nonatomic, strong) UIColor *leftFillColor;   // 左半部分填充的颜色，默认为yellowColor
@property (nonatomic, strong) UIColor *rightFillColor;  // 右半部分填充的颜色，默认为grayColor

@property (nonatomic, assign, readonly) BOOL touchEnabled;   // 是否允许点击事件
// 设置点击及点击回调事件
- (void)setTouchEnabled:(BOOL)touchEnabled touchAction:(PertacleViewTapped)tapAction;

// 初始化
- (id)initWithFrame:(CGRect)frame strokeWidth:(CGFloat)strokeWidth;

// 批量修改属性
- (void)beginUpdates;
- (void)commitUpdates;

@end
