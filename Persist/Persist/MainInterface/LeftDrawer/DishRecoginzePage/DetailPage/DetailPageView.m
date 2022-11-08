//
//  DetailPageView.m
//  Persist
//
//  Created by 张博添 on 2022/3/24.
//

#import "DetailPageView.h"
#import "DetailInfoCell/DetailInfoCell.h"

#define selfViewWidth self.frame.size.width
#define selfViewHeight self.frame.size.height

static const int navigationBarHeight = 50;

@interface DetailPageView()
<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *mainTableView;

@property (nonatomic, strong) UIView *navigationBarView;
@property (nonatomic, strong) UIButton *finishButton;

@property (nonatomic, strong) UIView *headView;

@end

@implementation DetailPageView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor whiteColor];
    
    self.nameArray = [[NSMutableArray alloc] init];
    self.detailArray = [[NSMutableArray alloc] init];
    self.calorieArray = [[NSMutableArray alloc] init];
    self.imageURLArray = [[NSMutableArray alloc] init];
    
    [self buildUI];
    return self;
}

- (void)buildUI {
    _navigationBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, selfViewWidth, navigationBarHeight)];
    [self addSubview:_navigationBarView];
    
    _finishButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _finishButton.frame = CGRectMake(selfViewWidth - 80, 0, 60, navigationBarHeight);
    [_navigationBarView addSubview:_finishButton];
    [_finishButton setTitle:@"完成" forState:UIControlStateNormal];
    [_finishButton addTarget:self action:@selector(pressFinish) forControlEvents:UIControlEventTouchUpInside];
    
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, navigationBarHeight, selfViewWidth, selfViewHeight - navigationBarHeight) style:UITableViewStyleGrouped];
    [self addSubview:_mainTableView];
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    [_mainTableView registerClass:[DetailInfoCell class] forCellReuseIdentifier:@"cell"];
    [_mainTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell2"];
    _mainTableView.sectionFooterHeight = 50;
}

- (UIView *)headView {
    _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, selfViewWidth, selfViewWidth * 0.75)];
    if (_targetImage) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:_targetImage];
        CGSize size = CGSizeZero;
        
        if (_targetImage.size.width * 0.75 >= _targetImage.size.height) {
            size = CGSizeMake(selfViewWidth, selfViewWidth / _targetImage.size.width * _targetImage.size.height);
        } else {
            size = CGSizeMake(selfViewWidth * 0.75 / _targetImage.size.height * _targetImage.size.width, selfViewWidth * 0.75);
        }
        imageView.frame = CGRectMake(0, 0, size.width, size.height);
        imageView.center = _headView.center;
        [_headView addSubview:imageView];
        _headView.backgroundColor = [UIColor blackColor];
    }
    return _headView;
}

#pragma mark - TableViewDelegate/DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _nameArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return selfViewWidth * 0.75;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self heightForRow:indexPath.row];
}

#pragma mark CellForRowAtIndexPath
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_isDish) {
        DetailInfoCell *cell = [_mainTableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        
        cell.nameLabel.text = [_nameArray objectAtIndex:indexPath.row];
        cell.calorieLabel.text = [_calorieArray objectAtIndex:indexPath.row];
        cell.detailLabel.text = [_detailArray objectAtIndex:indexPath.row];
        
        
        if (![[_imageURLArray objectAtIndex:indexPath.row] isEqualToString:@"NONE"]) {
            cell.infoImageView.image = [UIImage imageNamed:@"LOADING.png"];
            cell.infoImageView.frame = CGRectMake(10, 10, cell.frame.size.width / 5, cell.frame.size.width / 5);
            [cell layoutSubviews];
    //        [[SDImageCache sharedImageCache] clearDiskOnCompletion:nil];
            [cell.infoImageView sd_setImageWithURL:[_imageURLArray objectAtIndex:indexPath.row] placeholderImage:[UIImage imageNamed:@"LOADING.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType type, NSURL *url) {
                if (image) {
                    cell.infoImageView.frame = CGRectMake(10, 10, cell.frame.size.width / 5 * (image.size.width / image.size.height), cell.frame.size.width / 5);
                    [cell layoutSubviews];
                } else {
                    cell.infoImageView.image = [UIImage imageNamed:@"NODETAIL.png"];
                }
            }];
        } else {
            cell.infoImageView.image = [UIImage imageNamed:@"NODETAIL.png"];
            cell.infoImageView.frame = CGRectMake(10, 10, cell.frame.size.width / 5, cell.frame.size.width / 5);
            [cell layoutSubviews];
        }
        
        return cell;
    } else {
        UITableViewCell *cell = [_mainTableView dequeueReusableCellWithIdentifier:@"cell2" forIndexPath:indexPath];
        
        cell.textLabel.text = [_nameArray objectAtIndex:indexPath.row];
        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.headView;
}

- (void)pressFinish {
    [self.delegate pressFinish];
}

- (void)reloadTableView {
    [self.mainTableView reloadData];
}

- (float)heightForRow:(NSInteger)row {
    if (_isDish) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, selfViewWidth - 20, 10)];
        label.numberOfLines = 0;
        label.lineBreakMode = NSLineBreakByWordWrapping;
        label.text = [_detailArray objectAtIndex:row];
        [label sizeToFit];
    //    NSLog(@"%f", selfViewWidth / 5 + 30 + label.frame.size.height);
        return selfViewWidth / 5 + 30 + label.frame.size.height;
    } else {
        return 50;
    }
}

@end
