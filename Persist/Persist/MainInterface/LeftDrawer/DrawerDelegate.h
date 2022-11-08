//
//  DrawerDelegate.h
//  Persist
//
//  Created by 张博添 on 2022/1/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ControllersOpenDrawerDelegate <NSObject>

- (void)openTheDrawer;

@end

@interface DrawerDelegate : NSObject

@end

NS_ASSUME_NONNULL_END
