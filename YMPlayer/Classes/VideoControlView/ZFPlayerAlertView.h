//
//  ZFPlayerAlertView.h
//  Pods
//
//  Created by 邱俊荣 on 2020/4/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZFPlayerAlertView : UIView

@property (nonatomic, copy) void(^cancelCancelBlock)(void);

@property (nonatomic, copy) void(^sureBtnBlock)(void);

@end

NS_ASSUME_NONNULL_END
