//
//  NHSystemShare.m
//  NHXLSDemo
//
//  Created by neghao on 2018/6/16.
//  Copyright © 2018年 neghao. All rights reserved.
//

#import "NHSystemShare.h"

@implementation NHSystemShare{
    UIActivityViewController *_activeityVC;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithContentItems:(NSArray<UIActivity *> *)items
{
    self = [super init];
    if (self) {
        _activeityVC = [[UIActivityViewController alloc] initWithActivityItems:items applicationActivities:nil];
        
        
        _activeityVC.excludedActivityTypes = @[UIActivityTypePostToWeibo,UIActivityTypeCopyToPasteboard,UIActivityTypePostToTencentWeibo,UIActivityTypePostToFacebook,UIActivityTypePostToTwitter,UIActivityTypeAssignToContact];
    }
    return self;
}

- (void)setExcludedActivityTypes:(NSArray<UIActivityType> *)excludedActivityTypes {
    _activeityVC.excludedActivityTypes = excludedActivityTypes;
}


- (void)setCompletionWithItemsHandler:(UIActivityViewControllerCompletionWithItemsHandler)completionWithItemsHandler {
    _activeityVC.completionWithItemsHandler = completionWithItemsHandler;
}


- (void)presentShareControllerWithController:(UIViewController *)viewController
                                    animated:(BOOL)flag
                                  completion:(void (^ __nullable)(void))completion {
    
    [viewController presentViewController:_activeityVC animated:YES completion:completion];
}


@end
