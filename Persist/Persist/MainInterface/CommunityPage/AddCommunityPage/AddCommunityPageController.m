//
//  AddCommunityPageController.m
//  Persist
//
//  Created by 张博添 on 2022/4/11.
//

#import "AddCommunityPageController.h"
#import "AddCommunityPageView.h"

#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import <MobileCoreServices/MobileCoreServices.h>

#import "Manager.h"

@interface AddCommunityPageController ()
<UIGestureRecognizerDelegate, AddCommunityPageViewDelegate, AddCommunityPageViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) UIImagePickerController *imagePickerController;
@property (nonatomic, strong) AddCommunityPageView *addCommunityPageView;
@end

@implementation AddCommunityPageController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        [self.navigationController.interactivePopGestureRecognizer setEnabled:YES];
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _addCommunityPageView = [[AddCommunityPageView alloc] initWithFrame:self.view.frame];
    self.view = _addCommunityPageView;
    _addCommunityPageView.delegate = self;
}

- (void)goBack {
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
}

- (void)chooseImage {
    [self presentAlert];
}

- (UIImagePickerController *)imagePickerController {
    if (_imagePickerController == nil) {
        _imagePickerController = [[UIImagePickerController alloc] init];
        _imagePickerController.delegate = self;
//        _imagePickerController.allowsEditing = YES;
        _imagePickerController.view.backgroundColor = [UIColor lightGrayColor];
//        [[UIBarButtonItem appearance] setTintColor:[UIColor whiteColor]];
    }
    return _imagePickerController;
}

- (void)presentAlert {
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"选取图片" message:nil preferredStyle: UIAlertControllerStyleActionSheet];
    UIAlertAction *cameraAction=[UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        self->_imagePickerController.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        self->_imagePickerController.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:self->_imagePickerController animated:YES completion:nil];
    }];
    
    UIAlertAction *photosAlbumAction=[UIAlertAction actionWithTitle:@"图片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //点语法
        self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        self->_imagePickerController.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:self->_imagePickerController animated:YES completion:nil];
    }];
    
    UIAlertAction *cancelAction=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [alert addAction:cameraAction];
    }
    [alert addAction:photosAlbumAction];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
//    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [_addCommunityPageView addImage:image];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)confirm {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        [self.navigationController.interactivePopGestureRecognizer setEnabled:NO];
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
    [[Manager sharedManager] NetworkUploadCommunityWithContent:_addCommunityPageView.content andPicts:_addCommunityPageView.updateImageArray finished:^(CommunityModel *model) {
//        NSLog(@"%@", model);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
        
    } error:^(NSError *error) {
        
    }];
}

@end
