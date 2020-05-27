//
//  ZFLandScapeControlView.m
//  ZFPlayer
//
// Copyright (c) 2016年 任子丰 ( http://github.com/renzifeng )
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "ZFLandScapeControlView.h"
#import "UIView+ZFFrame.h"
#import "ZFUtilities.h"
#import "ZFReachabilityManager.h"
#if __has_include(<ZFPlayer/ZFPlayer.h>)
#import <ZFPlayer/ZFPlayer.h>
#else
#import "ZFPlayer.h"
#endif

#import "ZFDownLoadView.h"
#import "ZFPlayerToastView.h"
#import "ZFPlayerAlertView.h"
#import <Photos/Photos.h>

@interface ZFLandScapeControlView () <ZFSliderViewDelegate>
/// 顶部工具栏
@property (nonatomic, strong) UIView *topToolView;
/// 返回按钮
@property (nonatomic, strong) UIButton *backBtn;
/// 标题
@property (nonatomic, strong) UILabel *titleLabel;
/// 底部工具栏
@property (nonatomic, strong) UIView *bottomToolView;
/// 播放上一个
@property (nonatomic, strong) UIButton *previousPlayBtn;
/// 播放或暂停按钮
@property (nonatomic, strong) UIButton *playOrPauseBtn;
/// 中心播放按钮
@property (nonatomic, strong) UIButton *centerPlayBtn;
/// 播放下一个
@property (nonatomic, strong) UIButton *nextPlayBtn;
/// 下载
@property (nonatomic, strong) UIButton *downLoadBtn;

@property (nonatomic, strong) ZFDownLoadView *downLoacCoverView;

@property (nonatomic, strong) ZFPlayerAlertView *alertView;

/// 播放的当前时间 
@property (nonatomic, strong) UILabel *currentTimeLabel;
/// 滑杆
@property (nonatomic, strong) ZFSliderView *slider;
/// 视频总时间
@property (nonatomic, strong) UILabel *totalTimeLabel;
/// 锁定屏幕按钮
@property (nonatomic, strong) UIButton *lockBtn;

@property (nonatomic, assign) BOOL isShow;

@end

@implementation ZFLandScapeControlView

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self addSubview:self.topToolView];
        [self.topToolView addSubview:self.backBtn];
        [self.topToolView addSubview:self.titleLabel];
        
        [self addSubview:self.bottomToolView];
        [self.bottomToolView addSubview:self.previousPlayBtn];
        [self.bottomToolView addSubview:self.playOrPauseBtn];
        [self.bottomToolView addSubview:self.nextPlayBtn];
        [self.bottomToolView addSubview:self.downLoadBtn];
        
        [self.bottomToolView addSubview:self.currentTimeLabel];
        [self.bottomToolView addSubview:self.slider];
        [self.bottomToolView addSubview:self.totalTimeLabel];
        
        [self addSubview:self.lockBtn];
        [self addSubview:self.centerPlayBtn];
        [self addSubview:self.downLoacCoverView];
        [self addSubview:self.alertView];
        
        // 设置子控件的响应事件
        [self makeSubViewsAction];
        [self resetControlView];
        
        /// statusBarFrame changed
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(layoutControllerViews) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat min_x = 0;
    CGFloat min_y = 0;
    CGFloat min_w = 0;
    CGFloat min_h = 0;
    CGFloat min_view_w = self.bounds.size.width;
    CGFloat min_view_h = self.bounds.size.height;
    
    CGFloat min_margin = 9;
    
    min_x = 0;
    min_y = 0;
    min_w = min_view_w;
    min_h = iPhoneX ? 110 : 80;
    self.topToolView.frame = CGRectMake(min_x, min_y, min_w, min_h);

    min_x = (iPhoneX && UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) ? 44: 15;
    if (@available(iOS 13.0, *)) {
        min_y = UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation) ? 10 : (iPhoneX ? 40 : 20);
    } else {
        min_y = (iPhoneX && UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) ? 10: (iPhoneX ? 40 : 20);
    }
    min_w = 40;
    min_h = 40;
    self.backBtn.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    min_x = self.backBtn.zf_right + 5;
    min_y = 0;
    min_w = min_view_w - min_x - 15 ;
    min_h = 30;
    self.titleLabel.frame = CGRectMake(min_x, min_y, min_w, min_h);
    self.titleLabel.zf_centerY = self.backBtn.zf_centerY;
    
    min_h = iPhoneX ? 127 : 100;
    min_x = 0;
    min_y = min_view_h - min_h;
    min_w = min_view_w;
    self.bottomToolView.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    CGFloat center_y = 39;
    min_x = (iPhoneX && UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) ? 44: 15;
    min_y = 0;
    min_w = 50;
    min_h = 30;
    self.currentTimeLabel.frame = CGRectMake(min_x, min_y, min_w, min_h);
    self.currentTimeLabel.zf_centerY = center_y;
    
    min_w = 50;
    min_x = self.bottomToolView.zf_width - min_w - ((iPhoneX && UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) ? 44: min_margin);
    min_y = 0;
    min_h = 30;
    self.totalTimeLabel.frame = CGRectMake(min_x, min_y, min_w, min_h);
    self.totalTimeLabel.zf_centerY = center_y;
    
    min_x = self.currentTimeLabel.zf_right + 4;
    min_y = 0;
    min_w = self.totalTimeLabel.zf_left - min_x - 4;
    min_h = 30;
    self.slider.frame = CGRectMake(min_x, min_y, min_w, min_h);
    self.slider.zf_centerY = center_y;
    
    min_x = (iPhoneX && UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) ? 50: 21;
    min_y = center_y+20;
    min_w = 30;
    min_h = 30;
    self.previousPlayBtn.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    min_x = self.previousPlayBtn.zf_right + 15;
    min_y = self.previousPlayBtn.zf_top;
    min_w = 30;
    min_h = 30;
    self.playOrPauseBtn.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    min_x = self.playOrPauseBtn.zf_right + 15;
    min_y = self.previousPlayBtn.zf_top;
    min_w = 30;
    min_h = 30;
    self.nextPlayBtn.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    min_x = self.bottomToolView.zf_width - 45;
    min_y = self.previousPlayBtn.zf_top;
    min_w = 30;
    min_h = 30;
    self.downLoadBtn.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    min_x = (iPhoneX && UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) ? 50: 18;
    min_y = 0;
    min_w = 40;
    min_h = 40;
    self.lockBtn.frame = CGRectMake(min_x, min_y, min_w, min_h);
    self.lockBtn.zf_centerY = self.zf_centerY;
    
    if (!self.isShow) {
        self.topToolView.zf_y = -self.topToolView.zf_height;
        self.bottomToolView.zf_y = self.zf_height;
    } else {
        if (self.player.isLockedScreen) {
            self.topToolView.zf_y = -self.topToolView.zf_height;
            self.bottomToolView.zf_y = self.zf_height;
        } else {
            self.topToolView.zf_y = 0;
            self.bottomToolView.zf_y = self.zf_height - self.bottomToolView.zf_height;
        }
    }
    
    self.centerPlayBtn.center = self.center;
    self.downLoacCoverView.frame = CGRectMake(0, 0, self.zf_width, self.zf_height);
    self.alertView.center = self.center;
}

- (void)makeSubViewsAction {
    [self.backBtn addTarget:self action:@selector(backBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.nextPlayBtn addTarget:self action:@selector(nextPlayBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.playOrPauseBtn addTarget:self action:@selector(playPauseButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.centerPlayBtn addTarget:self action:@selector(playPauseButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.previousPlayBtn addTarget:self action:@selector(previousPlayBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.downLoadBtn addTarget:self action:@selector(downLoadBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.lockBtn addTarget:self action:@selector(lockButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - action

- (void)layoutControllerViews {
    [self layoutIfNeeded];
    [self setNeedsLayout];
}

- (void)backBtnClickAction:(UIButton *)sender {
    self.lockBtn.selected = NO;
    self.player.lockedScreen = NO;
    self.lockBtn.selected = NO;
    if (self.player.orientationObserver.supportInterfaceOrientation & ZFInterfaceOrientationMaskPortrait) {
        [self.player enterFullScreen:NO animated:YES];
    }
    if (self.backBtnClickCallback) {
        self.backBtnClickCallback();
    }
}

- (void)playPauseButtonClickAction:(UIButton *)sender {
    [self playOrPause];
}

/// 播放上一个
- (void)previousPlayBtnClickAction:(UIButton *)sender {
    
    if (!self.player.isFirstAssetURL) {
        [self.player playThePrevious];
        self.titleLabel.text = self.player.assetTitles[self.player.currentPlayIndex];
        [self showControlView];
    } else {
        [ZFPlayerToastView showToastMsg:@"已是第一个视频" withSuperView:self withLocationType:LocationType_Middle];
    }
}

/// 根据当前播放状态取反
- (void)playOrPause {
    self.playOrPauseBtn.selected = !self.playOrPauseBtn.isSelected;
    self.playOrPauseBtn.isSelected? [self.player.currentPlayerManager play]: [self.player.currentPlayerManager pause];
    self.centerPlayBtn.hidden = self.playOrPauseBtn.isSelected ? YES: NO;
    [self showControlView];
}

/// 播放下一个
- (void)nextPlayBtnClickAction:(UIButton *)sender {
    
    if (!self.player.isLastAssetURL) {
        [self.player playTheNext];
        self.titleLabel.text = self.player.assetTitles[self.player.currentPlayIndex];
        [self showControlView];
    } else {
        [ZFPlayerToastView showToastMsg:@"已是最后一个视频" withSuperView:self withLocationType:LocationType_Middle];
    }
}

/// 下载
- (void)downLoadBtnClickAction:(UIButton *)sender {
    
    //网络状态判断
    if ([ZFReachabilityManager sharedManager].networkReachabilityStatus == ZFReachabilityStatusNotReachable) {
        [ZFPlayerToastView showToastMsg:@"当前网络已断开" withSuperView:self withLocationType:LocationType_Middle];
        return;
    }
    
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted ||
        status == PHAuthorizationStatusDenied) {
        [ZFPlayerToastView showToastMsg:@"请打开相册权限" withSuperView:self withLocationType:LocationType_Middle];
        return;
    }
    
    if (self.player.currentPlayerManager.playState == ZFPlayerPlayStatePlaying) {
        [self playPauseButtonClickAction:sender];//下载的时候暂停播放
    }
    
    self.downLoacCoverView.hidden = NO;//先初始化遮住屏幕防止用户快速多次点击下载和点击其他按钮
    self.downLoacCoverView.downLoadProgress = 0.0;
    
    [self.player startDownLoad];
    
    @weakify(self)
    self.downLoacCoverView.cancelDownLoadBlock = ^{
        @strongify(self)
        [self.player pauseDownLoad];
        self.alertView.hidden = NO;
    };
    
    self.alertView.cancelCancelBlock = ^{
        @strongify(self)
        [self.player resumeDownLoad];
    };
    self.alertView.sureBtnBlock = ^{
        @strongify(self)
        [self.player cancelDownLoad];
    };
    
    self.player.downLoadProgressCallBack = ^(float progress) {
        @strongify(self)
        self.downLoacCoverView.downLoadProgress = progress;
    };
    
    self.player.didFinishDownLoadCallBack = ^(NSString * _Nonnull locationPath) {
        @strongify(self)
        self.downLoacCoverView.hidden = YES;
        if (self.downLoacCoverView.downLoadProgress < 0.95) {//当下载超过95%用户还点取消下载的话，就把已下载的部分也当成功保存到相册
            [self playPauseButtonClickAction:nil];
            BOOL deleteResult = [[NSFileManager defaultManager] removeItemAtPath:locationPath error:nil];
            deleteResult ? NSLog(@"删除已转码视频成功") : NSLog(@"删除已转码视频失败");
        } else {
            UISaveVideoAtPathToSavedPhotosAlbum(locationPath, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
        }
    };
    
    self.player.downLoadWithErrorCallBack = ^(NSString * _Nonnull description) {
        @strongify(self)
        self.alertView.hidden = YES;
        self.downLoacCoverView.hidden = YES;
        [self playPauseButtonClickAction:nil];
        [ZFPlayerToastView showToastMsg:description withSuperView:self withLocationType:LocationType_Middle];
    };
}

/// 保存到相册结果
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    
    [self playPauseButtonClickAction:nil];
    
    NSString *msg = error ? @"下载失败，请重试": @"下载完成，已保存至手机系统相册";
    [ZFPlayerToastView showToastMsg:msg withSuperView:self withLocationType:LocationType_Middle];
    BOOL deleteResult = [[NSFileManager defaultManager] removeItemAtPath:videoPath error:nil];
    deleteResult ? NSLog(@"删除已转码视频成功") : NSLog(@"删除已转码视频失败");
}


- (void)playBtnSelectedState:(BOOL)selected {
    self.playOrPauseBtn.selected = selected;
    self.centerPlayBtn.hidden = self.playOrPauseBtn.isSelected ? YES: NO;
}

- (void)lockButtonClickAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.player.lockedScreen = sender.selected;
}

#pragma mark - ZFSliderViewDelegate

- (void)sliderTouchBegan:(float)value {
    self.slider.isdragging = YES;
}

- (void)sliderTouchEnded:(float)value {
    if (self.player.totalTime > 0) {
        self.slider.isdragging = YES;
        if (self.sliderValueChanging) self.sliderValueChanging(value, self.slider.isForward);
        @weakify(self)
        [self.player seekToTime:self.player.totalTime*value completionHandler:^(BOOL finished) {
            @strongify(self)
            if (finished) {
                self.slider.isdragging = NO;
                if (self.sliderValueChanged) self.sliderValueChanged(value);
                if (self.seekToPlay) {
                    [self.player.currentPlayerManager play];
                }
            }
        }];
    } else {
        self.slider.isdragging = NO;
        self.slider.value = 0;
    }
}

- (void)sliderValueChanged:(float)value {
    if (self.player.totalTime == 0) {
        self.slider.value = 0;
        return;
    }
    self.slider.isdragging = YES;
    NSString *currentTimeString = [ZFUtilities convertTimeSecond:self.player.totalTime*value];
    self.currentTimeLabel.text = currentTimeString;
    if (self.sliderValueChanging) self.sliderValueChanging(value,self.slider.isForward);
}

- (void)sliderTapped:(float)value {
    [self sliderTouchEnded:value];
    NSString *currentTimeString = [ZFUtilities convertTimeSecond:self.player.totalTime*value];
    self.currentTimeLabel.text = currentTimeString;
}

#pragma mark - public method

/// 重置ControlView
- (void)resetControlView {
    self.slider.value                = 0;
    self.slider.bufferValue          = 0;
    self.currentTimeLabel.text       = @"00:00";
    self.totalTimeLabel.text         = @"00:00";
    self.backgroundColor             = [UIColor clearColor];
    self.playOrPauseBtn.selected     = YES;
    self.titleLabel.text             = @"";
    self.topToolView.alpha           = 1;
    self.bottomToolView.alpha        = 1;
    self.isShow                      = NO;
}

- (void)showControlView {
    self.lockBtn.alpha               = 1;
    self.isShow                      = YES;
    if (self.player.isLockedScreen) {
        self.topToolView.zf_y        = -self.topToolView.zf_height;
        self.bottomToolView.zf_y     = self.zf_height;
    } else {
        self.topToolView.zf_y        = 0;
        self.bottomToolView.zf_y     = self.zf_height - self.bottomToolView.zf_height;
    }
    self.lockBtn.zf_left             = iPhoneX ? 50: 18;
    self.player.statusBarHidden      = NO;
    if (self.player.isLockedScreen) {
        self.topToolView.alpha       = 0;
        self.bottomToolView.alpha    = 0;
    } else {
        self.topToolView.alpha       = 1;
        self.bottomToolView.alpha    = 1;
    }
}

- (void)hideControlView {
    self.isShow                      = NO;
    self.topToolView.zf_y            = -self.topToolView.zf_height;
    self.bottomToolView.zf_y         = self.zf_height;
    self.lockBtn.zf_left             = iPhoneX ? -82: -47;
    self.player.statusBarHidden      = YES;
    self.topToolView.alpha           = 0;
    self.bottomToolView.alpha        = 0;
    self.lockBtn.alpha               = 0;
}

- (BOOL)shouldResponseGestureWithPoint:(CGPoint)point withGestureType:(ZFPlayerGestureType)type touch:(nonnull UITouch *)touch {
    CGRect sliderRect = [self.bottomToolView convertRect:self.slider.frame toView:self];
    if (CGRectContainsPoint(sliderRect, point)) {
        return NO;
    }
    if (self.player.isLockedScreen && type != ZFPlayerGestureTypeSingleTap) { // 锁定屏幕方向后只相应tap手势
        return NO;
    }
    return YES;
}

- (void)videoPlayer:(ZFPlayerController *)videoPlayer presentationSizeChanged:(CGSize)size {
//    self.lockBtn.hidden = self.player.orientationObserver.fullScreenMode == ZFFullScreenModePortrait;
    self.lockBtn.hidden = YES;
}

- (void)videoPlayer:(ZFPlayerController *)videoPlayer currentTime:(NSTimeInterval)currentTime totalTime:(NSTimeInterval)totalTime {
    if (!self.slider.isdragging) {
        NSString *currentTimeString = [ZFUtilities convertTimeSecond:currentTime];
        self.currentTimeLabel.text = currentTimeString;
        NSString *totalTimeString = [ZFUtilities convertTimeSecond:totalTime];
        self.totalTimeLabel.text = totalTimeString;
        self.slider.value = videoPlayer.progress;
    }
}

- (void)videoPlayer:(ZFPlayerController *)videoPlayer bufferTime:(NSTimeInterval)bufferTime {
    self.slider.bufferValue = videoPlayer.bufferProgress;
}

- (void)showTitle:(NSString *)title fullScreenMode:(ZFFullScreenMode)fullScreenMode {
    self.titleLabel.text = title;
    self.player.orientationObserver.fullScreenMode = fullScreenMode;
//    self.lockBtn.hidden = fullScreenMode == ZFFullScreenModePortrait;
    self.lockBtn.hidden = YES;
}

/// 调节播放进度slider和当前时间更新
- (void)sliderValueChanged:(CGFloat)value currentTimeString:(NSString *)timeString {
    self.slider.value = value;
    self.currentTimeLabel.text = timeString;
    self.slider.isdragging = YES;
    [UIView animateWithDuration:0.3 animations:^{
        self.slider.sliderBtn.transform = CGAffineTransformMakeScale(1.2, 1.2);
    }];
}

/// 滑杆结束滑动
- (void)sliderChangeEnded {
    self.slider.isdragging = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.slider.sliderBtn.transform = CGAffineTransformIdentity;
    }];
}

#pragma mark - getter

- (UIView *)topToolView {
    if (!_topToolView) {
        _topToolView = [[UIView alloc] init];
        UIImage *image = ZFPlayer_Image(@"ZFPlayer_top_shadow");
        _topToolView.layer.contents = (id)image.CGImage;
    }
    return _topToolView;
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:ZFPlayer_Image(@"ZFPlayer_back_full") forState:UIControlStateNormal];
    }
    return _backBtn;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:17.0 weight:UIFontWeightBold];
    }
    return _titleLabel;
}


- (UIView *)bottomToolView {
    if (!_bottomToolView) {
        _bottomToolView = [[UIView alloc] init];
        UIImage *image = ZFPlayer_Image(@"ZFPlayer_bottom_shadow");
        _bottomToolView.layer.contents = (id)image.CGImage;
    }
    return _bottomToolView;
}

- (UIButton *)previousPlayBtn {
    if (!_previousPlayBtn) {
        _previousPlayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_previousPlayBtn setImage:ZFPlayer_Image(@"ZFPlayer_previous") forState:UIControlStateNormal];
    }
    return _previousPlayBtn;
}

- (UIButton *)playOrPauseBtn {
    if (!_playOrPauseBtn) {
        _playOrPauseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playOrPauseBtn setImage:ZFPlayer_Image(@"ZFPlayer_play") forState:UIControlStateNormal];
        [_playOrPauseBtn setImage:ZFPlayer_Image(@"ZFPlayer_pause") forState:UIControlStateSelected];
    }
    return _playOrPauseBtn;
}

- (UIButton *)nextPlayBtn {
    if (!_nextPlayBtn) {
        _nextPlayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nextPlayBtn setImage:ZFPlayer_Image(@"ZFPlayer_next") forState:UIControlStateNormal];
    }
    return _nextPlayBtn;
}

- (UIButton *)downLoadBtn {
    if (!_downLoadBtn) {
        _downLoadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_downLoadBtn setImage:ZFPlayer_Image(@"ZFPlayer_download") forState:UIControlStateNormal];
    }
    return _downLoadBtn;
}


- (UILabel *)currentTimeLabel {
    if (!_currentTimeLabel) {
        _currentTimeLabel = [[UILabel alloc] init];
        _currentTimeLabel.textColor = [UIColor whiteColor];
        _currentTimeLabel.font = [UIFont systemFontOfSize:14.0f];
        _currentTimeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _currentTimeLabel;
}

- (ZFSliderView *)slider {
    if (!_slider) {
        _slider = [[ZFSliderView alloc] init];
        _slider.delegate = self;
        _slider.maximumTrackTintColor = [ZFUtilities colorWithHexCode:@"#FFFFFF60"];
        _slider.bufferTrackTintColor  = [ZFUtilities colorWithHexCode:@"#FFFFFF90"];
        _slider.minimumTrackTintColor = [ZFUtilities colorWithHexCode:@"#0B58EE"];
        [_slider setThumbImage:ZFPlayer_Image(@"ZFPlayer_slider") forState:UIControlStateNormal];
        _slider.sliderHeight = 2;
    }
    return _slider;
}

- (UILabel *)totalTimeLabel {
    if (!_totalTimeLabel) {
        _totalTimeLabel = [[UILabel alloc] init];
        _totalTimeLabel.textColor = [UIColor whiteColor];
        _totalTimeLabel.font = [UIFont systemFontOfSize:14.0f];
        _totalTimeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _totalTimeLabel;
}

- (UIButton *)lockBtn {
    if (!_lockBtn) {
        _lockBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_lockBtn setImage:ZFPlayer_Image(@"ZFPlayer_unlock-nor") forState:UIControlStateNormal];
        [_lockBtn setImage:ZFPlayer_Image(@"ZFPlayer_lock-nor") forState:UIControlStateSelected];
    }
    return _lockBtn;
}

- (UIButton *)centerPlayBtn {
    if (!_centerPlayBtn) {
        _centerPlayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _centerPlayBtn.frame = CGRectMake(0, 0, 58, 58);
        [_centerPlayBtn setBackgroundImage:ZFPlayer_Image(@"ZFPlayer_centerPlay") forState:UIControlStateNormal];
        _centerPlayBtn.hidden = YES;
    }
    return _centerPlayBtn;
}

- (ZFDownLoadView *)downLoacCoverView {
    if (!_downLoacCoverView) {
        _downLoacCoverView = [[ZFDownLoadView alloc] initWithFrame:CGRectMake(0, 0, self.zf_width, self.zf_height)];
        _downLoacCoverView.hidden = YES;
    }
    return _downLoacCoverView;;
}

- (ZFPlayerAlertView *)alertView {
    if (!_alertView) {
        _alertView = [[ZFPlayerAlertView alloc] init];
        _alertView.hidden = YES;
    }
    return _alertView;
}

@end
