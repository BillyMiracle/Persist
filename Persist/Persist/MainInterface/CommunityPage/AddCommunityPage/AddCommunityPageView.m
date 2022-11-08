//
//  AddCommunityPageView.m
//  Persist
//
//  Created by 张博添 on 2022/4/11.
//

#import "AddCommunityPageView.h"
#import "CustomTextView.h"

#define selfViewWidth self.frame.size.width
#define selfViewHeight self.frame.size.height

static const float navigationBarHeight = 50.0;

@interface AddCommunityPageView()
<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UIView *statusBarView;
@property (nonatomic, strong) UIView *navigationBarView;
@property (nonatomic, assign, readonly) float statusBarHeight;

@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIView *mainView;

@property (nonatomic, strong) CustomTextView *contentTextView;

@property (nonatomic, assign) NSInteger *numberOfPictures;
@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic, strong) UICollectionView *pictureCollectionView;

@property (nonatomic, strong) UIButton *confirmButton;

@end

@implementation AddCommunityPageView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    _imageArray = [[NSMutableArray alloc] init];
    _updateImageArray = [[NSMutableArray alloc] init];
    [_imageArray addObject:[UIImage imageNamed:@"addPict.png"]];
    
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
    _titleLabel.text = @"发布动态";
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont systemFontOfSize:16 * (_titleLabel.frame.size.height - 18) / _titleLabel.font.lineHeight];
    
    _mainView = [[UIView alloc] initWithFrame:CGRectMake(0, self.statusBarHeight + navigationBarHeight, selfViewWidth, selfViewHeight - (self.statusBarHeight + navigationBarHeight))];
    [self addSubview:_mainView];
    _mainView.backgroundColor = [UIColor whiteColor];
    
#pragma mark 文本区
    _contentTextView = [[CustomTextView alloc] initWithFrame:CGRectMake(20, 20, selfViewWidth - 40, selfViewHeight * 0.2)];
    [_mainView addSubview:_contentTextView];
    [_contentTextView setPlaceholder:@"写下想说的话"];
    _contentTextView.layer.masksToBounds = YES;
    _contentTextView.layer.borderColor = [UIColor grayColor].CGColor;
    _contentTextView.layer.borderWidth = 1;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:_contentTextView];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.itemSize = CGSizeMake((selfViewWidth - 40) / 3, (selfViewWidth - 40) / 3);
    _pictureCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(20, _contentTextView.frame.origin.y + _contentTextView.frame.size.height + 20, selfViewWidth - 40, (selfViewWidth - 40) / 3) collectionViewLayout:layout];
    [_mainView addSubview:_pictureCollectionView];
    _pictureCollectionView.delegate = self;
    _pictureCollectionView.dataSource = self;
    [_pictureCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"collectionCell"];
    
#pragma mark 确认按钮
    _confirmButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self addSubview:_confirmButton];
    _confirmButton.frame = CGRectMake(selfViewHeight / 26, selfViewHeight * 14 / 15 - selfViewHeight / 13, selfViewWidth - selfViewHeight / 13, selfViewHeight / 13);
    [self setConfirmButtonOff];
    [_confirmButton setTitle:@"发布" forState:UIControlStateNormal];
    [_confirmButton.layer setMasksToBounds:YES];
    _confirmButton.layer.cornerRadius = selfViewHeight / 26;
    _confirmButton.layer.borderWidth = 0;
    _confirmButton.titleLabel.font = [UIFont systemFontOfSize:23];
    [_confirmButton addTarget:self action:@selector(pressConfirm) forControlEvents:UIControlEventTouchUpInside];
}

- (void)pressBackButton {
    
    [self.delegate goBack];
    
}

//返回每个item
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [_pictureCollectionView dequeueReusableCellWithReuseIdentifier:@"collectionCell" forIndexPath:indexPath];
//    if (indexPath.row == 3 && _imageArray.count == 4) {
//
//    }
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, (selfViewWidth - 40) / 3, (selfViewWidth - 40) / 3)];
    [cell.contentView addSubview:imageView];
    imageView.image = [self scaleToSquare:[_imageArray objectAtIndex:indexPath.row]];
    if (indexPath.row != _imageArray.count - 1) {
        UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        deleteButton.frame = CGRectMake(imageView.frame.size.width - 20, 0, 20, 20);
        [deleteButton setBackgroundImage:[UIImage imageNamed:@"deletePict.png"] forState:UIControlStateNormal];
        deleteButton.tag = indexPath.row;
        [deleteButton addTarget:self action:@selector(pressDelete:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:deleteButton];
    }
    return cell;
}

//返回分区个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

//返回每个分区的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSLog(@"%ld", _imageArray.count);
    return (_imageArray.count >= 3) ? 3 : _imageArray.count;
}

//动态设置每行的间距大小
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%ld", indexPath.row);
    if (indexPath.row != _imageArray.count - 1) {
        NSLog(@"111");
    } else {
        [self.delegate chooseImage];
    }
    
}

#pragma mark 调整图片大小
- (UIImage *)scaleToSquare:(UIImage *)img {
    CGSize size = CGSizeMake((img.size.height <= img.size.width ? img.size.height : img.size.width), (img.size.height <= img.size.width ? img.size.height : img.size.width));

    CGImageRef partOneImageRef = CGImageCreateWithImageInRect(img.CGImage, CGRectMake(0, 0, size.width, size.height));

    return [UIImage imageWithCGImage:partOneImageRef];
    
}

- (void)addImage:(UIImage *)imageToBeAdded {
    [_imageArray insertObject:imageToBeAdded atIndex:_imageArray.count - 1];
    [_updateImageArray addObject:imageToBeAdded];
    [_pictureCollectionView reloadData];
}

#pragma mark - 关闭确认按钮
- (void)setConfirmButtonOff {
    _confirmButton.backgroundColor = [UIColor colorWithRed:0.55 green:0.5 blue:0.9 alpha:0.7];
    [_confirmButton setTintColor:[UIColor darkGrayColor]];
    _confirmButton.userInteractionEnabled = NO;
}

#pragma mark - 关闭确认按钮
- (void)setConfirmButtonUploading {
    _confirmButton.backgroundColor = [UIColor colorWithRed:0.55 green:0.5 blue:0.9 alpha:0.7];
    [_confirmButton setTintColor:[UIColor darkGrayColor]];
    [_confirmButton setTitle:@"发布中..." forState:UIControlStateNormal];
    _confirmButton.userInteractionEnabled = NO;
}

#pragma mark - 激活确认按钮
- (void)setConfirmButtonOn {
    _confirmButton.backgroundColor = [UIColor colorWithRed:0.55 green:0.5 blue:0.9 alpha:1];
    [_confirmButton setTintColor:[UIColor blackColor]];
    _confirmButton.userInteractionEnabled = YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_contentTextView resignFirstResponder];
}

#pragma mark 删除图片
- (void)pressDelete:(UIButton *)btn {
    [_imageArray removeObjectAtIndex:btn.tag];
    [_updateImageArray removeObjectAtIndex:btn.tag];
    [_pictureCollectionView reloadData];
}

- (void)textDidChange {
    _content = _contentTextView.text;
    if ([_contentTextView.text isEqualToString:@""]) {
        [self setConfirmButtonOff];
    } else {
        [self setConfirmButtonOn];
    }
}

- (void)pressConfirm {
    [self setConfirmButtonUploading];
    self.backButton.userInteractionEnabled = NO;
    [self.delegate confirm];
}

@end
