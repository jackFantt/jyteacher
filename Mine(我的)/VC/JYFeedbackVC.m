//
//  JYFeedbackVC.m
//  JYEducation
//
//  Created by 精英教育 on 2020/3/19.
//  Copyright © 2020 smart. All rights reserved.
//

#import "JYFeedbackVC.h"
#import "TZImagePickerController.h"
#import "UIView+Layout.h"
#import "TZTestCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "LxGridViewFlowLayout.h"
#import "TZImageManager.h"
#import "TZVideoPlayerController.h"
#import "TZPhotoPreviewController.h"
#import "TZGifPhotoPreviewController.h"
#import "TZLocationManager.h"

@interface JYFeedbackVC ()<UITextViewDelegate,UITextFieldDelegate,
TZImagePickerControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate,UINavigationControllerDelegate>
{
     UILabel *_placeholderLabel;
     UILabel * _numberLabel;
     BOOL _isSelectOriginalPhoto;
       CGFloat _itemWH;
       CGFloat _margin;
}
@property (nonatomic,strong) UIScrollView * scrolleView;
@property (nonatomic,strong) UITextView * textView;

//图片相关
@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (strong, nonatomic) LxGridViewFlowLayout *layout;
@property (strong, nonatomic) CLLocation *location;
@property (nonatomic,assign) BOOL showTakePhotoBtnSwitch;  ///< 在内部显示拍照按钮
@property (nonatomic,assign) BOOL sortAscendingSwitch;     ///< 照片排列按修改时间升序
@property (nonatomic,assign) BOOL allowPickingVideoSwitch; ///< 允许选择视频
@property (nonatomic,assign) BOOL allowPickingImageSwitch; ///< 允许选择图片
@property (nonatomic,assign) BOOL allowPickingGifSwitch;
@property (nonatomic,assign) BOOL allowPickingOriginalPhotoSwitch; ///< 允许选择原图
@property (nonatomic,assign) BOOL showSheetSwitch; ///< 显示一个sheet,把拍照按钮放在外面

@property (nonatomic,assign) NSInteger maxCountTF;  //照片最大可选张数，设置为1即为单选模式
@property (nonatomic,assign) NSInteger columnNumberTF;//每行照片展示照片数量

@property (assign, nonatomic)  BOOL allowCropSwitch;//可以剪裁
@property (assign, nonatomic)  BOOL needCircleCropSwitch;
@property (assign, nonatomic)  BOOL allowPickingMuitlpleVideoSwitch;

@property (nonatomic,strong) NSMutableArray * photoArray;
@property (nonatomic,strong) NSMutableArray * videoArray;
@property (nonatomic,assign) NSInteger typleteger;
@end

@implementation JYFeedbackVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTopViewWithTitle:@"意见反馈" withBackButton:YES viewColor:WhiteBackColor];
    self.typleteger = 2;
    self.maxCountTF = 6;
    self.columnNumberTF = 3;
    self.allowPickingImageSwitch = YES;
    self.showTakePhotoBtnSwitch = YES;
    self.sortAscendingSwitch = YES;
    self.allowPickingOriginalPhotoSwitch = YES;
    self.allowPickingVideoSwitch = NO;
    [self.view addSubview:self.scrolleView];
    [self configCollectionView];
    
}

- (void)configCollectionView {
    // 如不需要长按排序效果，将LxGridViewFlowLayout类改成UICollectionViewFlowLayout即可
    _layout = [[LxGridViewFlowLayout alloc] init];
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_layout];
    //CGFloat rgb = 244 / 255.0;
    _collectionView.alwaysBounceVertical = YES;
    _collectionView.backgroundColor = WhiteBackColor;
    _collectionView.contentInset = UIEdgeInsetsMake(4, 4, 4, 4);
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:_collectionView];
    [_collectionView registerClass:[TZTestCell class] forCellWithReuseIdentifier:@"TZTestCell"];
    
    
    
    UILabel * photoLabel = [UILabel wh_labelWithText:@"上传图片" textFont:16 textColor:RGBA(51, 51, 51, 1.0) frame:CGRectMake(MARGIN_OX, self.textView.bottom+20, ScreenWidth-MARGIN_OX*2, 20)];
    photoLabel.textAlignment = NSTextAlignmentLeft;
    photoLabel.font = [UIFont mediumWithSize:16];
    [self.scrolleView addSubview:photoLabel];
    
    _itemWH = 100;
      _margin = (ScreenWidth-300)/4;
      _layout.itemSize = CGSizeMake(_itemWH, _itemWH);
      _layout.minimumInteritemSpacing = _margin;
      _layout.minimumLineSpacing = _margin;
      _collectionView.backgroundColor = WhiteBackColor;
      _collectionView.scrollEnabled = NO;
      _collectionView.contentInset = UIEdgeInsetsMake(10, _margin, _margin, _margin);
      [self.collectionView setCollectionViewLayout:_layout];
      self.collectionView.frame = CGRectMake(0, photoLabel.bottom+10, self.view.tz_width, 230);
      [self.scrolleView addSubview:self.collectionView];
    
    
    UIButton * saveBtn = [UIButton wh_buttonWithTitle:@"提交反馈" backColor:RGBA(218, 171, 119, 1.0) backImageName:@"" titleColor:WhiteTextColor fontSize:16 frame:CGRectMake(MARGIN_OX, self.collectionView.bottom+30, ScreenWidth-MARGIN_OX*2, 36) cornerRadius:6.0];
    saveBtn.titleLabel.font = [UIFont mediumWithSize:14];
    
    [saveBtn addTarget:self action:@selector(feedbackClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrolleView addSubview:saveBtn];
    
    self.scrolleView.contentSize = CGSizeMake(ScreenWidth, saveBtn.bottom +30);
}

#pragma mark--提交反馈
-(void)feedbackClick:(UIButton *)btn{
    WEAKSELF();
    if (StringIsEmpty(self.textView.text)) {
        [[AXProgressHUDHelper getInstance]showTextWithStatus:@"请先输入反馈信息" onView:self.view];
        return;
    }
    NSString* msg = @"";
       if (_selectedPhotos && _selectedPhotos.count > 0) {
           msg = @"正在提交";
       }else{
           msg = @"正在提交";
       }
    NSDictionary * param = @{
                             @"content":self.textView.text,
                             @"imgUrl":@"feedback"
                             };
    [[AXProgressHUDHelper getInstance]showWithStatus: msg onView:self.view];
    
    [AFHttpOperation postRequestWithURL:KAPIJYfeedback parameters:param uploadFiles:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (_selectedPhotos && _selectedPhotos.count > 0) {
                                                        
                                                        for (NSInteger i =0; i<_selectedPhotos.count ; i++) {
                                                            
                                                            UIImage* image = _selectedPhotos[i];
                                                            NSData* imageData = UIImagePNGRepresentation(image);
                                                            NSString* sname = [NSString stringWithFormat:@"img_file[%ld]" , i];
                                                            
                                                            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                                                            formatter.dateFormat = @"yyyyMMddHHmmss";
                                                            NSString *str = [formatter stringFromDate:[NSDate date]];
                                                            NSString *fileName = [NSString stringWithFormat:@"%@_%ld.png", str , i];
                                                            
                                                            // 上传图片，以文件流的格式
                                                            [formData appendPartWithFileData:imageData name:sname fileName:fileName mimeType:@"image/png"];
                                                            
                                                        }
                                                        
                                                    }
        
    } success:^(id  _Nonnull responseObject) {
        NSLog(@"respont===%@",responseObject);
        [[AXProgressHUDHelper getInstance]dismissOnView:weakSelf.view];
        
    } failure:^(NSError * _Nonnull error) {
        [[AXProgressHUDHelper getInstance]dismissOnView:weakSelf.view];
        
    }];
}

#pragma mark--LZ
-(UIScrollView *)scrolleView{
    if (!_scrolleView) {
        _scrolleView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, NavitionbarHeight, ScreenWidth, ScreenHeight- NavitionbarHeight - BottomSafebarHeight)];
        if (@available(iOS 11.0, *)) {
               _scrolleView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;//UIScrollView也适用
           }else {
               self.automaticallyAdjustsScrollViewInsets = NO;
           }
        [_scrolleView addSubview:self.textView];
    }
    return _scrolleView;
}
-(UITextView *)textView{
    if (!_textView) {
        _textView = [[UITextView alloc]initWithFrame:CGRectMake(MARGIN_OX, 10, [self.scrolleView width]-MARGIN_OX*2, 250)];
        _textView.delegate = self;
        _textView.layer.masksToBounds = YES;
        _textView.layer.cornerRadius = 12.0f;
        _textView.layer.borderColor = [RGBA(229, 229, 229, 1.0) CGColor];
        _textView.layer.borderWidth = 0.5f;
        _textView.backgroundColor = RGBA(245, 245, 245, 1.0);
        
        _placeholderLabel = [UILabel wh_labelWithText:@"请简单描述您遇到的问题，我们将尽快改进" textFont:14 textColor:RGBA(153, 153, 153, 1.0) frame:CGRectMake(5, 5, 300, 20)];
        _placeholderLabel.textAlignment = NSTextAlignmentLeft;
        _placeholderLabel.font = [UIFont mediumWithSize:14];
        [_textView addSubview:_placeholderLabel];
        
        _numberLabel =[UILabel wh_labelWithText:@"0/200(不少于10个字)" textFont:14 textColor:RGBA(153, 153, 153, 1.0) frame:CGRectMake([_textView width]-5-200, [_textView height]-30, 200, 20)];
        _numberLabel.textAlignment = NSTextAlignmentRight;
        _numberLabel.font = [UIFont mediumWithSize:14];
        [_textView addSubview:_numberLabel];
    }
    return _textView;
}

#pragma mark ---textView代理方法---
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSString * toBeString = [textView.text stringByReplacingCharactersInRange:range withString:text];
    if (toBeString.length) {
        _placeholderLabel.text = @"";
    }
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    NSString * placeHodel = @"请简单描述您遇到的问题，我们将尽快改进";
    if (textView.text.length == 0) {
        _placeholderLabel.text = placeHodel;
        
    }
    return YES;
}
-(void)textViewDidChange:(UITextView *)textView{
    //实时显示字数
    _numberLabel.text = [NSString stringWithFormat:@"%ld/200(不少于10个字)",(long)textView.text.length];
    //字数限制
    if (textView.text.length >= 199) {
        textView.text = [textView.text substringToIndex:199];
    }
}


#pragma mark UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.typleteger == 3) {
        return 1;
    }else{
        return _selectedPhotos.count + 1;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TZTestCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TZTestCell" forIndexPath:indexPath];
    cell.videoImageView.hidden = YES;
    if (self.typleteger == 3) {
        if (ArrayIsEmpty(_selectedPhotos)) {
            cell.imageView.image = [UIImage imageNamed:@"jycommnetaddimage"];
            cell.deleteBtn.hidden = YES;
            cell.gifLable.hidden = YES;
        }else{
            
            cell.imageView.image = _selectedPhotos[indexPath.row];
            cell.asset = _selectedAssets[indexPath.row];
            cell.deleteBtn.hidden = NO;
        }
    }else{
        
        if (indexPath.row == _selectedPhotos.count) {
            cell.imageView.image = [UIImage imageNamed:@"jycommnetaddimage"];
            cell.deleteBtn.hidden = YES;
            cell.gifLable.hidden = YES;
        } else {
            cell.imageView.image = _selectedPhotos[indexPath.row];
            cell.asset = _selectedAssets[indexPath.row];
            cell.deleteBtn.hidden = NO;
        }
    }
    cell.deleteBtn.tag = indexPath.row;
    [cell.deleteBtn addTarget:self action:@selector(deleteBtnClik:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

-(void)pickerClick
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:  UIAlertControllerStyleActionSheet];
    //分别按顺序放入每个按钮；
   [alert.view setTranslatesAutoresizingMaskIntoConstraints:NO];
      [alert addAction:[UIAlertAction actionWithTitle:@"我的相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //点击按钮的响应事件；
          [self pushImagePickerController];
          
      }]];
     
      [alert addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //点击按钮的响应事件；
           [self takePhoto];
          
      }]];
     
      [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        //点击按钮的响应事件；
        NSLog(@"点击了取消");
      }]];
     
      //弹出提示框；
      alert.modalPresentationStyle = UIModalPresentationFullScreen;
      [self presentViewController:alert animated:true completion:nil];
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == _selectedPhotos.count) {
        BOOL showSheet = self.showSheetSwitch;
        if (showSheet) {
//            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"去相册选择", nil];
//            [sheet showInView:self.view];
            [self pickerClick];
        } else {
            [self pushTZImagePickerController];
        }
    } else { // preview photos or video / 预览照片或者视频
        id asset = _selectedAssets[indexPath.row];
        BOOL isVideo = NO;
        if ([asset isKindOfClass:[PHAsset class]]) {
            PHAsset *phAsset = asset;
            isVideo = phAsset.mediaType == PHAssetMediaTypeVideo;
        } else if ([asset isKindOfClass:[ALAsset class]]) {
            ALAsset *alAsset = asset;
            isVideo = [[alAsset valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypeVideo];
        }
        if ([[asset valueForKey:@"filename"] tz_containsString:@"GIF"] && self.allowPickingGifSwitch && !self.allowPickingMuitlpleVideoSwitch) {
            TZGifPhotoPreviewController *vc = [[TZGifPhotoPreviewController alloc] init];
            TZAssetModel *model = [TZAssetModel modelWithAsset:asset type:TZAssetModelMediaTypePhotoGif timeLength:@""];
            vc.model = model;
            vc.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:vc animated:YES completion:nil];
        } else if (isVideo && !self.allowPickingMuitlpleVideoSwitch) { // perview video / 预览视频
            TZVideoPlayerController *vc = [[TZVideoPlayerController alloc] init];
            TZAssetModel *model = [TZAssetModel modelWithAsset:asset type:TZAssetModelMediaTypeVideo timeLength:@""];
            vc.model = model;
            vc.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:vc animated:YES completion:nil];
        } else { // preview photos / 预览照片
            TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithSelectedAssets:_selectedAssets selectedPhotos:_selectedPhotos index:indexPath.row];
            imagePickerVc.maxImagesCount = self.maxCountTF;
            imagePickerVc.allowPickingGif = self.allowPickingGifSwitch;
            imagePickerVc.allowPickingOriginalPhoto = self.allowPickingOriginalPhotoSwitch;
            imagePickerVc.allowPickingMultipleVideo = self.allowPickingMuitlpleVideoSwitch;
            imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
            [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
                NSLog(@"imaepHoto==%@",photos);
                _selectedPhotos = [NSMutableArray arrayWithArray:photos];
                _selectedAssets = [NSMutableArray arrayWithArray:assets];
                _isSelectOriginalPhoto = isSelectOriginalPhoto;
                [_collectionView reloadData];
                _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
            }];
            imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:imagePickerVc animated:YES completion:nil];
        }
    }
}


#pragma mark - LxGridViewDataSource

/// 以下三个方法为长按排序相关代码
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.item < _selectedPhotos.count;
}

- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath canMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
    return (sourceIndexPath.item < _selectedPhotos.count && destinationIndexPath.item < _selectedPhotos.count);
}

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath didMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
    UIImage *image = _selectedPhotos[sourceIndexPath.item];
    NSLog(@"image==%@",image);
    [_selectedPhotos removeObjectAtIndex:sourceIndexPath.item];
    [_selectedPhotos insertObject:image atIndex:destinationIndexPath.item];
    
    id asset = _selectedAssets[sourceIndexPath.item];
    [_selectedAssets removeObjectAtIndex:sourceIndexPath.item];
    [_selectedAssets insertObject:asset atIndex:destinationIndexPath.item];
    
    [_collectionView reloadData];
    
}

#pragma mark - TZImagePickerController

- (void)pushTZImagePickerController {
    if (self.maxCountTF <= 0) {
        return;
    }
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:self.maxCountTF columnNumber:self.columnNumberTF delegate:self pushPhotoPickerVc:YES];
    
#pragma mark - 五类个性化设置，这些参数都可以不传，此时会走默认设置
    imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
    if (self.maxCountTF > 1) {
        // 1.设置目前已经选中的图片数组
        imagePickerVc.selectedAssets = _selectedAssets; // 目前已经选中的图片数组
        
    }
    imagePickerVc.allowTakePicture = self.showTakePhotoBtnSwitch; // 在内部显示拍照按钮
    
    
    // imagePickerVc.photoWidth = 1000;
    
    // 2. Set the appearance
    // 2. 在这里设置imagePickerVc的外观
    imagePickerVc.navigationBar.barTintColor = RGBA(66, 66, 66, 66);
    imagePickerVc.oKButtonTitleColorDisabled = [UIColor lightGrayColor];
    imagePickerVc.oKButtonTitleColorNormal = [UIColor greenColor];
    imagePickerVc.navigationBar.translucent = NO;
    
    // 3. Set allow picking video & photo & originalPhoto or not
    // 3. 设置是否可以选择视频/图片/原图
    imagePickerVc.allowPickingVideo = self.allowPickingVideoSwitch;
    imagePickerVc.allowPickingImage = self.allowPickingImageSwitch;
    imagePickerVc.allowPickingOriginalPhoto = self.allowPickingOriginalPhotoSwitch;
    imagePickerVc.allowPickingGif = self.allowPickingGifSwitch;
    imagePickerVc.allowPickingMultipleVideo = self.allowPickingMuitlpleVideoSwitch; // 是否可以多选视频
    
    // 4. 照片排列按修改时间升序
    imagePickerVc.sortAscendingByModificationDate = self.sortAscendingSwitch;
    
    // imagePickerVc.minImagesCount = 3;
    // imagePickerVc.alwaysEnableDoneBtn = YES;
    
    // imagePickerVc.minPhotoWidthSelectable = 3000;
    // imagePickerVc.minPhotoHeightSelectable = 2000;
    
    /// 5. Single selection mode, valid when maxImagesCount = 1
    /// 5. 单选模式,maxImagesCount为1时才生效
    imagePickerVc.showSelectBtn = NO;
    imagePickerVc.allowCrop = self.allowCropSwitch;
    imagePickerVc.needCircleCrop = self.needCircleCropSwitch;
    // 设置竖屏下的裁剪尺寸
    NSInteger left = 30;
    NSInteger widthHeight = self.view.tz_width - 2 * left;
    NSInteger top = (self.view.tz_height - widthHeight) / 2;
    imagePickerVc.cropRect = CGRectMake(left, top, widthHeight, widthHeight);
    // 设置横屏下的裁剪尺寸
    // imagePickerVc.cropRectLandscape = CGRectMake((self.view.tz_height - widthHeight) / 2, left, widthHeight, widthHeight);
    /*
     [imagePickerVc setCropViewSettingBlock:^(UIView *cropView) {
     cropView.layer.borderColor = [UIColor redColor].CGColor;
     cropView.layer.borderWidth = 2.0;
     }];*/
    
    //imagePickerVc.allowPreview = NO;
    // 自定义导航栏上的返回按钮
    /*
     [imagePickerVc setNavLeftBarButtonSettingBlock:^(UIButton *leftButton){
     [leftButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
     [leftButton setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 20)];
     }];
     imagePickerVc.delegate = self;
     */
    
    imagePickerVc.isStatusBarDefault = NO;
#pragma mark - 到这里为止
    
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
        NSLog(@"photos==%@",photos);
        
    }];
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

#pragma mark - UIImagePickerController

- (void)takePhoto {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if ((authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) && iOS7Later) {
        // 无相机权限 做一个友好的提示
//        if (iOS8Later) {
            UIAlertController *controller=[UIAlertController alertControllerWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" preferredStyle:UIAlertControllerStyleAlert];
                   UIAlertAction *sure=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                    }];
                   UIAlertAction *cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                       
                   }];
                   [controller addAction:sure];
                   [controller addAction:cancel];
                   [self presentViewController:controller animated:YES completion:nil];
//        } else {
//            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
//            [alert show];
//        }
    } else if (authStatus == AVAuthorizationStatusNotDetermined) {
        // fix issue 466, 防止用户首次拍照拒绝授权时相机页黑屏
        if (iOS7Later) {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [self takePhoto];
                    });
                }
            }];
        } else {
            [self takePhoto];
        }
        // 拍照之前还需要检查相册权限
    } else if ([TZImageManager authorizationStatus] == 2) { // 已被拒绝，没有相册权限，将无法保存拍的照片
//        if (iOS8Later) {
//            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
//            [alert show];
//        } else {
//            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
//            [alert show];
//        }
        
        UIAlertController *controller=[UIAlertController alertControllerWithTitle:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" preferredStyle:UIAlertControllerStyleAlert];
                          UIAlertAction *sure=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                               [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                           }];
                          UIAlertAction *cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                              
                          }];
                          [controller addAction:sure];
                          [controller addAction:cancel];
                          [self presentViewController:controller animated:YES completion:nil];
    } else if ([TZImageManager authorizationStatus] == 0) { // 未请求过相册权限
        [[TZImageManager manager] requestAuthorizationWithCompletion:^{
            [self takePhoto];
        }];
    } else {
        [self pushImagePickerController];
    }
}

// 调用相机
- (void)pushImagePickerController {
    // 提前定位
    __weak typeof(self) weakSelf = self;
    [[TZLocationManager manager] startLocationWithSuccessBlock:^(CLLocation *location, CLLocation *oldLocation) {
        weakSelf.location = location;
    } failureBlock:^(NSError *error) {
        weakSelf.location = nil;
    }];
    
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        self.imagePickerVc.sourceType = sourceType;
        if(iOS8Later) {
            _imagePickerVc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        }
        [self presentViewController:_imagePickerVc animated:YES completion:nil];
    } else {
        NSLog(@"模拟器中无法打开照相机,请在真机中使用");
    }
}

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        TZImagePickerController *tzImagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
        tzImagePickerVc.sortAscendingByModificationDate = self.sortAscendingSwitch;
        [tzImagePickerVc showProgressHUD];
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        // save photo and get asset / 保存图片，获取到asset
        [[TZImageManager manager] savePhotoWithImage:image location:self.location completion:^(NSError *error){
            if (error) {
                [tzImagePickerVc hideProgressHUD];
                NSLog(@"图片保存失败 %@",error);
            } else {
                [[TZImageManager manager] getCameraRollAlbum:NO allowPickingImage:YES completion:^(TZAlbumModel *model) {
                    [[TZImageManager manager] getAssetsFromFetchResult:model.result allowPickingVideo:NO allowPickingImage:YES completion:^(NSArray<TZAssetModel *> *models) {
                        [tzImagePickerVc hideProgressHUD];
                        TZAssetModel *assetModel = [models firstObject];
                        if (tzImagePickerVc.sortAscendingByModificationDate) {
                            assetModel = [models lastObject];
                        }
                        if (self.allowCropSwitch) { // 允许裁剪,去裁剪
                            TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initCropTypeWithAsset:assetModel.asset photo:image completion:^(UIImage *cropImage, id asset) {
                                [self refreshCollectionViewWithAddedAsset:asset image:cropImage];
                            }];
                            imagePicker.needCircleCrop = self.needCircleCropSwitch;
                            imagePicker.circleCropRadius = 100;
                            [self presentViewController:imagePicker animated:YES completion:nil];
                        } else {
                            [self refreshCollectionViewWithAddedAsset:assetModel.asset image:image];
                        }
                    }];
                }];
            }
        }];
    }
}

- (void)refreshCollectionViewWithAddedAsset:(id)asset image:(UIImage *)image {
    [_selectedAssets addObject:asset];
    [_selectedPhotos addObject:image];
    [_collectionView reloadData];
    
    if ([asset isKindOfClass:[PHAsset class]]) {
        PHAsset *phAsset = asset;
        NSLog(@"location:%@",phAsset.location);
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    if ([picker isKindOfClass:[UIImagePickerController class]]) {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) { // take photo / 去拍照
        [self takePhoto];
    } else if (buttonIndex == 1) {
        [self pushTZImagePickerController];
    }
}

#pragma mark - UIAlertViewDelegate

//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
//    if (buttonIndex == 1) { // 去设置界面，开启相机访问权限
//        if (iOS8Later) {
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
//        }
//    }
//}

#pragma mark - TZImagePickerControllerDelegate

/// User click cancel button
/// 用户点击了取消
- (void)tz_imagePickerControllerDidCancel:(TZImagePickerController *)picker {
    // NSLog(@"cancel");
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    _selectedPhotos = [NSMutableArray arrayWithArray:photos];
    _selectedAssets = [NSMutableArray arrayWithArray:assets];
    NSLog(@"photo==%@,assest==%@",photos, assets);
    _isSelectOriginalPhoto = isSelectOriginalPhoto;
    [_collectionView reloadData];
    
    
    // 1.打印图片名字
    [self printAssetsName:assets];
    
    //    for (id asset in assets) {
    //        [[TZImageManager manager] getPhotoWithAsset:asset completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
    //            NSLog(@"照片==%@",photo);
    //            //加密解秘都是对二进制进行处理
    //            NSData *data =UIImagePNGRepresentation(photo);
    //
    //            //指定编码方式.默认0
    //            NSString *base64String= [data base64EncodedStringWithOptions:0];
    //
    //            if (!StringIsEmpty(base64String)) {
    //
    //
    //           // base64String=[@"data:image/png;base64," stringByAppendingString:base64String];///php服务器上面要加上@"data:image/png;base64,"
    //            base64String = StringAddString(@"data:image/png;base64,", base64String);
    //            NSLog(@"str==%@",base64String);
    //            [self.photoArray addObject:base64String];
    //            }
    //
    //        }];
    //    }
    //   [[TZImageManager manager] getVideoWithAsset:asset completion:^(AVPlayerItem *playerItem, NSDictionary *info) {
    //            NSLog(@"play==%@  info==%@",playerItem,info);
    //            NSURL * url = [NSURL URLWithString:@"https://cvws.icloud-content.com/B/AZj13LW-QMIZF5303szcS3NHToIQAd-cRfjsualg6bI7nNNeMmEJCJLc/IMG_1628.medium.MP4?o=AneJIoigg-ItxcUKdbCbHlJ8_1jnfIx8h6hu8kP6R9uc&v=1&x=3&a=BT5DrRC-QiJSA6IQPw&e=1510285502&k=3-J02zWTP6qvI4dZT8J1yQ&fl=&r=671A0799-5E95-4246-A50F-3486E8989A40-1&ckc=com.apple.photos.cloud&ckz=PrimarySync&y=1&p=56&s=_1ZUm5rU4u0Fj3VWlSHJjuo2DNY"];
    //            NSData * data =[NSData dataWithContentsOfURL:url];
    //            NSLog(@"data==%@",data);
    // }];
    
    //        [[TZImageManager manager]getVideoOutputPathWithAsset:asset completion:^(NSString *outputPath) {
    //            NSLog(@"out==%@",outputPath);
    //           // [self videoDataWithPath:outputPath];
    //
    //        }];
    //}
    
}

-(void)getnewfilesize:(NSString *)path{
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:path] options:nil];
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    
    if ([compatiblePresets containsObject:AVAssetExportPresetLowQuality])
        
    {
        
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc]initWithAsset:avAsset presetName:AVAssetExportPresetPassthrough];
        NSString *exportPath = [NSString stringWithFormat:@"%@/%@.mp4",
                                [NSHomeDirectory() stringByAppendingString:@"/tmp"],
                                @"1"];
        exportSession.outputURL = [NSURL fileURLWithPath:exportPath];
        NSLog(@"%@", exportPath);
        NSString * vieoSize = [self getfileSize:exportPath];
        CGFloat  size = [vieoSize floatValue];
        NSLog(@"%@   size===%f", exportPath,size);
        exportSession.outputFileType = AVFileTypeMPEG4;
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            
            switch ([exportSession status]) {
                case AVAssetExportSessionStatusFailed:
                    NSLog(@"Export failed: %@", [[exportSession error] localizedDescription]);
                    break;
                case AVAssetExportSessionStatusCancelled:
                    NSLog(@"Export canceled");
                    break;
                case AVAssetExportSessionStatusCompleted:
                    NSLog(@"转换成功");
                    break;
                default:
                    break;
            }
        }];
    }
}

//文件大小计算
- (NSString *)getfileSize:(NSString *)path
{
    NSDictionary *outputFileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
    NSLog (@"file size: %f", (unsigned long long)[outputFileAttributes fileSize]/1024.00 /1024.00);
    CGFloat data = (CGFloat)[outputFileAttributes fileSize]/1024.00 /1024.00;
    NSString *dataSiz = [NSString stringWithFormat:@"%.1f",data];
    return dataSiz;
    
}

-(void)videoDataWithPath:(NSString *)outPath{
    //转码配置
    NSURL * outUrl = [NSURL fileURLWithPath:outPath];
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:outUrl options:nil];
    AVAssetExportSession *exportSession= [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPresetMediumQuality];
    exportSession.shouldOptimizeForNetworkUse = YES;
    exportSession.outputURL = [NSURL fileURLWithPath:outPath];
    exportSession.outputFileType = AVFileTypeMPEG4;
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        int exportStatus = exportSession.status;
        NSLog(@"%d",exportStatus);
        switch (exportStatus)
        {
            case AVAssetExportSessionStatusFailed:
            {
                // log error to text view
                NSError *exportError = exportSession.error;
                NSLog (@"AVAssetExportSessionStatusFailed: %@", exportError);
                break;
            }
            case AVAssetExportSessionStatusCompleted:
            {
                
                NSData *data = [NSData dataWithContentsOfFile:outPath];
                NSLog(@"视频转码成功==%@",data);
            }
        }
    }];
}

// 如果用户选择了一个视频，下面的handle会被执行
// 如果系统版本大于iOS8，asset是PHAsset类的对象，否则是ALAsset类的对象
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(id)asset {
    _selectedPhotos = [NSMutableArray arrayWithArray:@[coverImage]];
    _selectedAssets = [NSMutableArray arrayWithArray:@[asset]];
    // open this code to send video / 打开这段代码发送视频
    // [[TZImageManager manager] getVideoOutputPathWithAsset:asset completion:^(NSString *outputPath) {
    // NSLog(@"视频导出到本地完成,沙盒路径为:%@",outputPath);
    // Export completed, send video here, send by outputPath or NSData
    // 导出完成，在这里写上传代码，通过路径或者通过NSData上传
    
    // }];
    [_collectionView reloadData];
    // _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
}

// If user picking a gif image, this callback will be called.
// 如果用户选择了一个gif图片，下面的handle会被执行
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingGifImage:(UIImage *)animatedImage sourceAssets:(id)asset {
    _selectedPhotos = [NSMutableArray arrayWithArray:@[animatedImage]];
    _selectedAssets = [NSMutableArray arrayWithArray:@[asset]];
    [_collectionView reloadData];
}

// Decide album show or not't
// 决定相册显示与否
- (BOOL)isAlbumCanSelect:(NSString *)albumName result:(id)result {
    /*
     if ([albumName isEqualToString:@"个人收藏"]) {
     return NO;
     }
     if ([albumName isEqualToString:@"视频"]) {
     return NO;
     }*/
    return YES;
}

// Decide asset show or not't
// 决定asset显示与否
- (BOOL)isAssetCanSelect:(id)asset {
    /*
     if (iOS8Later) {
     PHAsset *phAsset = asset;
     switch (phAsset.mediaType) {
     case PHAssetMediaTypeVideo: {
     // 视频时长
     // NSTimeInterval duration = phAsset.duration;
     return NO;
     } break;
     case PHAssetMediaTypeImage: {
     // 图片尺寸
     if (phAsset.pixelWidth > 3000 || phAsset.pixelHeight > 3000) {
     // return NO;
     }
     return YES;
     } break;
     case PHAssetMediaTypeAudio:
     return NO;
     break;
     case PHAssetMediaTypeUnknown:
     return NO;
     break;
     default: break;
     }
     } else {
     ALAsset *alAsset = asset;
     NSString *alAssetType = [[alAsset valueForProperty:ALAssetPropertyType] stringValue];
     if ([alAssetType isEqualToString:ALAssetTypeVideo]) {
     // 视频时长
     // NSTimeInterval duration = [[alAsset valueForProperty:ALAssetPropertyDuration] doubleValue];
     return NO;
     } else if ([alAssetType isEqualToString:ALAssetTypePhoto]) {
     // 图片尺寸
     CGSize imageSize = alAsset.defaultRepresentation.dimensions;
     if (imageSize.width > 3000) {
     // return NO;
     }
     return YES;
     } else if ([alAssetType isEqualToString:ALAssetTypeUnknown]) {
     return NO;
     }
     }*/
    return YES;
}

#pragma mark - Click Event

- (void)deleteBtnClik:(UIButton *)sender {
    [_selectedPhotos removeObjectAtIndex:sender.tag];
    [_selectedAssets removeObjectAtIndex:sender.tag];
    if (self.typleteger == 3) {
        [_collectionView reloadData];
    }else{
        
        [_collectionView performBatchUpdates:^{
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:sender.tag inSection:0];
            [_collectionView deleteItemsAtIndexPaths:@[indexPath]];
        } completion:^(BOOL finished) {
            [_collectionView reloadData];
        }];
    }
}

- (void)commonPushBack{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"MediaPhotoCancle" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark--ImagePickVC
- (UIImagePickerController *)imagePickerVc {
    if (_imagePickerVc == nil) {
        _imagePickerVc = [[UIImagePickerController alloc] init];
        _imagePickerVc.delegate = self;
        // set appearance / 改变相册选择页的导航栏外观
        _imagePickerVc.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
        _imagePickerVc.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
        UIBarButtonItem *tzBarItem, *BarItem;
        if (iOS9Later) {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
            BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        } else {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedIn:[TZImagePickerController class], nil];
            BarItem = [UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil];
        }
        NSDictionary *titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
        [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
        
    }
    return _imagePickerVc;
}

#pragma mark - Private

/// 打印图片名字
- (void)printAssetsName:(NSArray *)assets {
    NSString *fileName;
    for (id asset in assets) {
        if ([asset isKindOfClass:[PHAsset class]]) {
            PHAsset *phAsset = (PHAsset *)asset;
            fileName = [phAsset valueForKey:@"filename"];
        } else if ([asset isKindOfClass:[ALAsset class]]) {
            ALAsset *alAsset = (ALAsset *)asset;
            fileName = alAsset.defaultRepresentation.filename;;
        }
        NSLog(@"图片名字:%@",fileName);
    }
}

#pragma mark - 懒加载
-(NSMutableArray *)photoArray{
    if (_photoArray == nil) {
        _photoArray = [NSMutableArray new];
    }
    return _photoArray;
}
-(NSMutableArray *)videoArray{
    if (_videoArray == nil) {
        _videoArray = [NSMutableArray new];
    }
    return _videoArray;
}
-(NSMutableArray *)selectedPhotos{
    if (_selectedPhotos == nil) {
        _selectedPhotos = [NSMutableArray new];
    }
    return _selectedPhotos;
}
-(NSMutableArray *)selectedAssets{
    if (_selectedAssets == nil) {
        _selectedAssets = [NSMutableArray new];
    }
    return _selectedAssets;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

