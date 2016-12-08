//
//  CCCommonDefine.h
//  RAC_DEMO
//
//  Created by 冯明庆 on 16/11/1.
//  Copyright © 2016年 冯明庆. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/// 调试输出
#if DEBUG
#define CCLog(fmt,...) NSLog((@"\n %s \n %s %d \n" fmt),__FILE__,__func__,__LINE__,##__VA_ARGS__)
#else
#define CCLog(...) /* */
#endif

/// self 弱引用
#define ccWeakSelf __weak typeof(&*self) pSelf = self

/// 字符串格式化
#define ccStringFormat(...) [NSString stringWithFormat:__VA_ARGS__]

NS_ASSUME_NONNULL_BEGIN

@interface CCCommonDefine : NSObject

/// 屏幕 Frame
CGRect _ccScreenBounds();
/// 屏幕高
CGFloat _ccScreenHeight();
/// 屏幕宽
CGFloat _ccScreenWidth();
/// 转化为字符串对象
NSString  *_ccForUTF8String(const char * string);
/// 转化为 NSURL 对象
NSURL *_ccForURL(NSString * string , BOOL isFile);
/// 返回颜色
UIColor *_ccColor(CGFloat r, CGFloat g , CGFloat b , CGFloat a);

/// 给颜色举例 若颜色为 : #ffffff 则输入 0xffffff
UIColor * _ccHexColor(int intValue ,float floatAlpha);

NSString * _ccMergeString(NSString * string , ...);

NSString * _ccGetRandomString(NSInteger integerStringLength);

UIImage * _ccImage(NSString * imageName , BOOL isFile);

@end

NS_ASSUME_NONNULL_END
