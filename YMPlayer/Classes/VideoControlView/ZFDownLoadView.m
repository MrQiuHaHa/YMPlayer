//
//  ZFDownLoadView.m
//  Pods
//
//  Created by 邱俊荣 on 2020/4/28.
//

#import "ZFDownLoadView.h"
#import "ZFUtilities.h"
#import "UIView+ZFFrame.h"

@interface ZFDownLoadView ()

@property (nonatomic, strong) UILabel *progressLab;
@property (nonatomic, strong) UIView *progressView;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIView *progressBgView;
@end

@implementation ZFDownLoadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self setUpBaseUI];
    }
    return self;
}

- (void)setUpBaseUI {
    
    UIView *bgView = [[UIView alloc] init];
    bgView.center = self.center;
    bgView.backgroundColor = [ZFUtilities colorWithHexCode:@"#25262D"];
    bgView.layer.cornerRadius = 2;
    bgView.clipsToBounds = YES;
    [self addSubview:bgView];
    self.bgView = bgView;
    
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.text = @"正在下载请勿离开";
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.textColor = [UIColor whiteColor];
    titleLab.font = [UIFont systemFontOfSize:15];
    [bgView addSubview:titleLab];
    self.titleLab = titleLab;
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setImage:ZFPlayer_Image(@"ZFPlayer_downLoad_cancel") forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelBtnClickAction) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:cancelBtn];
    self.cancelBtn = cancelBtn;
    
    UIView *progressBgView = [[UIView alloc] init];
    progressBgView.backgroundColor = [ZFUtilities colorWithHexCode:@"#E9E9E9"];
    progressBgView.layer.cornerRadius = 2;
    [bgView addSubview:progressBgView];
    self.progressBgView = progressBgView;
    
    self.progressView = [[UIView alloc] init];
    self.progressView.backgroundColor = [ZFUtilities colorWithHexCode:@"#0B58EE"];
    self.progressView.layer.cornerRadius = 2;
    [bgView addSubview:self.progressView];
    
    self.progressLab = [[UILabel alloc] init];
    self.progressLab.textColor = [UIColor whiteColor];
    self.progressLab.font = [UIFont systemFontOfSize:12];
    self.progressLab.text = @"0%";
    [bgView addSubview:self.progressLab];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.bgView.frame = CGRectMake(0, 0, 254, 72);
    self.bgView.center = self.center;
    self.titleLab.frame = CGRectMake(40, 15, 254-80, 15);
    self.cancelBtn.frame = CGRectMake(254-28, 0, 28, 28);
    self.progressBgView.frame = CGRectMake(24, 49, 175, 4);
    self.progressView.frame = CGRectMake(24, 49, 0, 4);
    self.progressLab.frame = CGRectMake(self.progressBgView.zf_right+4, 45, 50, 12);
}

- (void)setDownLoadProgress:(float)downLoadProgress {
    
    _downLoadProgress = downLoadProgress;
    if (downLoadProgress >= 0 && downLoadProgress <= 1.0) {
        self.progressView.zf_width = (CGFloat)175.0 * downLoadProgress;
        self.progressLab.text = [NSString stringWithFormat:@"%.f%%",downLoadProgress*100];
    }
}

- (void)cancelBtnClickAction {
    if (self.cancelDownLoadBlock) {
        self.cancelDownLoadBlock();
    }
}

@end
