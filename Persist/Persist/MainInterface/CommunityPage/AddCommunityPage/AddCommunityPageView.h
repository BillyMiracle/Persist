//
//  AddCommunityPageView.h
//  Persist
//
//  Created by 张博添 on 2022/4/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol AddCommunityPageViewDelegate <NSObject>

- (void)goBack;
- (void)showPicture:(UIImage *)image;
- (void)chooseImage;
- (void)confirm;

@end

@interface AddCommunityPageView : UIView

@property (nonatomic, weak) id <AddCommunityPageViewDelegate> delegate;

@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSMutableArray *updateImageArray;

- (void)addImage:(UIImage *)imageToBeAdded;

@end

NS_ASSUME_NONNULL_END
