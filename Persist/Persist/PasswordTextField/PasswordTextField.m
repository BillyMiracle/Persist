//
//  PasswordTextField.m
//  Persist
//
//  Created by 张博添 on 2022/1/7.
//

#import "PasswordTextField.h"

@implementation PasswordTextField
//密码输入框，不能够粘贴
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
//    if (action == @selector(paste:))//禁止粘贴
//        return NO;
//    if (action == @selector(select:))// 禁止选择
//        return NO;
//    if (action == @selector(selectAll:))// 禁止全选
//        return NO;
//    return [super canPerformAction:action withSender:sender];
    return NO;
}



@end
