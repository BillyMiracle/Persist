//
//  MainPageController.h
//  Persist
//
//  Created by 张博添 on 2022/1/3.
//

#import <UIKit/UIKit.h>
#import "DrawerDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface MainPageController : UIViewController

@property (nonatomic, weak) id <ControllersOpenDrawerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
