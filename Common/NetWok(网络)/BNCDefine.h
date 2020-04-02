//
//  BNCDefine.h
//  JYEducation
//
//  Created by wofuli on 2019/11/5.
//  Copyright © 2019 smart. All rights reserved.


#import <Foundation/Foundation.h>

#ifndef BNCDEFINE
#define BNCDEFINE

#pragma mark ENUM OR OPTION Define

#pragma mark - API
extern NSString *const kAPIBaseURL;                 //BaseUrl

extern NSString *const KAPI_allAddress  ;            //地址列表
extern NSString *const KAPILogin  ;                 //登录
extern NSString *const KAPILogin_teacher  ;         //教师登录
extern NSString *const KAPIRegister  ;              //注册
extern NSString *const KAPIGetRand;                 //获取验证码随机字符串
extern NSString *const KAPISend_validate_code;      //获取验证码
extern NSString *const KAPISend_validate_captcha;      //获取图形验证码
extern NSString *const KAPICodeLogin;              //获取验证码后快捷登录
extern NSString *const KAPIForgetPassword  ;        //忘记密码
#pragma mark--首页
extern NSString *const KAPISmart_homePage ;        //学习记录

#pragma mark--学习
extern NSString *const KAPIJYeduction_learnrecord ;        //首页数据
#pragma mark--已购
extern NSString *const KAPIJYeduction_hasbuy ;       //我的已购
#pragma mark--我的
extern NSString *const KAPIUpdateUserInfo ;                 //个人信息
extern NSString *const KAPIUpdateUserHeader ;               //上传头像
extern NSString *const KAPIJYEducationmylearnrecord ;       //我的学习记录
extern NSString *const KAPIJYfeedback ;                //意见反馈


#pragma mark--教师端
extern NSString *const KAPIJY_GetLiveInfo ;                //获取直播分类信息
extern NSString *const KAPIJY_teacherInfo ;                //教师信息
extern NSString *const KAPIJY_teacherlivestart ;             //获取推流地址
extern NSString *const KAPIJY_teacherlivefinsh ;             //结束直播




extern NSString *const KAPISmart_goodsInfo ;       //商品详情
extern NSString *const KAPISmart_goodslist ;       //分类商品
extern NSString *const KAPMA_collectGoods ;        //收藏商品
extern NSString *const KAPIMA_addCart ;           //添加物品到购物车
extern NSString *const KAPMA_cartList ;           //购物车列表
extern NSString *const KAPMA_delCart ;            //删除购物车商品
extern NSString *const KAPMA_comfirmcartList ;     //订单列表
extern NSString *const KAPIMA_getAddressList ;     //用户地址列表
extern NSString *const KAPIMA_del_address ;        //删除用户地址
extern NSString *const KAPIMA_addAddress ;        //添加或编辑收货地址addAddress
extern NSString *const KAPIMA_commitCart ;        //提交订单
extern NSString *const KAPIMAgetOrderList ;        //订单列表
extern NSString *const KAPIMAcancelOrder ;        //取消订单
extern NSString *const KAPIMAorderConfirm ;        //确认收货
extern NSString *const KAPIMAgetOrderDetail ;        //确认收货
extern NSString *const KAPIMAreturn_goods_status ;    //查询退货状态
extern NSString *const KAPIMAreturn_goods ;          //申请退货
extern NSString *const KAPIMAreturn_goods_cancel ;    // 取消申请退货
extern NSString *const KAPIMAreturn_goods_info ;    //查看某个售后详情
extern NSString *const KAPISmart_ogistics_get_detail ;    //查看物流
extern NSString *const KAPIMAreturn_goods_delivery ;    //填写的物流信息
extern NSString *const KAPIMAreturn_goodspaymoney ;    //获取订单支付金额
extern NSString *const KAPIGet_payment;               //获取支付方式
extern NSString *const KAPIGet_Paymentget_code;        //获取支付信息
extern NSString *const KAPISmart_getGoodsCollect ; //收藏列表
extern NSString *const KAPISmart_collectGoodscancel ; //取消收藏



#pragma mark - User Defaults Keys
extern NSString *const kUDIUserLogin ;
extern NSString *const kUDUserToken;                 //用户令牌
extern NSString *const kUserName;                    //用户名
extern NSString *const kUserPassword;                //用户密码
extern NSString *const kUserAccount;
extern  NSString *const kUserUserID ;
extern NSString *const kUserHead_pic;
extern NSString *const kUserNickname;
extern  NSString *const kUserMobile ;
extern  NSString *const kUserEdu_background ;
extern  NSString *const kUserEdu_UerSex ;
extern  NSString *const kUserEdu_UerStatus ;
extern NSString *const kUserRoomName;

extern NSString *const kUDIsUserAddress ;

#pragma mark - HUD
extern NSString *const kHUDLoadingText;
extern NSString *const kHUDLoadSucessText;
extern NSString *const kHUDLoadFailedText;
extern NSString *const kHUDUploadingText;
extern NSString *const kHUDUploadSuccessText;
extern NSString *const kHUDUploadFailedText;
extern NSString *const kHUDNetWorkErrorText;
extern NSString *const kHasSelectedFeature;


#pragma mark--通知
extern NSString *const JYLoginSuccess;

#pragma MARK--KEY

extern NSString *const kTPKWECHATeKey;

#endif
