//
//  CustomTextView.h
//  Persist
//
//  Created by 张博添 on 2022/4/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomTextView : UITextView

/*占位文字*/
@property (nonatomic,copy) NSString* placeholder;
/*占位文字颜色*/
@property (nonatomic, strong) UIColor *placeholderColor;

@end

NS_ASSUME_NONNULL_END
