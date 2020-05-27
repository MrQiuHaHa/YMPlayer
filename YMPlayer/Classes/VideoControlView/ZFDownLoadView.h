//
//  ZFDownLoadView.h
//  Pods
//
//  Created by 邱俊荣 on 2020/4/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZFDownLoadView : UIView

@property (nonatomic, copy) void(^cancelDownLoadBlock)(void);

/// 下载进度
@property (nonatomic, assign) float downLoadProgress;

@end

NS_ASSUME_NONNULL_END
