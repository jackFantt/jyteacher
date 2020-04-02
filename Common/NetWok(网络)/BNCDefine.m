//
//  BNCDefine.m
//  JYEducation
//
//  Created by wofuli on 2019/11/5.
//  Copyright © 2019 smart. All rights reserved.
//

#import "BNCDefine.h"

#pragma mark - API
//本地
NSString *const kAPIBaseURL = @"http://192.168.1.3/university/api/web/";
//测试环境
//NSString *const kAPIBaseURL = @"http://test.api.uni.zsb100.cn/";
//线上环境
//NSString *const kAPIBaseURL = @"http://farm.2qb.com:8081/";
#pragma 登录注册

//地址列表
NSString *const KAPI_allAddress = @"api/user/allAddress";
//登录
NSString *const KAPILogin = @"api/user/login";
//教师端登录
NSString *const KAPILogin_teacher = @"index.php/teacher/login";
//注册
NSString *const KAPIRegister = @"api/user/reg";
//获取验证码随机字符串
NSString *const KAPIGetRand = @"home/api/getRand";
//获取验证码
NSString *const KAPISend_validate_code = @"index.php/validate/send-sms-code";
//获取验图形证码
NSString *const KAPISend_validate_captcha = @"index.php/validate/captcha";

//快捷登录（验证码）
NSString *const KAPICodeLogin = @"index.php/user/login-fast";
//忘记密码
NSString *const KAPIForgetPassword = @"api/user/forgetPassword";
#pragma mark--首页
NSString *const KAPISmart_homePage = @"index.php/home/index";
#pragma mark--学习
NSString *const KAPIJYeduction_learnrecord = @"index.php/my/learn-record";
#pragma mark--已购
NSString *const KAPIJYeduction_hasbuy = @"index.php/my/has-buy";
// -- 商品详情
NSString *const KAPISmart_goodsInfo = @"Api/Goods/goodsInfo";
//分类数据
NSString *const KAPISmart_goodslist= @"/api/goods/goodslist";
//收藏商品操作
NSString *const KAPMA_collectGoods = @"/api/Goods/collectGoods";
//添加购物车
NSString *const KAPIMA_addCart = @"api/Cart/addCart";
//购物车数据
NSString *const KAPMA_cartList = @"api/Cart/cartList";
//删除购物车数据
NSString *const KAPMA_delCart = @"api/Cart/delCart";
//订单数据
NSString *const KAPMA_comfirmcartList = @"api/Cart/Cart2";
//用户地址列表
NSString *const KAPIMA_getAddressList = @"api/User/getAddressList";
//删除地址
NSString *const KAPIMA_del_address = @"api/User/del_address";
//添加或编辑收货地址addAddress
NSString *const KAPIMA_addAddress = @"api/User/addAddress";
//提交订单
NSString *const KAPIMA_commitCart = @"api/Cart/cart3";
#pragma mark--我的
NSString *const KAPIUpdateUserInfo = @"index.php/my/user-info";
NSString *const KAPIJYEducationmylearnrecord = @"index.php/my/learn-record";
//上传头像
NSString *const KAPIUpdateUserHeader = @"index.php/upload/upload";
//意见反馈
NSString *const KAPIJYfeedback = @"index.php/my/feed-back";
//订单列表
NSString *const KAPIMAgetOrderList = @"api/User/getOrderList";
//取消订单
NSString *const KAPIMAcancelOrder = @"api/User/cancelOrder";
//确认收货
NSString *const KAPIMAorderConfirm = @"api/User/orderConfirm";
//订单详情
NSString *const KAPIMAgetOrderDetail = @"api/User/getOrderDetail";
//查询退货状态
NSString *const KAPIMAreturn_goods_status = @"api/User/return_goods_status";
//申请退货
NSString *const KAPIMAreturn_goods = @"api/User/return_goods";
// 取消申请退货
NSString *const KAPIMAreturn_goods_cancel = @"api/User/return_goods_cancel";
// 查看某个售后详情
NSString *const KAPIMAreturn_goods_info = @"api/User/return_goods_info";
//查看物流
NSString *const KAPISmart_ogistics_get_detail= @"api/logistics/get_detail";
//填写的物流信息
NSString *const KAPIMAreturn_goods_delivery = @"api/User/return_goods_delivery";
//获取订单支付金额
NSString *const KAPIMAreturn_goodspaymoney = @"api/Cart/cart4";
//获取支付方式
NSString *const KAPIGet_payment = @"api/payment/get_payment";
//获取支付信息
NSString *const KAPIGet_Paymentget_code = @"api/payment/get_code";
// -- 收藏列表
NSString *const KAPISmart_getGoodsCollect = @"api/User/getGoodsCollect";
// -- 收藏取消
NSString *const KAPISmart_collectGoodscancel = @"api/Goods/collectGoods";


#pragma mark--教师端
NSString *const KAPIJY_GetLiveInfo = @"index.php/teacher-live/get-live-info";
NSString *const KAPIJY_teacherInfo = @"index.php/teacher/teacher-info";
NSString *const KAPIJY_teacherlivestart = @"index.php/teacher-live/start";
NSString *const KAPIJY_teacherlivefinsh = @"index.php/teacher-live/finish";

#pragma mark - Notifications


#pragma mark - HUD
NSString *const kHUDLoadingText = @"正在加载";
NSString *const kHUDLoadSucessText = @"加载成功";
NSString *const kHUDLoadFailedText = @"加载错误";
NSString *const kHUDUploadingText = @"正在上传";
NSString *const kHUDUploadSuccessText = @"上传成功";
NSString *const kHUDUploadFailedText = @"上传失败";
NSString *const kHUDNetWorkErrorText = @"网络状态不佳，请查看网络状况";


#pragma mark---通知
NSString *const JYLoginSuccess = @"JYLoginSuccess";


#pragma mark - User Defaults Keys
NSString *const kUDIUserLogin = @"kUDIUserLogin";
NSString *const kUDUserToken = @"UDUserToken";
NSString* const kUserName = @"GMX_userName";
NSString* const kUserMobile = @"GMX_Mobile";
NSString* const kUserEdu_background = @"GMX_edu_background";
NSString* const kUserEdu_UerSex = @"GMX_UerSex";
NSString* const kUserEdu_UerStatus = @"GMX_UerStatus";
NSString* const kUserPassword = @"GMX_PassWord";
NSString* const kUserAccount = @"GMX_Account";
NSString* const kUserUserID = @"GMX_UserID";
NSString* const kUserHead_pic = @"XMYP_HEADPIC";
NSString* const kUserRoomName = @"XMYP_teacherName";

NSString *const kUDIsUserAddress = @"kUDIsUserAddress";


#pragma mark - ThridPartyKey
NSString *const kTPKJPushKey = @"a85c0e72274afa279dde99a6";
NSString *const kTPKUMShareKey = @"5c1763d1f1f556da610002a9";
NSString *const kTPKWECHATeKey = @"wx7fe6edfb228df198";//@"wx16a52fad84b4cdd3";
//#define WeXinAppID @"wxd26a31a523160d92"
//#define WeiXinSecret @"b182a76a62c13712180d0dca175b770b"

