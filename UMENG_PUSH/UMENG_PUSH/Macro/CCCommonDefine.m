//
//  CCCommonDefine.m
//  RAC_DEMO
//
//  Created by 冯明庆 on 16/11/1.
//  Copyright © 2016年 冯明庆. All rights reserved.
//

#import "CCCommonDefine.h"

@implementation CCCommonDefine

CGRect _ccScreenBounds(){
    return [[UIScreen mainScreen] bounds];
}
CGFloat _ccScreenHeight(){
    return [UIScreen mainScreen].bounds.size.height;
}
CGFloat _ccScreenWidth(){
    return [UIScreen mainScreen].bounds.size.width;
}
NSString  *_ccForUTF8String(const char * string){
    return [NSString stringWithUTF8String:string];
}
NSURL *_ccForURL(NSString * string , BOOL isFile){
    return isFile ? [NSURL fileURLWithPath:string] : [NSURL URLWithString:string];
}
UIColor *_ccColor(CGFloat r, CGFloat g , CGFloat b , CGFloat a){
    return [UIColor colorWithRed:r / 255.0f green:g / 255.0f blue:b / 255.0f alpha:a];
}
UIColor * _ccHexColor(int intValue ,float floatAlpha){
    return [UIColor colorWithRed:((CGFloat)((intValue & 0xFF0000) >> 16))/255.0 green:((CGFloat)((intValue & 0xFF00) >> 8))/255.0 blue:((CGFloat)(intValue & 0xFF))/255.0 alpha:(CGFloat)floatAlpha];
}
NSString * _ccMergeString(NSString * string , ...) {
    return string;
}

NSString * _ccGetRandomString(NSInteger integerStringLength){
    NSString *string = [[NSString alloc]init];
    for (int i = 0; i < integerStringLength; i++) {
        int number = arc4random() % 36;
        if (number < 10) {
            int figure = arc4random() % 10;
            NSString *tempString = [NSString stringWithFormat:@"%d", figure];
            string = [string stringByAppendingString:tempString];
        } else {
            int figure = (arc4random() % 26) + 97;
            char character = figure;
            NSString *tempString = [NSString stringWithFormat:@"%c", character];
            string = [string stringByAppendingString:tempString];
        }
    }
    return string;
}
UIImage * _ccImage(NSString * imageName , BOOL isFile){
    return isFile ? [UIImage imageWithContentsOfFile:imageName] : [UIImage imageNamed:imageName];
}

@end
