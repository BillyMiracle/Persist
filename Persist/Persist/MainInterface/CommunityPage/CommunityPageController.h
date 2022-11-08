//
//  CommunityPageController.h
//  Persist
//
//  Created by 张博添 on 2022/1/17.
//

#import <UIKit/UIKit.h>
#import "DrawerDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface CommunityPageController : UIViewController

@property (nonatomic, weak) id <ControllersOpenDrawerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
