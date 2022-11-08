//
//  CommunityPageView.m
//  Persist
//
//  Created by 张博添 on 2022/1/19.
//

#import "CommunityPageView.h"
#import "LoginOrRegisterModel.h"
#import "CommunityTableViewCell.h"
#import "CommunityNoPictTableViewCell.h"
#import "CommunityOnePictTableViewCell.h"
#import "Manager.h"
#import "BrandNewTableViewCell.h"

#define selfViewWidth self.frame.size.width
#define selfViewHeight self.frame.size.height

static const float navigationBarHeight = 50.0;

@interface CommunityPageView ()
<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign, readonly) float statusBarHeight;
@property (nonatomic, strong) UIView *statusBarView;
@property (nonatomic, strong) UIView *navigationBarView;
@property (nonatomic, strong) UIButton *headImageButton;

@property (nonatomic, strong) UIButton *addButton;

@property (nonatomic, strong) UITableView *mainTableView;

@property (nonatomic, strong) NSMutableArray *headURLArray;
@property (nonatomic, strong) NSMutableArray *userNameArray;
@property (nonatomic, strong) NSMutableArray *picturesArray;
@property (nonatomic, strong) NSMutableArray *contentArray;

@property (nonatomic, strong) NSMutableArray *imageHeightArray;
@property (nonatomic, strong) NSMutableArray *textHeightArray;

@end

@implementation CommunityPageView {
    float width;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
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
    
    width = selfViewWidth;
    
    _headURLArray = [[NSMutableArray alloc] init];
    _userNameArray = [[NSMutableArray alloc] init];
    _picturesArray = [[NSMutableArray alloc] init];
    _contentArray = [[NSMutableArray alloc] init];
    
    _imageHeightArray = [[NSMutableArray alloc] init];
    _textHeightArray = [[NSMutableArray alloc] init];
    
    _statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, selfViewWidth, self.statusBarHeight)];
    _statusBarView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_statusBarView];
    
    _navigationBarView = [[UIView alloc] initWithFrame:CGRectMake(0, self.statusBarHeight, selfViewWidth, navigationBarHeight)];
    _navigationBarView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_navigationBarView];
    
    _headImageButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _headImageButton.frame = CGRectMake(10, 5, navigationBarHeight - 10, navigationBarHeight - 10);
    _headImageButton.layer.masksToBounds = YES;
    _headImageButton.layer.borderWidth = 0;
    _headImageButton.layer.cornerRadius = (navigationBarHeight - 10) / 2;
    [_headImageButton addTarget:self action:@selector(pressHeadImageButton) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *headImage = [UIImage imageWithData:[[LoginOrRegisterModel sharedModel] imageData]];
    [_headImageButton setBackgroundImage:headImage forState:UIControlStateNormal];
    [_navigationBarView addSubview:_headImageButton];
    
    _addButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _addButton.frame = CGRectMake(selfViewWidth - navigationBarHeight, 10, navigationBarHeight - 20, navigationBarHeight - 20);
    [_addButton setBackgroundImage:[UIImage imageNamed:@"jia.png"] forState:UIControlStateNormal];
    [_navigationBarView addSubview:_addButton];
    [_addButton addTarget:self action:@selector(addCommunity) forControlEvents:UIControlEventTouchUpInside];
    
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.statusBarHeight + navigationBarHeight, selfViewWidth, selfViewHeight - (self.statusBarHeight + navigationBarHeight)) style:UITableViewStyleGrouped];
    
    [self addSubview:_mainTableView];
    _mainTableView.showsVerticalScrollIndicator = NO;
    _mainTableView.showsHorizontalScrollIndicator = NO;
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.sectionFooterHeight = 0;
    _mainTableView.sectionHeaderHeight = 0;
    _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    [_mainTableView registerClass:[CommunityTableViewCell class] forCellReuseIdentifier:@"normal"];
    [_mainTableView registerClass:[CommunityNoPictTableViewCell class] forCellReuseIdentifier:@"NoPict"];
    [_mainTableView registerClass:[CommunityOnePictTableViewCell class] forCellReuseIdentifier:@"OnePict"];
    [_mainTableView registerClass:[BrandNewTableViewCell class] forCellReuseIdentifier:@"new"];

//    _mainTableView.estimatedRowHeight = 100;
//    _mainTableView.rowHeight = UITableViewAutomaticDimension;
    
}

#pragma mark - tableViewDelegate/DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return _planTitleArray.count;
//    return 5;
    return _userNameArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 100;
//}

#pragma mark CellForRowAtIndexPath
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    /*
    NSArray *picts = [self.picturesArray objectAtIndex:indexPath.row];
    NSLog(@"%ld %ld", indexPath.row, picts.count);
    if (picts.count == 0) {
        
        CommunityNoPictTableViewCell *cell = [_mainTableView dequeueReusableCellWithIdentifier:@"NoPict" forIndexPath:indexPath];
        
        cell.nameLabel.text = [_userNameArray objectAtIndex:indexPath.row];
        cell.contentLabel.text = [_contentArray objectAtIndex:indexPath.row];
        
        [cell.headImage sd_setImageWithURL:[_headURLArray objectAtIndex:indexPath.row] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            NSLog(@"%@", error);
        }];
//        [cell layoutSubviews];
        return cell;
        
    } else if (picts.count == 1) {
        
        CommunityOnePictTableViewCell *cell = [_mainTableView dequeueReusableCellWithIdentifier:@"OnePict" forIndexPath:indexPath];
        
        cell.nameLabel.text = [_userNameArray objectAtIndex:indexPath.row];
        cell.contentLabel.text = [_contentArray objectAtIndex:indexPath.row];
//        [cell.imagesArray removeAllObjects];
        
        [cell.headImage sd_setImageWithURL:[_headURLArray objectAtIndex:indexPath.row] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            NSLog(@"%@", error);
        }];
        
//        [cell.imagesArray addObject:[UIImage imageNamed:@"defaultPict.png"]];
        [cell.firstImageView sd_setImageWithURL:[picts objectAtIndex:0] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            NSLog(@"%@", error);
            [cell layoutSubviews];
            [self.mainTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }];
//        [cell layoutSubview3s];
        return cell;
        
    } else {
        CommunityTableViewCell *cell = [_mainTableView dequeueReusableCellWithIdentifier:@"normal" forIndexPath:indexPath];
        
        cell.nameLabel.text = [_userNameArray objectAtIndex:indexPath.row];
        cell.contentLabel.text = [_contentArray objectAtIndex:indexPath.row];
        [cell.imagesArray removeAllObjects];
        cell.cellWidth = selfViewWidth;
        [cell.headImage sd_setImageWithURL:[_headURLArray objectAtIndex:indexPath.row] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            NSLog(@"%@", error);
            
        }];
        
        if (picts.count == 1) {
            [cell.imagesArray addObject:[UIImage imageNamed:@"defaultPict.png"]];
            [cell.firstImageView sd_setImageWithURL:[picts objectAtIndex:0] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                cell.firstImageView.image = [self scaleToSquare:image];
                NSLog(@"%@", error);
                [cell layoutSubviews];
                [self.mainTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }];
            cell.secondImageView.hidden = YES;
            cell.thirdImageView.hidden = YES;
            
            
        } else if (picts.count == 2) {
            [cell.imagesArray addObject:[UIImage imageNamed:@"defaultPict.png"]];
            [cell.imagesArray addObject:[UIImage imageNamed:@"defaultPict.png"]];
            [cell.firstImageView sd_setImageWithURL:[picts objectAtIndex:0] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                cell.firstImageView.image = [self scaleToSquare:image];
                NSLog(@"%@", error);
                [cell layoutSubviews];
                [self.mainTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }];
            [cell.secondImageView sd_setImageWithURL:[picts objectAtIndex:1] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                cell.secondImageView.image = [self scaleToSquare:image];
                NSLog(@"%@", error);
                [cell layoutSubviews];
                [self.mainTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }];
            cell.secondImageView.hidden = NO;
            cell.thirdImageView.hidden = YES;
        } else if (picts.count == 3) {
            [cell.imagesArray addObject:[UIImage imageNamed:@"defaultPict.png"]];
            [cell.imagesArray addObject:[UIImage imageNamed:@"defaultPict.png"]];
            [cell.imagesArray addObject:[UIImage imageNamed:@"defaultPict.png"]];
            [cell.firstImageView sd_setImageWithURL:[picts objectAtIndex:0] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                cell.firstImageView.image = [self scaleToSquare:image];
                NSLog(@"%@", error);
                [cell layoutSubviews];
                [self.mainTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }];
            [cell.secondImageView sd_setImageWithURL:[picts objectAtIndex:1] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                cell.secondImageView.image = [self scaleToSquare:image];
                NSLog(@"%@", error);
                [cell layoutSubviews];
                [self.mainTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }];
            [cell.thirdImageView sd_setImageWithURL:[picts objectAtIndex:2] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                cell.thirdImageView.image = [self scaleToSquare:image];
                NSLog(@"%@", error);
                [cell layoutSubviews];
                [self.mainTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }];
            cell.secondImageView.hidden = NO;
            cell.thirdImageView.hidden = NO;
        }
        
        return cell;
    }
    */
    BrandNewTableViewCell *cell = [_mainTableView dequeueReusableCellWithIdentifier:@"new"];
    cell.nameLabel.text = [_userNameArray objectAtIndex:indexPath.row];
    cell.contentLabel.text = [_contentArray objectAtIndex:indexPath.row];
    
    [cell.headImage sd_setImageWithURL:[_headURLArray objectAtIndex:indexPath.row] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        NSLog(@"%@", error);
    }];
    NSArray *picts = [self.picturesArray objectAtIndex:indexPath.row];
    if (picts.count == 0) {
        
        cell.number = 0;
        cell.firstImageView.hidden = YES;
        cell.secondImageView.hidden = YES;
        cell.thirdImageView.hidden = YES;
        
    } else if (picts.count == 1) {
        
        cell.number = 1;
        cell.firstImageView.hidden = NO;
        cell.secondImageView.hidden = YES;
        cell.thirdImageView.hidden = YES;
        [cell.firstImageView sd_setImageWithURL:[picts objectAtIndex:0] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            if (image) {
                CGSize size = CGSizeZero;
                if (image.size.width >= image.size.height) {
                    size = CGSizeMake(selfViewWidth * 0.7, selfViewWidth * 0.7 / image.size.width * image.size.height);
                } else {
                    size = CGSizeMake(selfViewWidth / 2, selfViewWidth / 2 / image.size.width * image.size.height);
                }
                cell.firstImageView.frame = CGRectMake(10, 60 + [self labelHeight:indexPath], size.width, size.height);
                [self.imageHeightArray replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithFloat:size.height + 10]];
                [cell layoutSubviews];
                [self.mainTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }
            
        }];
        
    } else if (picts.count == 2) {
        
        cell.number = 2;
        cell.firstImageView.hidden = NO;
        cell.secondImageView.hidden = NO;
        cell.thirdImageView.hidden = YES;
        [cell.firstImageView sd_setImageWithURL:[picts objectAtIndex:0] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [cell layoutSubviews];
//            [self.mainTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }];
        [cell.secondImageView sd_setImageWithURL:[picts objectAtIndex:1] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [cell layoutSubviews];
//            [self.mainTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }];
        
        
    } else {
        
        cell.number = 3;
        cell.firstImageView.hidden = NO;
        cell.secondImageView.hidden = NO;
        cell.thirdImageView.hidden = NO;
        [cell.firstImageView sd_setImageWithURL:[picts objectAtIndex:0] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [cell layoutSubviews];
//            [self.mainTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }];
        [cell.secondImageView sd_setImageWithURL:[picts objectAtIndex:1] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [cell layoutSubviews];
//            [self.mainTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }];
        [cell.thirdImageView sd_setImageWithURL:[picts objectAtIndex:2] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [cell layoutSubviews];
//            [self.mainTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSNumber *number = [_imageHeightArray objectAtIndex:indexPath.row];
    NSNumber *number2 = [_textHeightArray objectAtIndex:indexPath.row];
    return 70 + number.floatValue + number2.floatValue;
}

- (CGFloat)labelHeight:(NSIndexPath *)indexPath {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, selfViewWidth - 20, 10)];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.text = [_contentArray objectAtIndex:indexPath.row];
    [label sizeToFit];
    return label.frame.size.height;
}

- (CGFloat)textHeight:(NSString *)string {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, width - 20, 10)];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.text = string;
    [label sizeToFit];
    return label.frame.size.height;
}

- (CGFloat)size:(NSString*)text {
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16], NSFontAttributeName ,nil];
    NSLog(@"%lf", [text boundingRectWithSize:CGSizeMake(width - 20, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size.height);
    return [text boundingRectWithSize:CGSizeMake(width - 20, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size.height * 20.333 / 19.09;
}

- (void)pressHeadImageButton {
    [self.delegate openDrawerView];
}

- (void)updateHeadImage {
    UIImage *headImage = [UIImage imageWithData:[[LoginOrRegisterModel sharedModel] imageData]];
    [_headImageButton setBackgroundImage:headImage forState:UIControlStateNormal];
}

- (void)reloadAll {
    /*
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        sleep(0.3);
        
        
        [self->_headURLArray addObject:@"https://presist.oss-cn-beijing.aliyuncs.com/head/2022-02-23/621fd17248294f2a91f80c93190d7bf9-file"];
        [self->_headURLArray addObject:@"https://presist.oss-cn-beijing.aliyuncs.com/head/2022-02-23/621fd17248294f2a91f80c93190d7bf9-file"];
        [self->_headURLArray addObject:@"https://presist.oss-cn-beijing.aliyuncs.com/head/2022-02-23/621fd17248294f2a91f80c93190d7bf9-file"];
        
        [self->_userNameArray addObject:@"Billy"];
        [self->_userNameArray addObject:@"Billy"];
        [self->_userNameArray addObject:@"Billy"];
    
        [self->_contentArray addObject:@"在很多时候我们都需要使用进度条来帮助我们查看进度，iOS框架自带了progressView来供我们使用。可是，如果我们需要圆形的⭕️进度条，那么就需要我们自定义了。嘿嘿，下面来看看怎么搞。"];
        [self->_contentArray addObject:@"我们还可以同通过使用一系列属性，对这个进度条的各个方面进行一些改进："];
        [self->_contentArray addObject:@"也可以在上面添加渐变图层："];
        
        [self->_picturesArray addObject:[NSArray arrayWithObjects:@"https://presist.oss-cn-beijing.aliyuncs.com/head/2022-02-23/621fd17248294f2a91f80c93190d7bf9-file", @"https://presist.oss-cn-beijing.aliyuncs.com/head/2022-02-23/621fd17248294f2a91f80c93190d7bf9-file", @"https://presist.oss-cn-beijing.aliyuncs.com/head/2022-02-23/621fd17248294f2a91f80c93190d7bf9-file", nil]];
        [self->_picturesArray addObject:[[NSArray alloc] init]];
//        [self->_picturesArray addObject:[[NSArray alloc] init]];

        [self->_picturesArray addObject:[NSArray arrayWithObjects:@"https://presist.oss-cn-beijing.aliyuncs.com/head/2022-02-23/621fd17248294f2a91f80c93190d7bf9-file", nil]];
        
        [self->_headURLArray addObject:@"https://presist.oss-cn-beijing.aliyuncs.com/head/2022-02-23/621fd17248294f2a91f80c93190d7bf9-file"];
        [self->_headURLArray addObject:@"https://presist.oss-cn-beijing.aliyuncs.com/head/2022-02-23/621fd17248294f2a91f80c93190d7bf9-file"];
        [self->_headURLArray addObject:@"https://presist.oss-cn-beijing.aliyuncs.com/head/2022-02-23/621fd17248294f2a91f80c93190d7bf9-file"];
        
//        [self->_userNameArray addObject:@"Billy"];
//        [self->_userNameArray addObject:@"Billy"];
//        [self->_userNameArray addObject:@"Billy"];
    
        [self->_contentArray addObject:@"在很多时候我们都需要使用进度条来帮助我们查看进度，iOS框架自带了progressView来供我们使用。可是，如果我们需要圆形的⭕️进度条，那么就需要我们自定义了。嘿嘿，下面来看看怎么搞。"];
        [self->_contentArray addObject:@"我们还可以同通过使用一系列属性，对这个进度条的各个方面进行一些改进："];
        [self->_contentArray addObject:@"也可以在上面添加渐变图层："];
        
        [self->_picturesArray addObject:[NSArray arrayWithObjects:@"https://presist.oss-cn-beijing.aliyuncs.com/head/2022-02-23/621fd17248294f2a91f80c93190d7bf9-file", @"https://presist.oss-cn-beijing.aliyuncs.com/head/2022-02-23/621fd17248294f2a91f80c93190d7bf9-file", @"https://presist.oss-cn-beijing.aliyuncs.com/head/2022-02-23/621fd17248294f2a91f80c93190d7bf9-file", nil]];
        [self->_picturesArray addObject:[[NSArray alloc] init]];
//        [self->_picturesArray addObject:[[NSArray alloc] init]];

        [self->_picturesArray addObject:[NSArray arrayWithObjects:@"https://presist.oss-cn-beijing.aliyuncs.com/head/2022-02-23/621fd17248294f2a91f80c93190d7bf9-file", nil]];

        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.mainTableView reloadData];
        });
    });
    */
//    [self.mainTableView reloadData];
    float __block width = selfViewWidth;
    [[Manager sharedManager] NetworkGetCommunityFinished:^(CommunityModel *model) {
        [self.headURLArray removeAllObjects];
        [self.userNameArray removeAllObjects];
        [self.picturesArray removeAllObjects];
        [self.contentArray removeAllObjects];
        NSArray *dataArray = [model data];
//        NSLog(@"%@", dataArray);
        for (CommunityDataModel *dataModel in dataArray) {
            [self.headURLArray insertObject:[NSString stringWithFormat:@"https://presist.oss-cn-beijing.aliyuncs.com/%@", [dataModel headUrl]] atIndex:0];
            [self.userNameArray insertObject:[dataModel userName] atIndex:0];
            [self.contentArray insertObject:[dataModel content] atIndex:0];
            [self.textHeightArray insertObject:[NSNumber numberWithFloat:[self size:[dataModel content]]] atIndex:0];
            NSMutableArray *images = [[NSMutableArray alloc] init];
            if ([dataModel picture].count == 0) {
                [self.imageHeightArray insertObject:@0 atIndex:0];
            } else {
                [self.imageHeightArray insertObject:[NSNumber numberWithFloat:(width - 42) / 3 + 10] atIndex:0];
            }
            for (NSString *str in [dataModel picture]) {
                [images addObject:[NSString stringWithFormat:@"https://presist.oss-cn-beijing.aliyuncs.com/%@", str]];
            }
//            NSLog(@"%@", images);
            [self.picturesArray insertObject:images atIndex:0];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.mainTableView reloadData];
        });
        
    } error:^(NSError *error) {
            
    }];
    
}

- (void)addCommunity {
    
    [self.delegate addNewCommunity];
    
}

- (UIImage *)scaleToSquare:(UIImage *)img {
    CGSize size = CGSizeMake((img.size.height <= img.size.width ? img.size.height : img.size.width), (img.size.height <= img.size.width ? img.size.height : img.size.width));

    CGImageRef partOneImageRef = CGImageCreateWithImageInRect(img.CGImage, CGRectMake(0, 0, size.width, size.height));

    return [UIImage imageWithCGImage:partOneImageRef];
}

@end
