//
//  RegisterController.m
//  Persist
//
//  Created by 张博添 on 2022/1/4.
//

#import "RegisterPageController.h"
#import "RegisterPageView.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "EditViewController.h"
#import "MainTabBarViewController.h"
#import "LoginOrRegisterModel.h"
#import "Manager.h"


static const NSString *passwordSetting = @"请设置登录密码";
static const NSString *headImageSetting = @"让大家更快记住你吧";
static const NSString *emailSetting = @"设置邮箱";
static const NSString *ageAndGenderSetting = @"完善资料";
static const NSString *nicknameSetting = @"设置一个适合你的昵称吧";

@interface RegisterPageController ()
<
UINavigationControllerDelegate,
UIImagePickerControllerDelegate,
EditDelegate
>
@property (nonatomic, strong) RegisterPageView *registerPageView;

@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *age;
@property (nonatomic, copy) NSString *gender;
@property (nonatomic, copy) NSData *imageData;

@property (nonatomic,strong) UIImagePickerController *headImagePickerController;

@property (nonatomic, strong) EditViewController *editViewController;
@property (nonatomic, strong) MainTabBarViewController *mainTabBarViewController;

@property (nonatomic, strong) NSString *userID;

@end

@implementation RegisterPageController

UTType *const UTTypeImage;
UTType *const UTTypeMovie;

- (void)viewDidLoad {
    [super viewDidLoad];
    _registerPageView = [[RegisterPageView alloc] initWithFrame:self.view.frame];
    self.view = _registerPageView;
    _registerPageView.titleLabel.text = [passwordSetting copy];
    [_registerPageView.confirmButton addTarget:self action:@selector(pressConfirm) forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark 收回键盘
- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_registerPageView.nameTextField resignFirstResponder];
    [_registerPageView.passwordTextFieldFirst resignFirstResponder];
    [_registerPageView.passwordTextFieldConfirm resignFirstResponder];
    [_registerPageView.emailTextField resignFirstResponder];
}

#pragma mark - 点击确认按钮
- (void)pressConfirm {
    if ([_registerPageView.titleLabel.text isEqualToString:[passwordSetting copy]]) {
        _password = [_registerPageView.passwordTextFieldFirst.text copy];
        [_registerPageView setNickname];
    } else if ([_registerPageView.titleLabel.text isEqualToString:[nicknameSetting copy]]) {
        _nickName = [_registerPageView.nameTextField.text copy];
        [_registerPageView setEmail];
    } else if ([_registerPageView.registerLabel.text isEqualToString:[emailSetting copy]]) {
        
        _email = [_registerPageView.emailTextField.text copy];
        [_registerPageView setAgeAndGender];
    } else if ([_registerPageView.registerLabel.text isEqualToString:[ageAndGenderSetting copy]]) {
        
        _age = _registerPageView.age;
        _gender = _registerPageView.gender;
        
        [_registerPageView setHeadImage];
    //添加手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singerTap:)];
        [_registerPageView.headImageView addGestureRecognizer:tap];
        
    } else if ([_registerPageView.titleLabel.text isEqualToString:[headImageSetting copy]]) {
        [_registerPageView setConfirmButtonOff];
        //离线
//        [[LoginOrRegisterModel sharedModel] updateInfoWithPhoneNum:_phoneNumber nickName:_nickName passWord:_password headImage:_imageData gender:_gender age:_age email:_email token:@"" userID:@"1" headImagePath:@""];
        
        //在线
        
        [[Manager sharedManager] NetworkRegisterWithData:@{@"phoneNumber": _phoneNumber, @"userName": _nickName, @"password": _password, @"gender": _gender, @"age": _age, @"email": _email} finished:^(NetworkLinkedLoginModel *model) {
            
            NSLog(@"%@", model);
            self->_userID = [model msg];
            
            //dispatch_async(dispatch_get_main_queue(), ^{
            [self upLoadHeadImage:self->_userID];
            //});
            [[Manager sharedManager] NetworkLoginWithData:@{@"phoneNumber":self.phoneNumber, @"password":self.password} finished:^(NetworkLinkedLoginModel *loginModel, NSString *token) {

                UserDataModel *dataModel = [loginModel data];
                
                NSString *name = [dataModel userName];
                NSString *phone = [dataModel phone];
                int age = [dataModel age];
                NSString *gender = [dataModel gender];
                NSString *password = [dataModel password];
                NSString *email = [dataModel email];
                NSString *userID = [dataModel uid];
                NSString *headURL = [dataModel headUrl];
                
                NSLog(@"%@", dataModel);
                
                [[LoginOrRegisterModel sharedModel] updateInfoWithPhoneNum:phone nickName:name passWord:password headImage:nil gender:gender age:[NSString stringWithFormat:@"%d", age] email:email token:token userID:userID headImagePath:headURL];
                [[Manager sharedManager] NetworkDownloadHeadImageWithURL:headURL Finished:^(NSData *imageData) {
                    
                    [[LoginOrRegisterModel sharedModel] updateHeadImageWithData:imageData andHeadImagePath:headURL];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self presentMainInterface];
                    });
                    
                } error:^(NSError *error) {
                    NSLog(@"头像下载失败");
                }];
                
                

                } error:^(NSError *error) {
                    NSLog(@"Login error");
            }];

        } error:^(NSError *error) {

        }];
        
        
        //离线
//        [self presentMainInterface];
    }
}
- (void)presentMainInterface {
    _mainTabBarViewController = [[MainTabBarViewController alloc] init];
    _mainTabBarViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:_mainTabBarViewController animated:YES completion:nil];
}

#pragma mark - 挑选头像的功能：
- (UIImagePickerController *)headImagePickerController {
    if (_headImagePickerController == nil) {
        _headImagePickerController = [[UIImagePickerController alloc] init];
        _headImagePickerController.delegate = self;
//        _headImagePickerController.allowsEditing = YES;
//        [[UIBarButtonItem appearance] setTintColor:[UIColor whiteColor]];
    }
    return _headImagePickerController;
}

- (void)singerTap:(UITapGestureRecognizer *)gesture {
    //UIAlertControllerStyleActionSheet弹窗在屏幕下面
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"选取图片" message:nil preferredStyle: UIAlertControllerStyleActionSheet];
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //点语法
        self.headImagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        self.headImagePickerController.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        self.headImagePickerController.modalPresentationStyle = UIModalPresentationFullScreen;
        self.headImagePickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        [self presentViewController:self.headImagePickerController animated:YES completion:nil];
    }];
    
    UIAlertAction *photosAlbumAction = [UIAlertAction actionWithTitle:@"图片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //点语法
        self.headImagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        self.headImagePickerController.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:self.headImagePickerController animated:YES completion:nil];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        
    }];
    //判断是否支持相机
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [alert addAction:cameraAction];
    }
    [alert addAction:photosAlbumAction];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}
//选中照片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    [self editImage:[info objectForKey: UIImagePickerControllerOriginalImage] controller:picker];
}
//弹出编辑界面
- (void)editImage:(UIImage*)image controller:(UIImagePickerController *)picker {
    
    _editViewController = [[EditViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:_editViewController];
    _editViewController.image = image;
    _editViewController.delegate = self;
    
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    [picker presentViewController:nav animated:YES completion:nil];
}

//代理函数，接收裁剪后图片
- (void)receiveImage:(UIImage *)imageEdited {
    _registerPageView.headImageView.image = imageEdited;
    _imageData = UIImagePNGRepresentation(imageEdited);
    
    [_editViewController dismissViewControllerAnimated:NO completion:^(void){
        [self->_headImagePickerController dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [_registerPageView setConfirmButtonOn];
}

#pragma mark - 上传头像
- (void)upLoadHeadImage:(NSString *)userID {
    
//    NSLog(@"%@", userID);
    //在线
    [[Manager sharedManager] NetworkUpLoadHeadImageWithImage:[UIImage imageWithData:self->_imageData] andUserID:userID finished:^(NSString *path) {
        
        
        NSLog(@"path = %@", path);
//        [[LoginOrRegisterModel sharedModel] updateInfoWithPhoneNum:self->_phoneNumber nickName:self->_nickName passWord:self->_password headImage:self->_imageData gender:self->_gender age:self->_age email:self->_email token:@"" userID:@"" headImagePath:path];
        [[LoginOrRegisterModel sharedModel] updateHeadImageWithData:self->_imageData andHeadImagePath:path];
        dispatch_async(dispatch_get_main_queue(), ^{//通知上传成功
            [[NSNotificationCenter defaultCenter] postNotificationName:@"changeHeadImage" object:nil];
        });
        
    } error:^(NSError *error) {
        
        NSLog(@"上传失败");
        
    }];
}

@end
#pragma mark - 学习内容：
//自定义裁剪照片界面，解决了横版照片会拉伸的问题
