//
//  YMPhotosBrowseVC.h
//  Pods
//
//  Created by 邱俊荣 on 2020/4/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YMPhotosBrowseVC : UIViewController

@property (nonatomic, strong) NSArray <NSString *>* imagesArr;

@property (nonatomic, strong) NSArray<NSString *> *imageTitlesArr;

@property (nonatomic, assign) NSInteger currentIndex;

@end

NS_ASSUME_NONNULL_END
