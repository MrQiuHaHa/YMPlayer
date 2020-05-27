//
//  YMPhotosBrowseVC.m
//  Pods
//
//  Created by 邱俊荣 on 2020/4/29.
//

#import "YMPhotosBrowseVC.h"
#import "ZFUtilities.h"
#import "UIView+ZFFrame.h"
#import "YMPhotosBrowseCell.h"
#import "ZFPlayerToastView.h"
#import "UIImageView+ZFCache.h"
#import <Photos/Photos.h>

@interface YMPhotosBrowseVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic , strong) UICollectionView *collectionView;
@property (nonatomic , strong) UIPageControl *pageControl;
@property (nonatomic, strong) UIActivityIndicatorView * activityIndicator;
@end

@implementation YMPhotosBrowseVC


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.imageTitlesArr[self.currentIndex];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *leftBtn = [self createBarButtonItem:@"ZFPlayer_navbar_back" title:nil action:@selector(onBackButtonClick) isRight:NO];
    [self setButtonsWithButton:leftBtn twoButton:nil isRight:NO];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(self.view.zf_width, ZFPlayer_ScreenHeight-ZFPlayer_TOP_HEIGHT-ZFPlayer_BOTTOM_HEIGHT-50);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.zf_width, ZFPlayer_ScreenHeight-ZFPlayer_TOP_HEIGHT-ZFPlayer_BOTTOM_HEIGHT-50) collectionViewLayout:layout];
    self.collectionView.pagingEnabled = YES;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.bounces = YES;
    self.collectionView.backgroundColor = [ZFUtilities colorWithHexCode:@"#F3F4F5"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    
    [self.view addSubview:self.collectionView];
    
    [self.collectionView registerClass:[YMPhotosBrowseCell class] forCellWithReuseIdentifier:@"YMPhotosBrowseCell"];
    
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.collectionView.zf_height - 40, self.view.zf_width, 40)];
    self.pageControl.userInteractionEnabled = NO;
    self.pageControl.numberOfPages = self.imagesArr.count;
    [self.view addSubview:self.pageControl];
    
    
    if (@available(iOS 11.0, *)) {
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    if (self.pageControl.numberOfPages <= 1) {
        self.pageControl.hidden = YES;
    } else {
        self.pageControl.currentPage = self.currentIndex;
    }
    
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityIndicator.frame= CGRectMake(ZFPlayer_ScreenWidth/2.0-15, ZFPlayer_ScreenHeight/2.0-15, 30, 30);
    [self.view addSubview:self.activityIndicator];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.collectionView.zf_height, ZFPlayer_ScreenWidth, 50)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    UIButton *downBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    downBtn.frame = CGRectMake(self.view.zf_width-24-30, 0, 24+30, 50);
    [downBtn setImage:ZFPlayer_Image(@"ZFPlayer_image_download") forState:UIControlStateNormal];
    [downBtn addTarget:self action:@selector(imageDownLoadClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:downBtn];
    
}

#pragma mark - 点击下载
- (void)imageDownLoadClickAction:(UIButton *)btn {
    
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted ||
        status == PHAuthorizationStatusDenied) {
        [ZFPlayerToastView showToastMsg:@"请打开相册权限" withSuperView:self.view];
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    [self.activityIndicator startAnimating];
    NSString *urlStr = self.imagesArr[self.currentIndex];
    ZFImageDownloader *downLoader = [[ZFImageDownloader alloc] init];
    [downLoader startDownloadImageWithUrl:urlStr progress:nil finished:^(NSURL *location, NSData *data, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.activityIndicator stopAnimating];
            UIImage *image = [UIImage imageWithData:data];
            if (image.size.width > 100 && image.size.height > 100) {
                UIImageWriteToSavedPhotosAlbum(image, weakSelf, @selector(image:didFinishSavingWithError:contextInfo:), nil);
            } else {
                [ZFPlayerToastView showToastMsg:@"下载失败，请重试" withSuperView:self.view];
            }
        });
    }];
}

#pragma mark - 保存到相册结果
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSString *msg = error ? @"下载失败，请重试": @"下载完成，已保存至手机系统相册";
    [ZFPlayerToastView showToastMsg:msg withSuperView:self.view];
}


#pragma mark - UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.imagesArr.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    YMPhotosBrowseCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YMPhotosBrowseCell" forIndexPath:indexPath];
    cell.imageUrl = self.imagesArr[indexPath.row];
    return cell;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    CGFloat width = self.view.zf_width;
    float offset = (float)(scrollView.contentOffset.x/width);
    if (offset < 0) {
        [ZFPlayerToastView showToastMsg:@"已是第一张" withSuperView:self.view];
    }
    if (offset > self.imagesArr.count-1) {
        [ZFPlayerToastView showToastMsg:@"已是最后一张" withSuperView:self.view];
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

    CGFloat width = self.view.zf_width;
    NSInteger page = (NSInteger)(scrollView.contentOffset.x/width);
    self.pageControl.currentPage = page;
    self.currentIndex = page;
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:page inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:true];
    self.title = self.imageTitlesArr[self.currentIndex];
}

- (void)onBackButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 设置导航栏按钮适配
- (UIButton *)createBarButtonItem:(NSString *)image title:(NSString *)title action:(SEL)action isRight:(BOOL)isRight {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    button.zf_height = 40;
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    int x = 0;
    if (@available(iOS 13.0, *)) {
        
        x = isRight ? 16: 0;
    }else {
    
        x = 8;
    }
    
    // UI规范，不存在图文并存，有icon优先显示icon
    if (image) {
        button.zf_width = 40;
        
        UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(x, 8, button.zf_width - 16, button.zf_height - 16)];
        icon.contentMode = UIViewContentModeCenter;
        icon.image = ZFPlayer_Image(image);
        [button addSubview:icon];
    }else if (title) {
        CGSize size = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, 40) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:17]} context:nil].size;
        button.zf_width = size.width < 40 ? 56: size.width + 16;
        UILabel * titleLab = [[UILabel alloc]initWithFrame:CGRectMake(x, 8, button.zf_width - 16, button.zf_height - 16)];
        titleLab.font = [UIFont systemFontOfSize:17];
        titleLab.text = title;
        titleLab.textAlignment = isRight ? NSTextAlignmentRight: NSTextAlignmentLeft;
        titleLab.textColor = [ZFUtilities colorWithHexCode:@"#0B58EE"];
        [button addSubview:titleLab];
    }else {
        return nil;
    }
    return button;
}
- (void)setButtonsWithButton:(UIButton *)button
                   twoButton:(UIButton *)twoButton
                     isRight:(BOOL)isRight
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, button.zf_width + twoButton.zf_width + 16, button.zf_height)];
    
    view.backgroundColor = [UIColor clearColor];
    
    if (button) {
        if (@available(iOS 13.0, *)) {
            
            button.zf_x = isRight ? 16: 0;
        }else {
        
            button.zf_x = 8;
        }
        
        [view addSubview:button];
    }
    if (twoButton) {
        if (@available(iOS 13.0, *)) {
                   
                   twoButton.zf_x = button.zf_width + (isRight ? 16: 0);
               }else {
               
                   twoButton.zf_x = button.zf_width + 8;
               }
        [view addSubview:twoButton];
    }
    
    if (isRight) {
        view.tag = 999;
        UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc]initWithCustomView:view];
        self.navigationItem.rightBarButtonItem = rightBtnItem;
        
    }else {
        view.tag = 998;
        UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc]initWithCustomView:view];
        self.navigationItem.leftBarButtonItem = leftBtnItem;
        
    }
}
@end
