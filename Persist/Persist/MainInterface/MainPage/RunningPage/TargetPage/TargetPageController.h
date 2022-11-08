//
//  TargetPageController.h
//  Persist
//
//  Created by 张博添 on 2022/2/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TargetPageControllerDelegate <NSObject>

- (void)getInfo:(NSDictionary *)infoDictionary;

@end

@interface TargetPageController : UIViewController

@property (nonatomic, weak) id <TargetPageControllerDelegate>delegate;

- (void)TPC_adjustTargetWithIndex:(NSInteger)indexOne and:(NSInteger)indexTwo;

@end

NS_ASSUME_NONNULL_END
