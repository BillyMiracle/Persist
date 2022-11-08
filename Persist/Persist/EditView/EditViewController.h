//
//  EditViewController.h
//  Persist
//
//  Created by 张博添 on 2022/1/9.
//

#pragma mark - 头像照片编辑界面
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol EditDelegate <NSObject>

- (void)receiveImage:(UIImage *)imageEdited;

@end

@interface EditViewController : UIViewController

@property (nonatomic, weak) id<EditDelegate> delegate;

@property (nonatomic, strong) UIImage *image;

@end

NS_ASSUME_NONNULL_END
