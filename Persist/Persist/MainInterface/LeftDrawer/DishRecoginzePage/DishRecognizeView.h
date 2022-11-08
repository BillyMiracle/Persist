//
//  DishRecognizeView.h
//  Persist
//
//  Created by 张博添 on 2022/3/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol DishRecognizeViewDelegate <NSObject>

- (void)pressBack;
- (void)recognizeDish;
- (void)recognizeVegetable;


@end

@interface DishRecognizeView : UIView

@property (nonatomic, weak) id<DishRecognizeViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
