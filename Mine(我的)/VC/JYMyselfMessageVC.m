//
//  JYMyselfMessageVC.m
//  JYEducation
//
//  Created by 精英教育 on 2020/3/18.
//  Copyright © 2020 smart. All rights reserved.
//

#import "JYMyselfMessageVC.h"
#import "HQPickerView.h"
#import "MediaDatePickView.h"
#import <Photos/Photos.h>
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>

@interface JYMyselfMessageVC ()<HQPickerViewDelegate,MediaDatePickDelegate>
{
    UITextField * rightText[2];
    UILabel * rightLabel[3];
}
@property (nonatomic, strong) MediaDatePickView *dateView;
@property (nonatomic,strong) UIImageView * touIcon;
@property (nonatomic,copy) NSArray * leftArr;
@property (nonatomic,copy) NSArray * rightArr;

@end

@implementation JYMyselfMessageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTopViewWithTitle:@"个人信息" withBackButton:YES viewColor:WhiteBackColor];
    self.view.backgroundColor = RGBA(245, 245, 245, 1.0);
    [self createUI];
}
-(void)createUI{
    for (int i = 0; i<self.leftArr.count; i++) {
        UIView * view = [self createTypeView:i leftTitle:self.leftArr[i] rightTitle:self.rightArr[i] maroignOy:NavitionbarHeight+15+i*(60+1)];
        [self.view addSubview:view];
    }
    
    UIButton * saveBtn = [UIButton wh_buttonWithTitle:@"保存" backColor:RGBA(218, 171, 119, 1.0) backImageName:@"" titleColor:WhiteTextColor fontSize:16 frame:CGRectMake(MARGIN_OX, NavitionbarHeight+15+self.leftArr.count*61+MARGIN_OY, ScreenWidth-MARGIN_OX*2, 36) cornerRadius:6.0];
    saveBtn.titleLabel.font = [UIFont mediumWithSize:14];
    [self.view addSubview:saveBtn];
}
#pragma mark--分层View
-(UIView *)createTypeView:(NSInteger)viewTag leftTitle:(NSString *)leftTitle rightTitle:(NSString *)rightTitle maroignOy:(CGFloat)mar_oy{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, mar_oy, ScreenWidth, 60+1)];
    view.backgroundColor = WhiteBackColor;
    
    //left
    UILabel * leftLabel = [UILabel wh_labelWithText:leftTitle textFont:16 textColor:RGBA(51, 51, 51, 1.0) frame:CGRectMake(MARGIN_OX, 20, 100, 20)];
    leftLabel.textAlignment = NSTextAlignmentLeft;
    leftLabel.font = [UIFont mediumWithSize:16];
    [view addSubview:leftLabel];
    
//    UIImageView * rightImage = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth-MARGIN_OX-7, leftLabel.centerY-5.5, 7, 11)];
//    rightImage.image = [UIImage imageNamed:@"灰色箭头"];
//    [view addSubview:rightImage];
    
    if (viewTag == 0) {
        //右侧头像
        self.touIcon = [[UIImageView alloc]initWithFrame:CGRectMake([view width]-MARGIN_OX-55, 2.5, 55, 55)];
//        self.touIcon.backgroundColor = RGBA(2, 60, 245, 1.0);
        self.touIcon.userInteractionEnabled = YES;
        self.touIcon.layer.masksToBounds = YES;
        self.touIcon.layer.cornerRadius = 27.5f;
        self.touIcon.image = [UIImage imageNamed:@"默认头像"];
//        self.touIcon.layer.borderColor = [[UIColor whiteColor] CGColor];
//        self.touIcon.layer.borderWidth = 2.5f;
        [view addSubview:self.touIcon];
                 
        UITapGestureRecognizer * tougester = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pickerClick)];
        [self.touIcon addGestureRecognizer:tougester];
    }else if (viewTag == 1 || viewTag == 2){
        NSInteger i = viewTag -1;
        rightText[i] = [[UITextField alloc]initWithFrame:CGRectMake([view width]-MARGIN_OX-120,10, 120, 40)];
               rightText[i].backgroundColor = [UIColor clearColor];
               rightText[i].font = [UIFont systemFontOfSize:15];
               rightText[i].textColor = HexadecimalColor(@"#333333");
               rightText[i].textAlignment = NSTextAlignmentRight;
               rightText[i].returnKeyType = UIReturnKeyDone;
        if (viewTag == 2) {
            rightText[i].keyboardType = UIKeyboardTypeNumberPad;
        }
               
               //ios13
               // 就下面这两行是重点
                  NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:rightTitle attributes:
                  @{NSForegroundColorAttributeName:HexadecimalColor(@"#CCCCCC"),
                               NSFontAttributeName:[UIFont systemFontOfSize:15]
                       }];
                  rightText[i].attributedPlaceholder = attrString;
              
               [view addSubview:rightText[i]];
        
    }else{
        NSInteger i = viewTag -3;
        view.tag = 10 + i;
        rightLabel[i] = [UILabel wh_labelWithText:rightTitle textFont:15 textColor:HexadecimalColor(@"CCCCCC") frame:CGRectMake([view width]-MARGIN_OX-120, 20, 120, 20)];
        rightLabel[i].textAlignment = NSTextAlignmentRight;
        [view addSubview:rightLabel[i]];
        
        UITapGestureRecognizer * tougester = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showSelectedPickedView:)];
        [view addGestureRecognizer:tougester];
    }
    
    UIView * linevIew = [[UIView alloc]initWithFrame:CGRectMake(MARGIN_OX, 60, ScreenWidth-MARGIN_OX*2, 1)];
    linevIew.backgroundColor = RGBA(230, 230, 230, 1.0);
    
    [view addSubview:linevIew];
    
    return view;
    
}

#pragma mark--UITapGestureRecognizer
-(void)showSelectedPickedView:(UITapGestureRecognizer *)gester{
    [rightText[0] resignFirstResponder];
    [rightText[1] resignFirstResponder];
    if (gester.view.tag == 10) {
        //选择性别
        [self seletSex];
    }else if (gester.view.tag == 11){
        //选择生日
        [self seletbirth];
    }else{
        //选择学历
    }
}
#pragma mark--性别选择
-(void)seletSex{
    HQPickerView *picker = [[HQPickerView alloc]initWithFrame:self.view.bounds];
    picker.delegate = self ;
    picker.customArr = @[@"男",@"女"];
    [self.view addSubview:picker];
    
}
- (void)pickerView:(UIPickerView *)pickerView didSelectText:(NSString *)text {
    rightLabel[0].text = text;
}
#pragma mark--日期选择
-(void)seletbirth{
    self.dateView = [[MediaDatePickView alloc]init];
       self.dateView.pickDateDelegate = self;
       [self.dateView showSelectedView:self.view];
}
-(void)pickerViewdidSelectDateString:(NSString *)dateString{
   rightLabel[1].text = dateString;
    
}

#pragma mark--updatetouXiang
-(void)pickerClick
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:  UIAlertControllerStyleActionSheet];
    //分别按顺序放入每个按钮；
   [alert.view setTranslatesAutoresizingMaskIntoConstraints:NO];
      [alert addAction:[UIAlertAction actionWithTitle:@"我的相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //点击按钮的响应事件；
           NSUInteger sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
          if([UIImagePickerController  isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
                         //我的相册
                         sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                         
                         //获取相册访问权限
                         
                         [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                             dispatch_async(dispatch_get_main_queue(), ^{
                                 switch (status) {
                                     case PHAuthorizationStatusAuthorized: //已获取权限
                                     {
                                         // 跳转到相机或相册页面
                                         UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
                                         imagePickerController.delegate = self;
                                         imagePickerController.allowsEditing = YES;
                                         imagePickerController.sourceType = sourceType;
                                         //弹出相册页面或相机
                                         [self presentViewController:imagePickerController animated:YES completion:^{
                                             
                                         }];
                                         
                                         break;
                                     }
                                     case PHAuthorizationStatusDenied: {//用户已经明确否认了这一照片数据的应用程序访问
                                         [self gotoSetAuthor];//去设置权限
                                         
                                         break;
                                     }
                                     case PHAuthorizationStatusRestricted://此应用程序没有被授权访问的照片数据。
                                         [self gotoSetAuthor];
                                         break;
                                         
                                     default://其他。。。
                                         break;
                                 }
                             });
                         }];
                     }
       
      }]];
     
      [alert addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //点击按钮的响应事件；
           NSUInteger sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
          if([UIImagePickerController  isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
                         //相机
                         sourceType = UIImagePickerControllerSourceTypeCamera;
                         
                         [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                             
                             AVAuthorizationStatus status =[AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
                             if (status == AVAuthorizationStatusNotDetermined ||status == AVAuthorizationStatusAuthorized){
                                 //获取权限
                                 // 跳转到相机或相册页面
                                 UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
                                 imagePickerController.delegate = self;
                                 imagePickerController.allowsEditing = YES;
                                 imagePickerController.sourceType = sourceType;
                                 //弹出相册页面或相机
                                 [self presentViewController:imagePickerController animated:YES completion:^{
                                     
                                 }];
                                 
                             }else if(status == AVAuthorizationStatusDenied ||status ==AVAuthorizationStatusRestricted){//拒绝了权限
                                 [self gotoSetAuthor];
                                 
                             }
                         }];
                         
                  
                     }
       
      }]];
     
      [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        //点击按钮的响应事件；
        NSLog(@"点击了取消");
      }]];
     
      //弹出提示框；
       alert.modalPresentationStyle = UIModalPresentationFullScreen;
      [self presentViewController:alert animated:true completion:nil];
}

-(void)gotoSetAuthor{
    UIAlertController *controller=[UIAlertController alertControllerWithTitle:@"去设置页面->精英教育->照片、相机" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sure=[UIAlertAction actionWithTitle:@"去开启权限" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        dispatch_async(dispatch_get_main_queue(), ^{
            if( [[UIApplication sharedApplication] canOpenURL:url]){
                [[UIApplication sharedApplication] openURL:url];
            }
        });
    }];
    UIAlertAction *cancel=[UIAlertAction actionWithTitle:@"暂不" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [controller addAction:sure];
    [controller addAction:cancel];
    [self presentViewController:controller animated:YES completion:^{
        
    }];
}
//选中相册的代理方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    NSLog(@"选择照片");
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    //从相册获取到的头像
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    //缩小图片
    CGSize newSize=CGSizeMake(100, 100);
    UIGraphicsBeginImageContext(newSize);
    
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    UIImage*
    newImage = UIGraphicsGetImageFromCurrentImageContext();//从图形上下文获取新的图片
    UIGraphicsEndImageContext();

    //加密解秘都是对二进制进行处理
    NSData *data =UIImagePNGRepresentation(newImage);
    
    //指定编码方式.默认0
    NSString *base64String= [data base64EncodedStringWithOptions:0];
    

    
    base64String=[@"data:image/png;base64," stringByAppendingString:base64String];///php服务器上面要加上@"data:image/png;base64,"
    
    NSDictionary *paramas=@{@"file":base64String
                            };
    WEAKSELF();
    [[AXProgressHUDHelper getInstance]showTextWithStatus:@"正在上传..." onView:self.view];
    
    [AFHttpOperation postRequestWithURL:KAPIUpdateUserHeader parameters:paramas viewController:self success:^(id  _Nonnull responseObject) {
        if ([responseObject[@"status"] integerValue] == 1) {
                   [UserInfo shareInstance].headerImage = KISDictionaryHaveKey(responseObject, @"result");
                   [weakSelf.touIcon sd_setImageWithURL:[NSURL URLWithString:[UserInfo shareInstance].headerImage] placeholderImage:[UIImage imageNamed:@"advancetou"]];
                   [[AXProgressHUDHelper getInstance]showSuccessWithStatus:@"上传成功" onView:self.view];
                   dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                       
                   });
                  
               }else{
                   [[AXProgressHUDHelper getInstance]showTextWithStatus:responseObject[@"msg"] onView:self.view];
               }
        
    } failure:^(NSError * _Nonnull error) {
        [[AXProgressHUDHelper getInstance]showTextWithStatus:@"网络状况不佳" onView:self.view];
    }];
   

    
}

#pragma mark--LZ
-(NSArray *)leftArr{
    if (_leftArr == nil) {
        _leftArr = @[@"头像",@"姓名",@"手机号",@"性别",@"生日",@"学历"];
    }
    return _leftArr;
}
-(NSArray *)rightArr{
    if (_rightArr == nil) {
        _rightArr = @[@"",@"请输入姓名",@"请输入手机号",@"请选择性别",@"请选择生日",@"请选择学历"];
    }
    return _rightArr;
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
