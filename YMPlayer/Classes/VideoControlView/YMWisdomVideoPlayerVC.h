//
//  YMWisdomVideoPlayerVC.h
//  Pods
//
//  Created by 邱俊荣 on 2020/4/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YMWisdomVideoPlayerVC : UIViewController

/// URL列表
@property (nonatomic, strong, nonnull) NSArray<NSURL *> *assetURLs;

/// 标题列表
@property (nonatomic, strong, nonnull) NSArray<NSString *> *assetTitles;

/// 默认播放index = 0
@property (nonatomic, assign) NSInteger index;

@end

NS_ASSUME_NONNULL_END
