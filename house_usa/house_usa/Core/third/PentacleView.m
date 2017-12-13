

#import "PentacleView.h"

@interface PentacleView ()

@property (nonatomic, assign) BOOL viewTouchEnabled;
@property (nonatomic, weak) PertacleViewTapped touchAction;

@property (nonatomic, assign) BOOL shouldUpdate;

@end

@implementation PentacleView

#pragma -mark Public Methods
- (id)initWithFrame:(CGRect)frame strokeWidth:(CGFloat)strokeWidth
{
    if (self = [self initWithFrame:frame]) {
        CGFloat minSize = MIN(frame.size.width, frame.size.height);
        _strokeWidth = strokeWidth;
        _outRadius = minSize / 2 - strokeWidth;
        _innerRadius = _outRadius / 2 - 0.5;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _outRadius = 10;
        _innerRadius = 5;
        _strokeColor = [UIColor clearColor];
        _strokeWidth = 1;
        _fillPercent = 1;
        _leftFillColor = [UIColor colorWithRed:1 green:0.78 blue:0.01 alpha:1];
        _rightFillColor = [UIColor colorWithRed:0.75 green:0.76 blue:0.75 alpha:1];
        _shouldUpdate = YES;
    }
    return self;
}

- (void)setTouchEnabled:(BOOL)touchEnabled touchAction:(PertacleViewTapped)tapAction
{
    if (touchEnabled) {
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
        gesture.numberOfTouchesRequired = 1;
        gesture.numberOfTapsRequired = 1;
        [self addGestureRecognizer:gesture];
        _touchAction = tapAction;
    } else {
        UIGestureRecognizer *gesture = self.gestureRecognizers.firstObject;
        [self removeGestureRecognizer:gesture];
    }
    _viewTouchEnabled = touchEnabled;
}

- (void)beginUpdates
{
    _shouldUpdate = NO;
}

- (void)commitUpdates
{
    _shouldUpdate = YES;
    [self setNeedsDisplay];
}

#pragma -mark Actions
- (void)viewTapped:(UITapGestureRecognizer *)sender
{
    CGPoint location = [sender locationInView:self];
    PentacleTouchArea touchArea;
    if (location.x < CGRectGetWidth(self.frame) / 3) {
        touchArea = PentacleTouchAreaLeft;
    } else if (location.x > CGRectGetWidth(self.frame) / 3 * 2) {
        touchArea = PentacleTouchAreaRight;
    } else {
        touchArea = PentacleTouchAreaMiddle;
    }
    if (_touchAction) {
        _touchAction(self, touchArea);
    }
}

#pragma -mark Getters and Setters
- (void)setFillPercent:(CGFloat)fillPercent
{
    _fillPercent = fillPercent;
    [self setNeedsDisplay];
}

- (void)setLeftFillColor:(UIColor *)leftFillColor
{
    _leftFillColor = leftFillColor;
    [self setNeedsDisplay];
}

- (void)setRightFillColor:(UIColor *)rightFillColor
{
    _rightFillColor = rightFillColor;
    [self setNeedsDisplay];
}

- (void)setOutRadius:(CGFloat)outRadius
{
    _outRadius = outRadius;
    [self setNeedsDisplay];
}

- (void)setInnerRadius:(CGFloat)innerRadius
{
    _innerRadius = innerRadius;
    [self setNeedsDisplay];
}

- (void)setStrokeColor:(UIColor *)strokeColor
{
    _strokeColor = strokeColor;
    [self setNeedsDisplay];
}

- (void)setStrokeWidth:(CGFloat)strokeWidth
{
    _outRadius -= strokeWidth - _strokeWidth;
    _innerRadius = _outRadius / 2;
    _strokeWidth = strokeWidth;
    [self setNeedsDisplay];
}

- (BOOL)touchEnabled
{
    return _viewTouchEnabled;
}

- (void)setNeedsDisplay
{
    if (_shouldUpdate) {
        [super setNeedsDisplay];
    }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGFloat th = M_PI/180;
    CGFloat centerX = rect.size.width / 2;
    CGFloat centerY = rect.size.height / 2;
    
    //_innerRadius = self.outRadius * sin(18 * th)/cos(36 * th); /*计算小圆半径r0 */
    CGFloat x1[5]={0},y1[5]={0},x2[5]={0},y2[5]={0};
    
    for (int i = 0; i < 5; i ++) {
        x1[i] = centerX + self.outRadius * cos((90 + i * 72) * th); /* 计算出大圆上的五个平均分布点的坐标*/
        y1[i]=centerY - self.outRadius * sin((90 + i * 72) * th);
        x2[i]=centerX + self.innerRadius * cos((54 + i * 72) * th); /* 计算出小圆上的五个平均分布点的坐标*/
        y2[i]=centerY - self.innerRadius * sin((54 + i * 72) * th);
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGMutablePathRef startPath = CGPathCreateMutable();
    CGPathMoveToPoint(startPath, NULL, x1[0], y1[0]);
    
    for (int i = 1; i < 5; i ++) {
        CGPathAddLineToPoint(startPath, NULL, x2[i], y2[i]);
        CGPathAddLineToPoint(startPath, NULL, x1[i], y1[i]);
    }
    CGPathAddLineToPoint(startPath, NULL, x2[0], y2[0]);
    CGPathCloseSubpath(startPath);
    
    CGContextAddPath(context, startPath);
    CGContextSetFillColorWithColor(context, _leftFillColor.CGColor);
    CGContextSetStrokeColorWithColor(context, _strokeColor.CGColor);
    CGContextSetLineWidth(context, _strokeWidth);
    CGContextStrokePath(context);
    
    CGFloat fillPointX = (x1[4] - x1[1]) * self.fillPercent;
    
    CGRect leftRange = CGRectMake(x1[1], 0, fillPointX, y1[2]);
    CGContextAddPath(context, startPath);
    CGContextClip(context);
    CGContextFillRect(context, leftRange);
    
    CGContextSetFillColorWithColor(context, _rightFillColor.CGColor);
    CGRect rightRange = CGRectMake(x1[1] + fillPointX, 0, x1[4] - fillPointX, y1[2]);
    CGContextAddPath(context, startPath);
    CGContextClip(context);
    CGContextFillRect(context, rightRange);
    
    CFRelease(startPath);
}

@end
