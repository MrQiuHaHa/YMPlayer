//
//  ZFPlayerAlertView.m
//  Pods
//
//  Created by 邱俊荣 on 2020/4/28.
//

#import "ZFPlayerAlertView.h"
#import "UIView+ZFFrame.h"
#import "ZFUtilities.h"

@implementation ZFPlayerAlertView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, 315, 127);
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 6;
        [self setBaseUI];
    }
    return self;
}

- (void)setBaseUI {
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.zf_width, self.zf_height-52)];
    titleLab.text = @"是否确认取消本次下载？";
    titleLab.textColor = [ZFUtilities colorWithHexCode:@"#383C41"];
    titleLab.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    titleLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleLab];
    
    UIView *horizontal_line = [[UIView alloc] initWithFrame:CGRectMake(0, titleLab.zf_bottom, self.zf_width, 1)];
    horizontal_line.backgroundColor = [ZFUtilities colorWithHexCode:@"#E2E2E2"];
    [self addSubview:horizontal_line];
    
    for (int i = 0; i < 2; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = 100+i;
        [btn setTitle:i == 0 ? @"取消": @"确定" forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:16];
        [btn setTitleColor:[ZFUtilities colorWithHexCode:@"#333333"] forState:UIControlStateNormal];
        btn.frame = CGRectMake(i*self.zf_width/2.0, horizontal_line.zf_bottom, self.zf_width/2.0, 51);
        [btn addTarget:self action:@selector(bottomBtmClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
    
    UIView *vertical_line = [[UIView alloc] initWithFrame:CGRectMake(self.zf_width/2.0, horizontal_line.zf_bottom, 1, 51)];
    vertical_line.backgroundColor = [ZFUtilities colorWithHexCode:@"#E2E2E2"];
    [self addSubview:vertical_line];
}

- (void)bottomBtmClickAction:(UIButton *)button {
    
    self.hidden = YES;
    
    if (button.tag == 100) {
        if (self.cancelCancelBlock) {
            self.cancelCancelBlock();
        }
    } else {
        if (self.sureBtnBlock) {
            self.sureBtnBlock();
        }
    }
}

@end
