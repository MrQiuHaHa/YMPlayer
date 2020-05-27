//
//  ZFPlayerToastView.m
//  Pods
//
//  Created by 邱俊荣 on 2020/4/28.
//

#import "ZFPlayerToastView.h"
#import "ZFUtilities.h"
#import "UIView+ZFFrame.h"

@interface ZFPlayerToastView ()

@property (nonatomic, strong) UILabel * textLabel;

@end

@implementation ZFPlayerToastView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [ZFUtilities colorWithHexCode:@"#25262D90"];
        self.layer.cornerRadius = 2;
    }
    return self;
}
- (UILabel *)textLabel{
    
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.textColor = [UIColor whiteColor];
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.font = [UIFont systemFontOfSize:14];
        _textLabel.numberOfLines = 0;
        _textLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_textLabel];
    }
    return _textLabel;
}

- (void)dealloc
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(dismiss) object:nil];
}

- (void)showAlertMsg:(NSString *)msg withSuperView:(UIView *)superView withLocationType:(LocationType)type
{
    self.textLabel.text = msg;
    
    CGFloat cx;
    CGFloat cy;
    CGFloat vw = superView.zf_width-120;
    CGFloat vh;
    CGFloat splitW = 20;
    CGFloat labW = vw-splitW*2;
    
    CGFloat tempH = [self.textLabel.text boundingRectWithSize:CGSizeMake(labW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.textLabel.font} context:nil].size.height;
    
    tempH = tempH < 300 ? tempH : 300;
    
    CGFloat tempW = [self.textLabel.text sizeWithAttributes:@{NSFontAttributeName:self.textLabel.font}].width;
    
    if (tempW < labW) {
        labW = tempW;
        vw = labW+40;
    }
    
    
    cx = splitW;
    cy = 10;
    
    self.textLabel.frame = CGRectMake(cx, cy, labW, tempH);
    
    cx = (superView.zf_width-vw)/2;
    vh = CGRectGetMaxY(self.textLabel.frame)+10;

    switch (type) {
        case LocationType_Top:
            cy = 60;
            break;
        case LocationType_Middle:
            cy = (superView.frame.size.height-vh)/2.0;
            break;
        case LocationType_Bottom:
            cy = superView.frame.size.height-vh-60;
            break;
    }
    
    self.frame = CGRectMake(cx, cy, vw, vh);
    
    
    [self removeFromSuperview];
    [superView addSubview:self];
    [superView bringSubviewToFront:self];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(dismiss) object:nil];
    [self performSelector:@selector(dismiss) withObject:nil afterDelay:2];
}

+ (void)showToastMsg:(NSString*)msg withSuperView:(UIView *)superView {
    
    [self showToastMsg:msg withSuperView:superView withLocationType:LocationType_Bottom];
}

+ (void)showToastMsg:(NSString *)msg withSuperView:(UIView *)superView withLocationType:(LocationType)type {
    if (msg.length == 0) {
        return;
    }
    __block BOOL hasExisting = NO;
    __block ZFPlayerToastView * alert = nil;
    
    [superView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
     {
         if ([obj isKindOfClass:[ZFPlayerToastView class]])
         {
             hasExisting = YES;
             alert = (ZFPlayerToastView *)obj;
             *stop = YES;
         }
     }];
    
    if (hasExisting && alert)
    {
        [alert removeFromSuperview];
    }
    
    ZFPlayerToastView *alertV = [[ZFPlayerToastView alloc] init];
    [alertV showAlertMsg:msg withSuperView:superView withLocationType:type];
}

- (void)dismiss
{
    [self removeFromSuperview];
}

@end
