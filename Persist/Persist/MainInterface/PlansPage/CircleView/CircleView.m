//
//  CircleView.m
//  Persist
//
//  Created by 张博添 on 2022/3/16.
//

#import "CircleView.h"

static const float lineWidth = 10;

@interface CircleView()

@property (nonatomic, assign) float progress;
@property (nonatomic, strong) CAShapeLayer *progressLayer;
@property (nonatomic, strong) CAShapeLayer *progressLayer2;

@end

@implementation CircleView

- (instancetype)init {
    self = [super init];
//    @throw [NSException exceptionWithName:@"CircleView init" reason:@"You should use \"initWithFrame:\" instead!!!" userInfo:nil];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.width)];
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CALayer *gradientLayer = [CALayer layer];
    gradientLayer.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.width);
    
    //左侧渐变色
    CAGradientLayer *leftLayer = [CAGradientLayer layer];
    leftLayer.frame = CGRectMake(0, 0, self.bounds.size.width / 2, self.bounds.size.width);    // 分段设置渐变色
    leftLayer.locations = @[@0.2, @0.8, @1];
    leftLayer.colors = @[(id)[UIColor greenColor].CGColor, (id)[UIColor yellowColor].CGColor];
    [gradientLayer addSublayer:leftLayer];

    //右侧渐变色
    CAGradientLayer *rightLayer = [CAGradientLayer layer];
    rightLayer.frame = CGRectMake(self.bounds.size.width / 2, 0, self.bounds.size.width / 2, self.bounds.size.height);
    rightLayer.locations = @[@0.2, @0.8, @1];
    rightLayer.colors = @[(id)[UIColor redColor].CGColor, (id)[UIColor yellowColor].CGColor];
    [gradientLayer addSublayer:rightLayer];
    CGPoint center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.width / 2);
    CGFloat radius = self.bounds.size.width / 2 - lineWidth;
    //其实用半径画出来的圆，为路径中心的圆
    CGFloat startA = -M_PI_2;  //设置进度条起点位置
    CGFloat endA = -M_PI_2 + M_PI * 2 * _progress;  //设置进度条终点位置

    //获取环形路径（画一个圆形，填充色透明，设置线框宽度为10，这样就获得了一个环形）
    _progressLayer = [CAShapeLayer layer];//创建一个track shape layer
    _progressLayer.frame = self.bounds;
    _progressLayer.fillColor = [[UIColor clearColor] CGColor];
    //填充色为无色
    _progressLayer.strokeColor = [[UIColor redColor] CGColor];
    //指定path的渲染颜色,这里可以设置任意不透明颜色
    _progressLayer.opacity = 1; //背景颜色的透明度
    _progressLayer.lineWidth = lineWidth;//线的宽度
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startA endAngle:endA clockwise:YES];//上面说明过了用来构建圆形
    _progressLayer.path = [path CGPath];
    //把path传递給layer，然后layer会处理相应的渲染，整个逻辑和CoreGraph是一致的。
    
    _progressLayer2 = [CAShapeLayer layer];//创建一个track shape layer
    _progressLayer2.frame = self.bounds;
    _progressLayer2.fillColor = [[UIColor clearColor] CGColor];
    //填充色为无色
    _progressLayer2.strokeColor = [[UIColor colorWithWhite:0.9 alpha:1] CGColor];
    //指定path的渲染颜色,这里可以设置任意不透明颜色
    _progressLayer2.opacity = 1; //背景颜色的透明度
    _progressLayer2.lineWidth = lineWidth + 0.1;//线的宽度
    UIBezierPath *path2 = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:endA endAngle:-M_PI_2 + M_PI * 2 clockwise:YES];//上面说明过了用来构建圆形
    _progressLayer2.path = [path2 CGPath];
    [self.layer addSublayer:_progressLayer2];//创建底色轨道
    
    [gradientLayer setMask:_progressLayer]; //用progressLayer来截取渐变层
    [self.layer addSublayer:gradientLayer];
}

- (void)changeProgress:(float)progress {
    _progress = progress;
    [self setNeedsDisplay];
}

@end
