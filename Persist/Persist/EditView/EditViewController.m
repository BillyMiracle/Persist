//
//  EditViewController.m
//  Persist
//
//  Created by 张博添 on 2022/1/9.
//
#pragma mark - 头像照片编辑界面
#import "EditViewController.h"
#import "Masonry.h"

#define statusBarHeight [UIApplication sharedApplication].windows.firstObject.windowScene.statusBarManager.statusBarFrame.size.height

#define screenHeight (self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height - statusBarHeight)
#define screenWidth self.view.frame.size.width

static const int fontSize = 17;

@interface EditViewController ()
<UIScrollViewDelegate>
{
    double contentInsetLeft;
    double contentInsetRight;
    double contentInsetTop;
    
}
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;


@property (nonatomic, assign) CGSize hollowSize;

@property (nonatomic, assign) BOOL isFirstZoom;
//横版或者竖版图片
@property (nonatomic, assign) BOOL vMode;
//初次缩放的contentoffset的y值
@property (nonatomic, assign) double firstOffsetY;

@end

@implementation EditViewController

- (void)viewDidLoad {

    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = NO;
    
    contentInsetLeft = 20;
    contentInsetRight = 20;
    contentInsetTop = (screenHeight / 2 - (screenWidth - 40) / 2);
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    backButton.frame = CGRectMake(0, 0, 30, self.navigationController.navigationBar.frame.size.height);
    [backButton setTitle:@"取消" forState:UIControlStateNormal];
    backButton.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    [backButton addTarget:self action:@selector(pressBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = back;
    self.navigationController.navigationBar.translucent = NO;
    
    
    UINavigationBarAppearance * bar = [[UINavigationBarAppearance alloc] init];
    bar.backgroundColor = [UIColor whiteColor];
    bar.backgroundEffect = nil;
    self.navigationController.navigationBar.scrollEdgeAppearance = bar;
    self.navigationController.navigationBar.standardAppearance = bar;
    
    
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    confirmButton.frame = CGRectMake(0, 0, 30, self.navigationController.navigationBar.frame.size.height);
    [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    confirmButton.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    [confirmButton addTarget:self action:@selector(pressConfirm) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *confirm = [[UIBarButtonItem alloc] initWithCustomView:confirmButton];
    self.navigationItem.rightBarButtonItem = confirm;
    
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.delegate = self;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
//    _scrollView.backgroundColor = [UIColor blackColor];
    
    _imageView = [[UIImageView alloc] init];
    
    [self createSubviews];
    [self setImage:_image];
    
    [self initLines];
}

- (void)initLines {
    UIView *topMask = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, contentInsetTop)];
    topMask.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.5];
    [self.view addSubview:topMask];
    
    UIView *bottomMask = [[UIView alloc] initWithFrame:CGRectMake(0, screenHeight - contentInsetTop, screenWidth, contentInsetTop + 34)];
    bottomMask.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.5];
    [self.view addSubview:bottomMask];
    
    UIView *leftMask = [[UIView alloc] initWithFrame:CGRectMake(0, contentInsetTop, 20, screenWidth - 40)];
    leftMask.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.5];
    [self.view addSubview:leftMask];
    
    UIView *rightMask = [[UIView alloc] initWithFrame:CGRectMake(screenWidth - contentInsetLeft, contentInsetTop, 20, screenWidth - 40)];
    rightMask.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.5];
    [self.view addSubview:rightMask];
    
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(19, contentInsetTop - 1, screenWidth - 38, 1)];
    topLine.backgroundColor = [UIColor darkGrayColor];
    [self.view addSubview:topLine];
    
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(19, screenHeight - contentInsetTop, screenWidth - 38, 1)];
    bottomLine.backgroundColor = [UIColor darkGrayColor];
    [self.view addSubview:bottomLine];
    
    UIView *leftLine = [[UIView alloc] initWithFrame:CGRectMake(19, contentInsetTop, 1, screenWidth - 40)];
    leftLine.backgroundColor = [UIColor darkGrayColor];
    [self.view addSubview:leftLine];
    
    UIView *rightLine = [[UIView alloc] initWithFrame:CGRectMake(screenWidth - contentInsetLeft, contentInsetTop, 1, screenWidth - 40)];
    rightLine.backgroundColor = [UIColor darkGrayColor];
    [self.view addSubview:rightLine];
    
}

- (void)setImage:(UIImage *)image {
    //初始化空白处大小
    self.hollowSize = CGSizeMake(self.view.frame.size.width - 40, self.view.frame.size.width - 40);
    if (image != _image) {
        _image = image;
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageView.image = image;
            CGSize maxSize = self.hollowSize;
            if (image.size.height > image.size.width) {
                self.vMode = YES;
            } else {
                self.vMode = NO;
            }
            CGFloat widthRatio = maxSize.width / image.size.width;
            CGFloat heightRatio = maxSize.height / image.size.height;
            CGFloat initialZoom = (widthRatio > heightRatio) ? heightRatio : widthRatio;
            if (initialZoom > 1) {
                initialZoom = 1;
            }
            // 初始化显示imageView
            CGRect initialFrame = self.scrollView.frame;
            initialFrame.size.width = image.size.width * initialZoom;
            initialFrame.size.height = image.size.height * initialZoom;
            self.imageView.frame = initialFrame;
            
            [self.scrollView setMinimumZoomScale:initialZoom];
            [self.scrollView setMaximumZoomScale:3];
            //初次铺满缩放
            self.isFirstZoom = YES;
            [self.scrollView setZoomScale:1.0];
            [self scrollViewDidZoom:self.scrollView];
        });
    }
}

- (void)createSubviews {
    //注意： 此处不要使用约束布局，因为scrollview存在缩、滚动、弹簧动画等混合效果，使用约束计算容易崩溃
    self.scrollView.frame = CGRectMake(0 , 0, screenWidth, screenHeight);
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.imageView];
    
    double contentInsertBottom = (statusBarHeight == 20) ? (contentInsetTop) : (contentInsetTop - 34);
//    double contentInsertBottom = contentInsetTop;
//    NSLog(@"%f %f", contentInsetTop, contentInsertBottom);
//    NSLog(@"%f", screenHeight);
    self.scrollView.contentInset = UIEdgeInsetsMake(contentInsetTop, contentInsetLeft, contentInsertBottom, contentInsetLeft);
}

#pragma mark- <UIScrollViewDelegate> Methods
- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGFloat w_content = self.scrollView.contentSize.width;
    CGFloat h_content = self.scrollView.contentSize.height;
    
    //容错处理
    if (w_content <= 0) {
        w_content = self.hollowSize.width * 0.5;
    }
    if (h_content <= 0) {
        h_content = self.hollowSize.height * 0.5;
    }
    //限定铺满处理
    if (w_content < self.hollowSize.width) {
        h_content = h_content * self.hollowSize.width / w_content;
        w_content = self.hollowSize.width;
    }
    if (h_content < self.hollowSize.height) {
        w_content = w_content * self.hollowSize.height / h_content;
        h_content = self.hollowSize.height;
    }
    self.imageView.frame = CGRectMake(0, 0, w_content, h_content);
    //
    self.scrollView.contentSize = CGSizeMake(w_content, h_content);
    self.imageView.center = CGPointMake(self.scrollView.contentSize.width * 0.5 ,
                                        self.scrollView.contentSize.height * 0.5);
    if (self.isFirstZoom) {
       // 初始化缩放居中显示
        CGFloat offset_x = (self.imageView.frame.size.width - self.hollowSize.width) * 0.5 - contentInsetLeft;
        CGFloat offset_y = (self.imageView.frame.size.height - self.hollowSize.height) * 0.5 - contentInsetTop;
//        NSLog(@"%f %f %f %f", self.imageView.frame.size.height, self.hollowSize.height, contentInsetTop, offset_y);
        [self.scrollView setContentOffset:CGPointMake(offset_x , offset_y) animated:NO];
        self.isFirstZoom = NO;
        self.firstOffsetY = scrollView.contentOffset.y;
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

#pragma mark- 裁剪 Methods
- (UIImage *)getSubImage {
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.hollowSize.width, self.hollowSize.height), YES, [UIScreen mainScreen].scale);
    CGPoint offset = self.scrollView.contentOffset;
    //计算偏移找到裁剪区域的左上角
    if (!_vMode) {
        CGContextTranslateCTM(UIGraphicsGetCurrentContext(), -(offset.x + contentInsetLeft), -(offset.y - self.firstOffsetY));
    } else {
        CGContextTranslateCTM(UIGraphicsGetCurrentContext(), -(offset.x + contentInsetLeft), -(offset.y + contentInsetTop));
    }
//    void CGContextTranslateCTM ( CGContextRef c, CGFloat tx, CGFloat ty )：平移坐标系统。
//    该方法相当于把原来位于 (0, 0) 位置的坐标原点平移到 (tx, ty) 点。在平移后的坐标系统上绘制图形时，所有坐标点的 X 坐标都相当于增加了 tx，所有点的 Y 坐标都相当于增加了 ty。
    [self.scrollView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    img = [self imageWithImage:img scaledToSize:CGSizeMake(self.hollowSize.width, self.hollowSize.height)];
    return img;
}

-(UIImage *)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark BACK
- (void)pressBack {
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark CONFIRM
- (void)pressConfirm {
    [self.delegate receiveImage:[self getSubImage]];
}

@end
