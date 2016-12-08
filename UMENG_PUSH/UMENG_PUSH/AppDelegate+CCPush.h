//
//  AppDelegate+CCPush.h
//  UMENG_PUSH
//
//  Created by 冯明庆 on 16/11/2.
//  Copyright © 2016年 冯明庆. All rights reserved.
//

#import "AppDelegate.h"

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 100000
#import <UserNotifications/UserNotifications.h>
#endif

typedef NS_ENUM(NSInteger , CCPushType) {
    CCPushTypeLaunch = 0 ,
    CCPushTypeActive
};

@interface AppDelegate (CCPush) < UNUserNotificationCenterDelegate >

extern NSString * const _CC_DID_RECEIVE_REMOTE_NOTIFICATION_ ;
extern NSString * const _CC_PROCESS_REMOTE_NOTIFICATION_COMPLETE_ ;
extern NSString * const _CC_PROCESS_REMOTE_NOTIFICAATION_FAIL_ ;

- (void) ccInitUmengPushWithLaunchOptions : (NSDictionary *) dictionaryLaunchoptions ;

- (void) ccHandlePushNotificationWithUserInfo : (NSDictionary *) dictionaryUserInfo ;

#pragma mark - NOT FOR PRIMARY

- (void) ccHandlePushNotificationWithLaunchOptions : (NSDictionary *) dictionaryLaunchoptions ;
- (void) ccSetNeedsForAboveiOS8 ;
- (void) ccSetNeedsForiOS10 ;

- (void) ccSerilizePushInfoWithDictionary : (NSDictionary *) dictionaryPushInfo
                                 withType : (CCPushType) type
                     withApplicationState : (UIApplicationState) applicationState
                             withIsLaunch : (BOOL) isLaunch;

- (void) ccHandlePushInfoWhileAppIsActive : (NSDictionary *) dictionaryPushInfo ;

@end
