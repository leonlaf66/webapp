

#import "MultiPentacleView.h"
#import "PentacleView.h"

@implementation MultiPentacleView

- (void)setPentacleScore:(CGFloat)pentacleScore
{
    _pentacleScore = pentacleScore;
    if (self.subviews.count > 0) {
        [self reloadSubViews];
    } else {
        [self initSubViews];
    }
}

- (void)initSubViews
{
    
    for (NSInteger i = 0; i < 5; ++i) {
        CGRect frame = CGRectMake(10 * i + i * 2 + (self.frame.size.width - 58) / 2, 0, 10, 10);
        PentacleView *pentacleView = [[PentacleView alloc] initWithFrame:frame strokeWidth:1.5];
        pentacleView.backgroundColor = [UIColor clearColor];
        [self addSubview:pentacleView];
        
        [self setUpPentacleViewState:pentacleView index:i];
    }
}

- (void)reloadSubViews
{
    for (NSInteger i = 0; i < self.subviews.count; ++i) {
        [self setUpPentacleViewState:self.subviews[i] index:i];
    }
}

- (void)setUpPentacleViewState:(PentacleView *)pentacleView index:(NSInteger)index
{
    [pentacleView beginUpdates];
    if (_pentacleScore - index >= 1) {
        pentacleView.strokeWidth = 0;
        pentacleView.leftFillColor = GlobalTintColor;
        pentacleView.fillPercent = 1;
    } else if (_pentacleScore - index < 1 && _pentacleScore - index > 0) {
        pentacleView.strokeWidth = 0;
        pentacleView.leftFillColor = GlobalTintColor;
        pentacleView.rightFillColor = [UIColor colorWithRed:0.75 green:0.76 blue:0.75 alpha:1];
        pentacleView.fillPercent = 0.5;
    } else if (_pentacleScore - index <= 0) {
        pentacleView.strokeWidth = 1.5;
        pentacleView.strokeColor = [UIColor colorWithRed:0.75 green:0.76 blue:0.75 alpha:1];
        pentacleView.leftFillColor = [UIColor whiteColor];
        pentacleView.fillPercent = 1;
    }
    [pentacleView commitUpdates];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
