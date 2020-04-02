//
//  MaMineVC.m
//  JYEducation
//
//  Created by wofuli on 2019/11/5.
//  Copyright © 2019 smart. All rights reserved.
//

#import "MaMineVC.h"
#import "MaLoginVC.h"
#import "YL_PhoneCodeVC.h"
#import "JYMyselfCell.h"
#import "JYMyselfMessageVC.h"
#import "JYLearnCenterVC.h"
#import "JYMessageCenterVC.h"
#import "JYFeedbackVC.h"
#import "JYInviteFriendsVC.h"

#import <Photos/Photos.h>
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>

static NSString * const reuseInderfer = @"JYMyselfCell";

@interface MaMineVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UITableViewDelegate,UITableViewDataSource>
{
}

@property (nonatomic,strong) UIImageView * touIcon;
@property (nonatomic,strong) UIButton * userBtn;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong)UIView * headerView;

@property (nonatomic,strong) UILabel * phoneLabel;
@property (nonatomic,strong) UILabel * userName;
@property (nonatomic,copy) NSArray * dataArray;


@end

@implementation MaMineVC

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTopViewWithTitle:@"我的" withBackButton:NO viewColor:WhiteBackColor];
    self.view.backgroundColor = RGBA(245, 245, 245, 1.0);
    self.dataArray = @[@[@"开始直播",@"课程回看"],
                       @[@"设置"]];
    [self.view addSubview:self.tableView];
    self.basaicTableView = self.tableView;
    [[UINavigationBar appearance]setTranslucent:NO];
    
}

#pragma mark--tableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataArray[section] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        JYMyselfCell * cell = (JYMyselfCell * )[tableView dequeueReusableCellWithIdentifier:reuseInderfer];
           if (!cell) {
               cell = [[JYMyselfCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseInderfer];
           }
    cell.leftLabel.text = self.dataArray[indexPath.section][indexPath.row];
    cell.leftImage.image = [UIImage imageNamed:self.dataArray[indexPath.section][indexPath.row]];
        return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {//开始直播
            
        }else if (indexPath.row == 1){//课程会看
            JYLearnCenterVC * centerVC = [[JYLearnCenterVC alloc]init];
            centerVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:centerVC animated:YES];
        }
    }else{
       //设置
    }
}
-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return MARGIN_OY;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
        return CGFLOAT_MIN;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
  
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, MARGIN_OY)];
    headerView.backgroundColor = RGBA(245, 245, 245, 1.0);
    return headerView;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
#pragma--mark-登录
-(void)loginClickk{
    WEAKSELF();
    YL_PhoneCodeVC * CodeVC = [[YL_PhoneCodeVC alloc]init];
    CodeVC.hidesBottomBarWhenPushed = YES;
    CodeVC.refrshuiBlock = ^{
        [weakSelf checkUserloginStatu];
    };
    [self.navigationController pushViewController:CodeVC animated:YES];
}

#pragma mark--LZ
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NavitionbarHeight, ScreenWidth, ScreenHeight-TabbarHeight-NavitionbarHeight) style:UITableViewStylePlain];
        _tableView.backgroundColor = RGBA(245, 245, 245, 1.0);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableHeaderView = self.headerView;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerClass:[JYMyselfCell class] forCellReuseIdentifier:reuseInderfer];
        
        [_tableView.header beginRefreshing];

        
    }
    return _tableView;
}
-(UIView *)headerView{
    WEAKSELF();
    if (!_headerView) {
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, NavitionbarHeight, ScreenWidth, 120)];
        _headerView.backgroundColor = RGBA(69, 70, 75, 1.0);
        
          self.touIcon = [[UIImageView alloc]initWithFrame:CGRectMake(MARGIN_OX, [_headerView height]/2-30, 60, 60)];
          self.touIcon.image = [UIImage imageNamed:@"默认头像"];
          self.touIcon.userInteractionEnabled = YES;
          self.touIcon.layer.masksToBounds = YES;
          self.touIcon.layer.cornerRadius = 30.f;
//          self.touIcon.layer.borderColor = [[UIColor whiteColor] CGColor];
//          self.touIcon.layer.borderWidth = 2.5f;
          [_headerView addSubview:self.touIcon];
          
          UITapGestureRecognizer * tougester = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pickerClick)];
          [self.touIcon addGestureRecognizer:tougester];
        
        UIButton * loginBtn = [UIButton wh_buttonWithTitle:@"" backColor:[UIColor clearColor] backImageName:@"" titleColor:RGBA(218, 171, 119, 1.0) fontSize:18 frame:CGRectMake(self.touIcon.right+12, [_headerView height]/2-15, 60, 30) cornerRadius:15];
        loginBtn.layer.borderWidth = 1.0f;
        loginBtn.layer.borderColor = [RGBA(218, 171, 119, 1.0) CGColor];
           loginBtn.titleLabel.font = [UIFont mediumWithSize:14];
          [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
         loginBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
           [loginBtn addTarget:self action:@selector(loginClickk) forControlEvents:UIControlEventTouchUpInside];
           [_headerView addSubview:loginBtn];
           self.userBtn = loginBtn;
        
        self.userName = [UILabel wh_labelWithText:@"尼古拉斯赵四" textFont:18 textColor:RGBA(218, 171, 119, 1.0) frame:CGRectMake(self.touIcon.right+13, self.touIcon.mj_y+8, 150, 20)];
        self.userName.textAlignment = NSTextAlignmentLeft;
        self.userName.font = [UIFont BoldWithSize:18];
        [_headerView addSubview:self.userName];
        
        self.phoneLabel = [UILabel wh_labelWithText:@"18297955227" textFont:14 textColor:RGBA(218, 171, 119, 1.0) frame:CGRectMake(self.touIcon.right+13, self.userName.bottom+5, 150, 20)];
        self.phoneLabel.textAlignment = NSTextAlignmentLeft;
        self.phoneLabel.font = [UIFont mediumWithSize:14];
        [_headerView addSubview:self.phoneLabel];
        
        [self checkUserloginStatu];
        UIImageView * roowImage = [[UIImageView alloc]initWithFrame:CGRectMake([_headerView width]-12-7, [_headerView height]/2-5.5, 7, 11)];
           roowImage.image = [UIImage imageNamed:@"金色箭头"];
           [_headerView addSubview:roowImage];
        
        UIView * tapView = [[UIView alloc]initWithFrame:CGRectMake([_headerView width]/4*3, 0, [_headerView width]/4, [_headerView height])];
        tapView.backgroundColor = [UIColor clearColor];
        [_headerView addSubview:tapView];
        
        [tapView wh_addTapActionWithBlock:^(UITapGestureRecognizer *gestureRecoginzer) {
            [weakSelf setJYMyselfMessage];
        }];
        
    }
    return _headerView;
}

-(void)setJYMyselfMessage{
    JYMyselfMessageVC * messageVC = [[JYMyselfMessageVC alloc]init];;
    messageVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:messageVC animated:YES];
}
-(void)loadselfDataMessage{
    WEAKSELF();
    NSDictionary * param = @{};
    [AFHttpOperation postRequestWithURL:KAPIJY_teacherInfo parameters:param viewController:self success:^(id  _Nonnull responseObject) {
        if ([responseObject[@"code"] integerValue] == RESPONSE_CODE_SUCCESS) {
            NSDictionary* dataDic = kParseData(responseObject);
            if (![dataDic isKindOfClass:[NSDictionary class]]) {
                return;
            }
            NSDictionary * userinfoDic = [dataDic objectForKey:@"info"];
            [UserInfo shareInstance].headerImage = KISDictionaryHaveKey(userinfoDic, @"avatar");
            [UserInfo shareInstance].edu_background = KISDictionaryHaveKey(userinfoDic, @"edu_background");
            [UserInfo shareInstance].mobile = KISDictionaryHaveKey(userinfoDic, @"mobile");
            [UserInfo shareInstance].userName = KISDictionaryHaveKey(userinfoDic, @"name");
            [UserInfo shareInstance].romeName = KISDictionaryHaveKey(userinfoDic, @"show_id");
            
            [UserInfo saveUserName];
            
            [weakSelf refrshEducationSelfMessage];
            
            [weakSelf.tableView.header endRefreshing];
            
            //发送通知刷新主页信息
             [[NSNotificationCenter defaultCenter] postNotificationName:JYLoginSuccess object:nil];
            
        }
        
    } failure:^(NSError * _Nonnull error) {
        [weakSelf.tableView.header endRefreshing];

    }];
}
#pragma mark--更新个人数据
-(void)refrshEducationSelfMessage{
    NSString * imageurl = @"http://192.168.1.3/university/api/web/uploads/teacher/1.png";//[UserInfo shareInstance].headerImage;
    
    [self.touIcon sd_setImageWithURL:[NSURL URLWithString:imageurl] placeholderImage:[UIImage imageNamed:@"advancetou"]];
    
    
    NSString * userName = @"";
    if (StringIsEmpty([UserInfo shareInstance].userName)) {
        userName = @"未设置";
    }else{
        userName = [UserInfo shareInstance].userName;
    }
    self.userName.text = userName;
    self.phoneLabel.text = [UserInfo shareInstance].mobile;
    
}
-(void)checkUserloginStatu{
    WEAKSELF();
    if ([CommonTool isUserLogin]) {
        self.userBtn.hidden = YES;
        self.userBtn.userInteractionEnabled = NO;
        self.phoneLabel.hidden = NO;
        self.userName.hidden = NO;
        
            self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                [weakSelf loadselfDataMessage];
            }];
            [self.tableView.header beginRefreshing];
    
            }else{
                self.userBtn.hidden = NO;
                 self.userBtn.userInteractionEnabled = YES;
                self.phoneLabel.hidden = YES;
                self.userName.hidden = YES;
            }
}


//选择头像
#pragma mark--updatetouXiang
-(void)pickerClick
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:  UIAlertControllerStyleActionSheet];
    //分别按顺序放入每个按钮；
   [alert.view setTranslatesAutoresizingMaskIntoConstraints:NO];
      [alert addAction:[UIAlertAction actionWithTitle:@"我的相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
          [[NSNotificationCenter defaultCenter] postNotificationName:@"showPhoto" object:nil];
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
                            
                                        imagePickerController.modalPresentationStyle = UIModalPresentationFullScreen;
                                         //弹出相册页面或相机
                                         if (@available(iOS 11.0, *)) {
                                                                               [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentAutomatic];
                                                                             imagePickerController.modalPresentationStyle = UIModalPresentationFullScreen;
                                                                         }
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
                                 
                                 // 跳转到相机或相册页面
                                 UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
                                 imagePickerController.delegate = self;
                                 imagePickerController.allowsEditing = YES;
                                 imagePickerController.sourceType = sourceType;
                                 //弹出相册页面或相机
                                 
                                 if (@available(iOS 11.0, *)) {
                                       [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentAutomatic];
                                     imagePickerController.modalPresentationStyle = UIModalPresentationFullScreen;
                                 }
                                 
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
    controller.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:controller animated:YES completion:^{
        
    }];
}


//选中相册的代理方法
#pragma mark--解决UIImagePickerController导航透明问题
- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated
{
    if ([navigationController isKindOfClass:[UIImagePickerController class]])
    {
        if (@available(iOS 13, *)) {
//           [[UINavigationBar appearance]setTranslucent:NO];
            
        }else{
           
        navigationController.navigationBar.translucent = NO;
        viewController.navigationController.navigationBar.translucent = NO;
        viewController.edgesForExtendedLayout = UIRectEdgeNone;
        //设置成想要的背景颜色
//       [navigationController.navigationBar setBarTintColor:RedBackColor];
        }
    }
}
#pragma mark--解决点击UIImagePickerController取消按钮点击后屏幕适配
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    if (@available(iOS 11, *)) {

            UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{

    if (@available(iOS 11, *)) {

            UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;

    }
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

    WEAKSELF();
    //加密解秘都是对二进制进行处理
    NSData *imageData =UIImagePNGRepresentation(newImage);
    NSDictionary * param = @{@"path":@"avatar"};
    
    [[AXProgressHUDHelper getInstance]showWithStatus:@"正在上传" onView:weakSelf.view];
    [AFHttpOperation postRequestWithURL:KAPIUpdateUserHeader parameters:param uploadFiles:^(id<AFMultipartFormData>  _Nonnull formData) {
        
//        NSString* sname = [NSString stringWithFormat:@"img_file[%d]" , 0];
        NSString* sname = @"imageFile";
                                                              
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@_%d.png", str , 0];
      
        // 上传图片，以文件流的格式
        [formData appendPartWithFileData:imageData name:sname fileName:fileName mimeType:@"image/png"];
        
    } success:^(id  _Nonnull responseObject) {
        if ([responseObject[@"code"] integerValue] == RESPONSE_CODE_SUCCESS) {
            NSLog(@"上传成功");
            NSDictionary * dataDic = kParseData(responseObject);
            if (dataDic == nil) {
                [[AXProgressHUDHelper getInstance]dismissOnView:weakSelf.view];
                return ;
            }
            [UserInfo shareInstance].headerImage = KISDictionaryHaveKey(dataDic, @"url");
//            [weakSelf.touIcon sd_setImageWithURL:[NSURL URLWithString:[UserInfo shareInstance].headerImage] placeholderImage:[UIImage imageNamed:@"advancetou"]];
            weakSelf.touIcon.image = image;
            [[AXProgressHUDHelper getInstance]showSuccessWithStatus:@"上传成功" onView:weakSelf.view];
        }else{
            [[AXProgressHUDHelper getInstance]showTextWithStatus:responseObject[@"msg"] onView:weakSelf.view];
        }
        [[AXProgressHUDHelper getInstance]dismissOnView:weakSelf.view];
        
        
    } failure:^(NSError * _Nonnull error) {
        
         [[AXProgressHUDHelper getInstance]showTextWithStatus:kHUDNetWorkErrorText onView:weakSelf.view];
        [[AXProgressHUDHelper getInstance]dismissOnView:weakSelf.view];
        
    }];
    

   

    
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
