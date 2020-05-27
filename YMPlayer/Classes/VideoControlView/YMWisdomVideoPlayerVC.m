//
//  YMWisdomVideoPlayerVC.m
//  Pods
//
//  Created by 邱俊荣 on 2020/4/28.
//

#import "YMWisdomVideoPlayerVC.h"

#if __has_include(<YMPlayer/ZFPlayer.h>)
#import <YMPlayer/ZFPlayer.h>
#else
#import "ZFPlayer.h"
#endif

//#if __has_include(<YMPlayer/KSMediaPlayerManager.h>)
//#import <YMPlayer/KSMediaPlayerManager.h>
//#else
//#import "KSMediaPlayerManager.h"
//#endif

#if __has_include(<YMPlayer/ZFIJKPlayerManager.h>)
#import <YMPlayer/ZFIJKPlayerManager.h>
#else
#import "ZFIJKPlayerManager.h"
#endif

#import "ZFAVPlayerManager.h"
#import "ZFPlayerControlView.h"

@interface YMWisdomVideoPlayerVC ()
@property (nonatomic, strong) ZFPlayerController *player;
@property (nonatomic, strong) ZFPlayerControlView *controlView;

@end

@implementation YMWisdomVideoPlayerVC


- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.index = 0;
    }
    return self;
}

- (void)dealloc {
    NSLog(@"YMWisdomVideoPlayerVC --- dealloc");
    [self.player enterFullScreen:NO animated:NO];
    [self.player stop];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    @weakify(self)
    self.controlView.backBtnClickCallback = ^{
        @strongify(self)
        [self.player enterFullScreen:NO animated:NO];
        [self.player stop];
        [self.navigationController popViewControllerAnimated:NO];
    };
    
//    ZFAVPlayerManager *playerManager = [[ZFAVPlayerManager alloc] init];
//    KSMediaPlayerManager *playerManager = [[KSMediaPlayerManager alloc] init];
    ZFIJKPlayerManager *playerManager = [[ZFIJKPlayerManager alloc] init];
    
    self.player = [[ZFPlayerController alloc] initWithPlayerManager:playerManager containerView:self.view];
    self.player.controlView = self.controlView;
    self.player.assetURLs = self.assetURLs;
    self.player.assetTitles = self.assetTitles;
    [self.player playTheIndex:self.index];
    self.player.orientationObserver.supportInterfaceOrientation = ZFInterfaceOrientationMaskLandscape;
    [self.controlView showTitle:self.assetTitles[self.index] coverURLString:nil fullScreenMode:ZFFullScreenModeLandscape];
    [self.player enterFullScreen:YES animated:NO];
    /// 设置退到后台继续播放
    self.player.pauseWhenAppResignActive = NO;
    
    self.player.playerDidToEnd = ^(id<ZFPlayerMediaPlayback>  _Nonnull asset) {
        @strongify(self)
        [self.player.currentPlayerManager replay];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.player.currentPlayerManager pause];
        });
    };
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.player.viewControllerDisappear = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.player.viewControllerDisappear = YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    if (self.player.isFullScreen) {
        return UIStatusBarStyleLightContent;
    }
    return UIStatusBarStyleDefault;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationSlide;
}

- (BOOL)shouldAutorotate {
    return self.player.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationLandscapeRight;
}

- (ZFPlayerControlView *)controlView {
    if (!_controlView) {
        _controlView = [ZFPlayerControlView new];
        _controlView.fastViewAnimated = YES;
        _controlView.effectViewShow = NO;
        _controlView.prepareShowLoading = YES;
        _controlView.prepareShowControlView = YES;
        _controlView.autoHiddenTimeInterval = 5;
        _controlView.autoFadeTimeInterval = 0.5;
    }
    return _controlView;
}



@end
