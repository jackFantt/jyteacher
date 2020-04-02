//
//  SocketRocketUtility.h
//  zhang
//
//  Created by 精英教育 on 2020/3/10.
//  Copyright © 2020 精英教育. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SocketRocket.h>

extern NSString * const kNeedPayOrderNote;
extern NSString * const kWebSocketDidOpenNote;
extern NSString * const kWebSocketDidCloseNote;
extern NSString * const kWebSocketdidReceiveMessageNote;

@interface SocketRocketUtility : NSObject

/** 获取连接状态 */
@property (nonatomic,assign,readonly) SRReadyState socketReadyState;

/** 开始连接 */
- (void)SRWebSocketOpenWithURLString:(NSString *)urlString;

/** 关闭连接 */
- (void)SRWebSocketClose;

/** 发送数据 */
- (void)sendData:(id)data;

+ (SocketRocketUtility *)instance;

@end
