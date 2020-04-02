//
//  JYInviteFriendsVC.m
//  JYEducation
//
//  Created by 精英教育 on 2020/3/19.
//  Copyright © 2020 smart. All rights reserved.
//

#import "JYInviteFriendsVC.h"
#import <CoreImage/CoreImage.h>
#import <UShareUI/UShareUI.h>
//#import "WXApi.h"//判断安装微信


@interface JYInviteFriendsVC ()

@property (nonatomic,strong) UIButton * shareBtn;

@end

@implementation JYInviteFriendsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTopViewWithTitle:@"邀请好友" withBackButton:YES viewColor:WhiteBackColor];
    [self setupUI];
}
-(void)setupUI{
    UIImageView * qrcodeImage = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth/2-150, ScreenHeight/2-150, 300, 300)];
    qrcodeImage.image = [self createQRCodeWithUrl:@"爱到尽头，覆水难收。爱悠悠，恨悠悠"];
    [self.view addSubview:qrcodeImage];
    [self createRightBtn];
}
-(void)createRightBtn{
    WEAKSELF();
    UIButton * baojiaBtn = [UIButton wh_buttonWithTitle:@"分享" backColor:nil backImageName:@"" titleColor:HexadecimalColor(@"#32C141") fontSize:16 frame:CGRectMake(ScreenWidth-15-80, NavitionbarHeight-44, 80, 44) cornerRadius:0];
       baojiaBtn.titleLabel.font = [UIFont mediumWithSize:15];
//    if ([WXApi isWXAppInstalled]) {
//        [m_baseTopView addSubview:baojiaBtn];
//    }
    
    [m_baseTopView addSubview:baojiaBtn];
   
       
       [baojiaBtn wh_addActionHandler:^{
           [weakSelf sharePlatForm];
    }];
    self.shareBtn = baojiaBtn;
}
-(void)sharePlatForm{
    
    WEAKSELF();
    //显示分享面板
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        // 根据获取的platformType确定所选平台进行下一步操作
        if(platformType ==UMSocialPlatformType_WechatSession){
            [weakSelf shareWebPageToPlatformType:UMSocialPlatformType_WechatSession];
                   
            }
        
        if(platformType ==UMSocialPlatformType_WechatTimeLine){
                  [weakSelf shareWebPageToPlatformType:UMSocialPlatformType_WechatTimeLine];
                         
            }
        NSLog(@"weixin");
    }];
}

- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];

    //创建网页内容对象
    NSString* thumbURL =  @"https://mobile.umeng.com/images/pic/home/social/img-1.png";
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"欢迎使用【友盟+】社会化组件U-Share" descr:@"欢迎使用【友盟+】社会化组件U-Share，SDK包最小，集成成本最低，助力您的产品开发、运营与推广！" thumImage:thumbURL];
    //设置网页地址
    shareObject.webpageUrl = @"http://mobile.umeng.com/social";

    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;

    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);

            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
    }];
}
#pragma mark--生成二维码
- (UIImage *)createQRCodeWithUrl:(NSString *)url {
    // 1. 创建一个二维码滤镜实例(CIFilter)
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 滤镜恢复默认设置
    [filter setDefaults];

    // 2. 给滤镜添加数据
    NSString *string = url;
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    // 使用KVC的方式给filter赋值
    [filter setValue:data forKeyPath:@"inputMessage"];

    // 3. 生成二维码
    CIImage *image = [filter outputImage];
    // 转成高清格式
    UIImage *qrcode = [self createNonInterpolatedUIImageFormCIImage:image withSize:200];
    // 添加logo
    qrcode = [self drawImage:[UIImage imageNamed:@"alipay"] inImage:qrcode];
    return qrcode;
}
#pragma mark--将二维码转成高清的格式
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size {

    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));

    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);

    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

#pragma mark--添加logo
- (UIImage *)drawImage:(UIImage *)newImage inImage:(UIImage *)sourceImage {
    CGSize imageSize; //画的背景 大小
    imageSize = [sourceImage size];
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);
    [sourceImage drawAtPoint:CGPointMake(0, 0)];
    //获得 图形上下文
    CGContextRef context=UIGraphicsGetCurrentContext();
    //画 自己想要画的内容(添加的图片)
    CGContextDrawPath(context, kCGPathStroke);
    // 注意logo的尺寸不要太大,否则可能无法识别
    CGRect rect = CGRectMake(imageSize.width / 2 - 20, imageSize.height / 2 - 20, 40, 40);
//    CGContextAddEllipseInRect(context, rect);
    CGContextClip(context);

    [newImage drawInRect:rect];

    //返回绘制的新图形
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
-(void)share{
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
