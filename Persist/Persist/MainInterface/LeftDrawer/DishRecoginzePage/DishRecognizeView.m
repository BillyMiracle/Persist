//
//  DishRecognizeView.m
//  Persist
//
//  Created by 张博添 on 2022/3/23.
//

#import "DishRecognizeView.h"
#import "IconView.h"

#define selfViewWidth self.frame.size.width
#define selfViewHeight self.frame.size.height

//#define selfViewWidth 340
//#define selfViewHeight 500

static const float navigationBarHeight = 50.0;

@interface DishRecognizeView()

@property (nonatomic, strong) UIView *statusBarView;
@property (nonatomic, strong) UIView *navigationBarView;
@property (nonatomic, assign, readonly) float statusBarHeight;

@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) IconView *iconViewDish;
@property (nonatomic, strong) IconView *iconViewVegetable;


@end

@implementation DishRecognizeView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
//    self = [super initWithFrame:CGRectMake(0, 0, 340, 500)];
    self.backgroundColor = [UIColor whiteColor];
    [self buildUI];
    return self;
}

- (float)statusBarHeight {
    NSSet *set = [[UIApplication sharedApplication] connectedScenes];
    UIWindowScene *windowScene = [set anyObject];
    UIStatusBarManager *statusBarManager2 =  windowScene.statusBarManager;
    return statusBarManager2.statusBarFrame.size.height;
}

- (void)buildUI {
    
    _statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, selfViewWidth, self.statusBarHeight)];
    _statusBarView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_statusBarView];
    
    _navigationBarView = [[UIView alloc] initWithFrame:CGRectMake(0, self.statusBarHeight, selfViewWidth, navigationBarHeight)];
    _navigationBarView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_navigationBarView];
    
    _backButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_navigationBarView addSubview:_backButton];
    _backButton.frame = CGRectMake(10, 10, navigationBarHeight - 20, navigationBarHeight - 20);
    [_backButton setBackgroundImage:[UIImage imageNamed:@"fanhui.png"] forState:UIControlStateNormal];
    [_backButton addTarget:self action:@selector(pressBackButton) forControlEvents:UIControlEventTouchUpInside];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(navigationBarHeight, 0, selfViewWidth - 2 * navigationBarHeight, navigationBarHeight)];
    [_navigationBarView addSubview:_titleLabel];
    _titleLabel.text = @"饮食工具";
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont systemFontOfSize:16 * (_titleLabel.frame.size.height - 18) / _titleLabel.font.lineHeight];
    
    _iconViewDish = [[IconView alloc] initWithFrame:CGRectMake(selfViewWidth / 8 * 3, navigationBarHeight + self.statusBarHeight + 40, selfViewWidth / 4, selfViewWidth / 4)];
    [self addSubview:_iconViewDish];
    _iconViewDish.iconImageView.image = [UIImage imageNamed:@"DishRecognize.png"];
    _iconViewDish.nameLabel.text = @"菜品识别";
    [_iconViewDish addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressDish)]];
    
    _iconViewVegetable = [[IconView alloc] initWithFrame:CGRectMake(selfViewWidth / 8 * 3, navigationBarHeight + self.statusBarHeight + 40 + selfViewWidth / 4 + 20, selfViewWidth / 4, selfViewWidth / 4)];
    [self addSubview:_iconViewVegetable];
    _iconViewVegetable.iconImageView.image = [UIImage imageNamed:@"VegetableRecognize.png"];
    _iconViewVegetable.nameLabel.text = @"果蔬识别";
    [_iconViewVegetable addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressVegetable)]];
}

- (void)pressBackButton {
    [self.delegate pressBack];
}

- (void)pressDish {
    [self.delegate recognizeDish];
}

- (void)pressVegetable {
    [self.delegate recognizeVegetable];
}

@end
