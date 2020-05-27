//
//  ZFPlayerToastView.h
//  Pods
//
//  Created by 邱俊荣 on 2020/4/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    LocationType_Top,
    LocationType_Middle,
    LocationType_Bottom,
} LocationType;

@interface ZFPlayerToastView : UIView

+ (void)showToastMsg:(NSString*)msg withSuperView:(UIView *)superView;

+ (void)showToastMsg:(NSString *)msg withSuperView:(UIView *)superView withLocationType:(LocationType)type;
@end

NS_ASSUME_NONNULL_END
