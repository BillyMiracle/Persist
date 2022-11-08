//
//  PersonalInfoPageController.m
//  Persist
//
//  Created by 张博添 on 2022/2/25.
//

#import "PersonalInfoPageController.h"
#import "PersonalInfoPageView.h"
#import "EditViewController.h"
#import "LoginOrRegisterModel.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "Manager.h"
#import "ChangeNameController.h"
#import "ChangeAgeController.h"

@interface PersonalInfoPageController ()
<PersonalInfoPageViewDelegate, UIGestureRecognizerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, EditDelegate>

@property (nonatomic, strong) PersonalInfoPageView *personalInfoPageView;

@property (nonatomic,strong) UIImagePickerController *headImagePickerController;
@property (nonatomic, strong) EditViewController *editViewController;
@property (nonatomic, copy) NSData *imageData;
@property (nonatomic, strong) NSString *userID;

@end

@implementation PersonalInfoPageController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        [self.navigationController.interactivePopGestureRecognizer setEnabled:YES];
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
    
    [self reload];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload) name:@"changeHeadImage" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload) name:@"changeGender" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload) name:@"changeName" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload) name:@"changeAge" object:nil];

    
    
    _personalInfoPageView = [[PersonalInfoPageView alloc] initWithFrame:self.view.frame];
    self.view = _personalInfoPageView;
    _personalInfoPageView.delegate = self;
}

- (void)pressBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIImagePickerController *)headImagePickerController {
    if (_headImagePickerController == nil) {
        _headImagePickerController = [[UIImagePickerController alloc] init];
        _headImagePickerController.delegate = self;
//        _headImagePickerController.allowsEditing = YES;
//        [[UIBarButtonItem appearance] setTintColor:[UIColor whiteColor]];
    }
    return _headImagePickerController;
}

#pragma mark - 更改头像
- (void)changeHeadImage {
    //UIAlertControllerStyleActionSheet弹窗在屏幕下面
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选取图片" message:nil preferredStyle: UIAlertControllerStyleActionSheet];
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
    
    _imageData = UIImagePNGRepresentation(imageEdited);
    
    //离线
//    [[LoginOrRegisterModel sharedModel] updateHeadImageWithData:self.imageData andHeadImagePath:@""];
//    [_editViewController dismissViewControllerAnimated:NO completion:^(void) {
//        [self.headImagePickerController dismissViewControllerAnimated:YES completion:^(void){
//            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                sleep(5);
//                [[LoginOrRegisterModel sharedModel] updateHeadImageWithData:self.imageData andHeadImagePath:@""];
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeHeadImage" object:nil];
//                });
//            });
//        }];
//    }];
    
    
    //在线
    [self upLoadHeadImage];
}

#pragma mark - 上传头像
- (void)upLoadHeadImage {
    [_editViewController dismissViewControllerAnimated:NO completion:^(void) {
        [self.headImagePickerController dismissViewControllerAnimated:YES completion:^(void) {
            
#pragma mark - 网路上传
            [[Manager sharedManager] NetworkUpdateHeadImageWithImage:[UIImage imageWithData:self->_imageData] andUserID:[[LoginOrRegisterModel sharedModel] userID] finished:^(NSString *path) {
                //上传成功
                NSLog(@"path = %@", path);
                [[LoginOrRegisterModel sharedModel] updateHeadImageWithData:self.imageData andHeadImagePath:path];
                dispatch_async(dispatch_get_main_queue(), ^{//通知上传成功
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeHeadImage" object:nil];
                });
                
            } error:^(NSError *error) {//上传失败
                
            }];
            

        }];
    }];
}

#pragma mark - 更改昵称
- (void)changeName {
    
    ChangeNameController *changeNameController = [[ChangeNameController alloc] init];
    [self presentViewController:changeNameController animated:YES completion:nil];
    
}

#pragma mark - 更改性别
- (void)changeGender {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"更改性别" message:nil preferredStyle: UIAlertControllerStyleActionSheet];
    UIAlertAction *maleAction = [UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *femaleAction = [UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) { }];
    [alert addAction:maleAction];
    [alert addAction:femaleAction];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - 更改年龄
- (void)changeAge {
    
    ChangeAgeController *changeAgeController = [[ChangeAgeController alloc] init];
    [self presentViewController:changeAgeController animated:YES completion:nil];
    
}


- (void)reload {
    [_personalInfoPageView reload];
}
@end
