//
//  NHSystemShare.h
//  NHXLSDemo
//
//  Created by neghao on 2018/6/16.
//  Copyright © 2018年 neghao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NHSystemShare : NSObject

/**
 点击某个分享后的事件回调
 */
@property(nullable, nonatomic, copy) UIActivityViewControllerCompletionWithItemsHandler completionWithItemsHandler NS_AVAILABLE_IOS(8_0); // set to nil after call

/**
 不需要支持的分享类型
 */
@property(nullable, nonatomic, copy) NSArray<UIActivityType> *excludedActivityTypes;
@property(nonatomic, readonly, nullable) NSString *activityTitle;
@property(nonatomic, readonly, nullable) UIImage *activityImage;

- (instancetype _Nullable)init NS_DEPRECATED_IOS(6_0, 6_0, "Use initWithContentItems: instead.");


/**
 初始化方法
 
 @param items 内容对象：标题，文件地址
 */
- (instancetype _Nullable)initWithContentItems:(NSArray <UIActivity *>* _Nonnull)items;


/**
 跳转到分享控制器
 
 @param viewController present vc
 @param flag 动画效果
 @param completion 完成回调
 */
- (void)presentShareControllerWithController:(UIViewController * _Nonnull)viewController
                                    animated:(BOOL)flag
                                  completion:(void (^__nullable)(void))completion;


@end
