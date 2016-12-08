//
//  AppDelegate+CCPush.m
//  UMENG_PUSH
//
//  Created by 冯明庆 on 16/11/2.
//  Copyright © 2016年 冯明庆. All rights reserved.
//

#import "AppDelegate+CCPush.h"
#import "UMessage.h"

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
#import <AVFoundation/AVFoundation.h>
#else
#import <AudioToolbox/AudioToolbox.h>
#endif

NSString * const _CC_DID_RECEIVE_REMOTE_NOTIFICATION_ = @"CC_DID_RECEIVE_REMOTE_NOTIFICATION";
NSString * const _CC_PROCESS_REMOTE_NOTIFICATION_COMPLETE_ = @"CC_PROCESS_REMOTE_NOTIFICATION_COMPLETE";
NSString * const _CC_PROCESS_REMOTE_NOTIFICAATION_FAIL_ = @"CC_PROCESS_REMOTE_NOTIFICAATION_FAIL";

#warning TODO >>> 
/// 替换为你们自己的友盟推送 KEY . 

static NSString * _stringUmengPushKey = @"58185ab4aed17905e3002a27";

@implementation AppDelegate (CCPush) 

- (void) ccInitUmengPushWithLaunchOptions : (NSDictionary *) dictionaryLaunchoptions {
    ccWeakSelf;
    dispatch_queue_t queue = dispatch_queue_create("queue", DISPATCH_QUEUE_PRIORITY_DEFAULT);
    dispatch_async(queue, ^{
        [UMessage startWithAppkey:_stringUmengPushKey
                    launchOptions:dictionaryLaunchoptions];
        BOOL isDEBUG = NO;
#if DEBUG
        isDEBUG = YES;
#else
        isDEBUG = NO;
#endif
        [UMessage setLogEnabled:isDEBUG];
        [UMessage setChannel:(isDEBUG ? @"DEVELOPER INSTALL / TEST" : @"APP STORE")];
        [UMessage setAutoAlert:isDEBUG];
        [UMessage registerForRemoteNotifications];
        
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
        [pSelf ccSetNeedsForiOS10];
#elif __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
        [pSelf ccSetNeedsForAboveiOS8];
#endif
        [pSelf ccHandlePushNotificationWithLaunchOptions:dictionaryLaunchoptions];
    });
}

- (void) ccHandlePushNotificationWithLaunchOptions : (NSDictionary *) dictionaryLaunchoptions {
    ccWeakSelf;
    dispatch_time_t timeOperate = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4f * NSEC_PER_SEC));
    dispatch_after(timeOperate, dispatch_get_main_queue(), ^{
        if ([[dictionaryLaunchoptions allKeys] containsObject:UIApplicationLaunchOptionsRemoteNotificationKey]) {
            NSDictionary *dictionary = dictionaryLaunchoptions[UIApplicationLaunchOptionsRemoteNotificationKey];
            [pSelf ccSerilizePushInfoWithDictionary:dictionary
                                           withType:CCPushTypeLaunch
                               withApplicationState:[UIApplication sharedApplication].applicationState
                                       withIsLaunch:YES];
            NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
            [notificationCenter postNotificationName:_CC_DID_RECEIVE_REMOTE_NOTIFICATION_
                                              object:nil
                                            userInfo:@{@"key" : @(CCPushTypeLaunch),
                                                       @"value" : dictionary}];
        }
    });
}

- (void) ccHandlePushNotificationWithUserInfo : (NSDictionary *) dictionaryUserInfo {
    ccWeakSelf;
    dispatch_queue_t queue = dispatch_queue_create("queue", DISPATCH_QUEUE_PRIORITY_DEFAULT);
    dispatch_async(queue, ^{
        UIApplication *application = [UIApplication sharedApplication];
        if ([application applicationState] == UIApplicationStateActive) {
            [pSelf ccSerilizePushInfoWithDictionary:dictionaryUserInfo
                                           withType:CCPushTypeActive
                               withApplicationState:UIApplicationStateActive
                                       withIsLaunch:NO];
        } else {
            [UMessage didReceiveRemoteNotification:dictionaryUserInfo];
        }
        NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
        [notificationCenter postNotificationName:_CC_DID_RECEIVE_REMOTE_NOTIFICATION_
                                          object:nil
                                        userInfo:@{@"key" : @(CCPushTypeActive),
                                                   @"value" : dictionaryUserInfo}];
    });
}

- (void) ccSetNeedsForAboveiOS8 {
    UIMutableUserNotificationAction *actionConfirm = [[UIMutableUserNotificationAction alloc] init];
    actionConfirm.identifier = @"action1_id";
    actionConfirm.title = @"查看";
    actionConfirm.activationMode = UIUserNotificationActivationModeForeground;// 当点击的时候启动程序
    
    UIMutableUserNotificationAction *actionCancel = [[UIMutableUserNotificationAction alloc] init];
    actionCancel.identifier = @"action2_id";
    actionCancel.title = @"忽略";
    actionCancel.activationMode = UIUserNotificationActivationModeBackground;// 当点击的时候不启动程序，在后台处理
    actionCancel.authenticationRequired = YES; // 需要解锁才能处理
    actionCancel.destructive = YES;
    
    UIMutableUserNotificationCategory *actionCategory = [[UIMutableUserNotificationCategory alloc] init];
    actionCategory.identifier = @"category_iOS_8_&&_9"; //这组动作的唯一标示
    [actionCategory setActions:@[actionConfirm,actionCancel]
                    forContext:(UIUserNotificationActionContextDefault)];
    NSSet *categories = [NSSet setWithObjects:actionCategory, nil];
    [UMessage registerForRemoteNotifications:categories];
}

- (void) ccSetNeedsForiOS10 {
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;
    UNAuthorizationOptions authorizationOptions = UNAuthorizationOptionBadge | UNAuthorizationOptionAlert | UNAuthorizationOptionSound;
    [center requestAuthorizationWithOptions:authorizationOptions
                          completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            /// 点击允许
            
        } else {
            /// 点击不允许
            
        }
    }];
    
    NSInteger integerSystemVersion = [[[UIDevice currentDevice] systemVersion] integerValue];
    
    if (integerSystemVersion >= 10) {
        UNNotificationAction *action1 = [UNNotificationAction actionWithIdentifier:@"action1_ios10_id"
                                                                             title:@"查看"
                                                                           options:UNNotificationActionOptionForeground];
        UNNotificationAction *action2 = [UNNotificationAction actionWithIdentifier:@"action2_ios10_id"
                                                                             title:@"忽略"
                                                                           options:UNNotificationActionOptionForeground];
        
        //UNNotificationCategoryOptionNone
        //UNNotificationCategoryOptionCustomDismissAction  清除通知被触发会走通知的代理方法
        //UNNotificationCategoryOptionAllowInCarPlay       适用于行车模式
        UNNotificationCategory *category = [UNNotificationCategory categoryWithIdentifier:@"category_iOS_10"
                                                                                  actions:@[action1,action2]   intentIdentifiers:@[]
                                                                                  options:UNNotificationCategoryOptionCustomDismissAction];
        NSSet *categories= [NSSet setWithObjects:category, nil];
        [center setNotificationCategories:categories];
    }
}

- (void) ccSerilizePushInfoWithDictionary : (NSDictionary *) dictionaryPushInfo
                                 withType : (CCPushType) type
                     withApplicationState : (UIApplicationState) applicationState
                             withIsLaunch : (BOOL) isLaunch {
    __block NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    NSString *newsId = nil;
    switch (type) {
        case CCPushTypeLaunch:{
            newsId = ccStringFormat(@"%@",dictionaryPushInfo[@"newsId"]);
        }break;
        case CCPushTypeActive:{
            newsId = ccStringFormat(@"%@",dictionaryPushInfo[@"newsId"]);
        }break;
            
        default:{
            newsId = nil;
        }break;
    }
    
    if (!newsId || !newsId.length) {
        NSError *error = [NSError errorWithDomain:@"_CC_HANDLE_PUSH_INFO_ERROR_"
                                             code:1001
                                         userInfo:dictionaryPushInfo];
        [notificationCenter postNotificationName:_CC_PROCESS_REMOTE_NOTIFICAATION_FAIL_
                                          object:nil
                                        userInfo:@{@"key" : @(type),
                                                   @"value" : error}];
        return ;
    }
    
    if (applicationState == UIApplicationStateActive) {
        if (isLaunch) {
#warning TODO >>>
            /// 替换为 SodaNewsViewController ,
            /// 控制器 header 文件 暴露的接口是 SodaNews *newsModel .
            /// 用到的 , iid , coverUrl , commentNum . 想办法解决 .
            /// 需要重新赋值 .
            /// coverUrl 应该在 dataHandler 中的 SodaDetailNew -> coverurl
            /// commentNum 在 dataHandler 中的 SodaNewsModel -> commentNum
            
            UIViewController *viewC = nil;
            if (!viewC) {
                return ;
            }
            [self.window.rootViewController presentViewController:viewC
                                                         animated:YES
                                                       completion:^{
            [notificationCenter postNotificationName:_CC_PROCESS_REMOTE_NOTIFICATION_COMPLETE_
                                              object:nil
                                            userInfo:@{@"key" : @(type) ,
                                                       @"value" : dictionaryPushInfo}];
            }];
        } else {
            [self ccHandlePushInfoWhileAppIsActive:dictionaryPushInfo];
        }
    }
    
}

- (void) ccHandlePushInfoWhileAppIsActive : (NSDictionary *) dictionaryPushInfo {
#warning TODO >>> 
    /// 替换成你们自己的 Title , 给 nil 默认是应用名
    NSString *stringTitle = @"";
    
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    localNotification.alertTitle = stringTitle;
    localNotification.alertBody = ccStringFormat(@"%@",dictionaryPushInfo[@"aps"][@"alert"]);
    localNotification.userInfo = dictionaryPushInfo;
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    localNotification.fireDate = [NSDate date];
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate); // 震动
}

#pragma mark - UNUserNotificationCenterDelegate (ONLY_ABOVE_10)

-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    NSDictionary * userInfo = notification.request.content.userInfo;
    if ([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于前台时的远程推送
        [UMessage didReceiveRemoteNotification:userInfo];
        [self ccHandlePushInfoWhileAppIsActive:userInfo];
    } else {
        //应用处于前台时的本地推送
    }
}

//iOS10新增：处理后台点击通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if ([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于后台时的远程推送
        [UMessage didReceiveRemoteNotification:userInfo];
        [self ccHandlePushInfoWhileAppIsActive:userInfo];
    } else {
        //应用处于后台时的本地推送
    }
}

@end
