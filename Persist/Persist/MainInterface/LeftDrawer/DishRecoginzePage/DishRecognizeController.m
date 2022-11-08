//
//  DishRecognizeController.m
//  Persist
//
//  Created by 张博添 on 2022/3/23.
//

#import "DishRecognizeController.h"
#import "DishRecognizeView.h"

#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import <MobileCoreServices/MobileCoreServices.h>

#import "DetailPage/DetailPageController.h"

#import "Manager.h"

@interface DishRecognizeController ()
<
UIGestureRecognizerDelegate,
DishRecognizeViewDelegate,
UINavigationControllerDelegate,
UIImagePickerControllerDelegate
>

@property (nonatomic,strong) UIImagePickerController *imagePickerController;

@property (nonatomic, copy) NSString *typeIdentifier;

@property (nonatomic, strong) DetailPageController *detailPageController;

@property (nonatomic, assign) BOOL isDish;

@end

@implementation DishRecognizeController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        [self.navigationController.interactivePopGestureRecognizer setEnabled:YES];
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    DishRecognizeView *dishRecognizeView = [[DishRecognizeView alloc] initWithFrame:self.view.frame];
    self.view = dishRecognizeView;
    dishRecognizeView.delegate = self;
}

- (void)pressBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)recognizeDish {
    self.isDish = YES;
    [self presentAlert];
}

- (void)recognizeVegetable {
    self.isDish = NO;
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
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 50, self.view.frame.size.width - 200, (self.view.frame.size.width - 200) / image.size.width * image.size.height)];
//    [imageView setImage:image];
//    [self.view addSubview:imageView];
    _detailPageController = [[DetailPageController alloc] init];
    NSData *imagedata = UIImageJPEGRepresentation(image, 0.9);
    NSString *image64 = [imagedata base64EncodedStringWithOptions:0];
    [_imagePickerController dismissViewControllerAnimated:YES completion:^{
        [self presentViewController:self.detailPageController animated:YES completion:^{
            /*
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                sleep(1);
                if (0) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.detailPageController presentError];
                    });
                } else {
                    [self.detailPageController.detailPageView.nameArray addObject:[NSString stringWithFormat:@"名字：%@", @"烧茄子"]];
                    [self.detailPageController.detailPageView.nameArray addObject:[NSString stringWithFormat:@"名字：%@", @"茄子煲"]];
                    [self.detailPageController.detailPageView.nameArray addObject:[NSString stringWithFormat:@"名字：%@", @"鱼香茄子"]];
                    [self.detailPageController.detailPageView.nameArray addObject:[NSString stringWithFormat:@"名字：%@", @"肉末茄子"]];
                    [self.detailPageController.detailPageView.nameArray addObject:[NSString stringWithFormat:@"名字：%@", @"酱茄子"]];
                    
                    [self.detailPageController.detailPageView.calorieArray addObject:[NSString stringWithFormat:@"卡路里：%@/100g", @74]];
                    [self.detailPageController.detailPageView.calorieArray addObject:[NSString stringWithFormat:@"卡路里：%@/100g", @137]];
                    [self.detailPageController.detailPageView.calorieArray addObject:[NSString stringWithFormat:@"卡路里：%@/100g", @85]];
                    [self.detailPageController.detailPageView.calorieArray addObject:[NSString stringWithFormat:@"卡路里：%@/100g", @137]];
                    [self.detailPageController.detailPageView.calorieArray addObject:[NSString stringWithFormat:@"卡路里：%@/100g", @30]];
                    
                    [self.detailPageController.detailPageView.imageURLArray addObject:@"NONE"];
                    [self.detailPageController.detailPageView.imageURLArray addObject:@"https://bkimg.cdn.bcebos.com/pic/7dd98d1001e9390112e6f92173ec54e737d196cc"];
                    [self.detailPageController.detailPageView.imageURLArray addObject:@"NONE"];
                    [self.detailPageController.detailPageView.imageURLArray addObject:@"NONE"];
                    [self.detailPageController.detailPageView.imageURLArray addObject:@"https://bkimg.cdn.bcebos.com/pic/b7fd5266d0160924ab18692f134d22fae6cd7b899ee6"];
                    
                    [self.detailPageController.detailPageView.detailArray addObject:@"无详细信息"];
                    [self.detailPageController.detailPageView.detailArray addObject:[NSString stringWithFormat:@"详细信息：%@", @"茄子煲是用茄子制作的一道家常菜，属于粤菜系。茄子的营养比较丰富，含有蛋白质、脂肪、碳水化合物、维生素以及钙、磷、铁等多种营养成分。主要有：水煮酿茄子煲、肉沫茄子煲、砂锅萝卜茄子煲等。"]];
                    [self.detailPageController.detailPageView.detailArray addObject:@"无详细信息"];
                    [self.detailPageController.detailPageView.detailArray addObject:@"无详细信息"];
                    [self.detailPageController.detailPageView.detailArray addObject:[NSString stringWithFormat:@"详细信息：%@", @"酱茄子是一道特色名菜，属于东北菜系，主要食材是茄子、酱，主要烹饪工艺是炒。成品呈黄褐色或者棕褐色，鲜嫩甘美，酱香浓郁，咸甜适口，略带酸味，肉质松软，风味独特。"]];
                    
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.detailPageController.detailPageView.targetImage = [image copy];
                        [self.detailPageController.detailPageView reloadTableView];
                    });
                }
            });
            */
#pragma mark 识别菜品
            if (self.isDish) {
                [[Manager sharedManager] NetworkDishRecognize:image64 finished:^(NSDictionary *dict) {
                    NSArray *dataArray = [dict objectForKey:@"result"];
                    NSLog(@"%@", dataArray);
                    BOOL judge = YES;
                    for (NSDictionary *result in dataArray) {
                        if ([[result objectForKey:@"name"] isEqualToString:@"非菜"]) {
                            judge = NO;
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self.detailPageController presentError];
                            });
                        } else {
                            //添加名字
                            [self.detailPageController.detailPageView.nameArray addObject:[NSString stringWithFormat:@"名字：%@", [result objectForKey:@"name"]]];
                            //添加卡路里
                            if ([NSString stringWithFormat:@"%@", [result valueForKey:@"has_calorie"]].intValue) {
                                [self.detailPageController.detailPageView.calorieArray addObject:[NSString stringWithFormat:@"卡路里：%@/100g", [result objectForKey:@"calorie"]]];
                            } else {
                                [self.detailPageController.detailPageView.calorieArray addObject:[NSString stringWithFormat:@"卡路里：0/100g"]];
                            }
                            NSDictionary *baike = [result objectForKey:@"baike_info"];
                            if ([baike objectForKey:@"description"]) {
                                NSLog(@"%@", baike);
                                [self.detailPageController.detailPageView.detailArray addObject:[NSString stringWithFormat:@"详细信息：%@", [baike objectForKey:@"description"]]];
                                [self.detailPageController.detailPageView.imageURLArray addObject:[baike objectForKey:@"image_url"]];
                            } else {
                                [self.detailPageController.detailPageView.imageURLArray addObject:@"NONE"];
                                [self.detailPageController.detailPageView.detailArray addObject:@"无详细信息"];
                            }
                        }
                    }
                    if (judge) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            self.detailPageController.detailPageView.isDish = YES;
                            self.detailPageController.detailPageView.targetImage = [image copy];
                            [self.detailPageController.detailPageView reloadTableView];
                        });
                    }
                    
                } error:^(NSError *error) {
                    
                }];
            } else {
#pragma mark 识别果蔬
                [[Manager sharedManager] NetworkVegetableRecognize:image64 finished:^(NSDictionary *dict) {
                    NSArray *dataArray = [dict objectForKey:@"result"];
                    NSLog(@"%@", dataArray);
                    BOOL judge = YES;
                    for (NSDictionary *result in dataArray) {
                        if ([[result objectForKey:@"name"] isEqualToString:@"非果蔬食材"]) {
                            if ([NSString stringWithFormat:@"%@", [result objectForKey:@"score"]].floatValue >= 0.5) {
                                judge = NO;
                            }
                        } else {
                            [self.detailPageController.detailPageView.nameArray addObject:[NSString stringWithFormat:@"名字：%@", [result objectForKey:@"name"]]];
                        }
                    }
                    if (self.detailPageController.detailPageView.nameArray.count != 0 && judge) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            self.detailPageController.detailPageView.isDish = NO;
                            self.detailPageController.detailPageView.targetImage = [image copy];
                            [self.detailPageController.detailPageView reloadTableView];
                        });
                    } else {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.detailPageController presentError];
                        });
                    }
                } error:^(NSError *error) {
                    
                }];
            }
                
        }];
    }];
}

@end
