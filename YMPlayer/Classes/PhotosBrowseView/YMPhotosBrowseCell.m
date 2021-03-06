//
//  YMPhotosBrowseCell.m
//  Pods
//
//  Created by 邱俊荣 on 2020/4/29.
//

#import "YMPhotosBrowseCell.h"
#import "ZFUtilities.h"
#import "UIView+ZFFrame.h"
#import "UIImageView+ZFCache.h"

@interface YMPhotosBrowseCell () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView * scrollView;

@property (nonatomic, strong) UIImageView * placeHolderImageView;

@end

@implementation YMPhotosBrowseCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.contentView.bounds];
        scrollView.delegate = self;
        scrollView.maximumZoomScale = 5.0;//最大缩放倍数
        scrollView.minimumZoomScale = 1.0;//最小缩放倍数
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        [self.contentView addSubview:scrollView];
        self.scrollView = scrollView;
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.userInteractionEnabled = YES;//在UIImageView上加手势识别，打开用户交互
        
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        [doubleTap setNumberOfTapsRequired:2];
        [imageView addGestureRecognizer:doubleTap];//添加双击手势
        
        [scrollView addSubview:imageView];
        self.placeHolderImageView = imageView;
        
    }
    return self;
}

#pragma mark UIScrollViewDelegate
//指定缩放UIScrolleView时，缩放UIImageView来适配
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.placeHolderImageView;
}

//缩放后让图片显示到屏幕中间
-(void)scrollViewDidZoom:(UIScrollView *)scrollView{
    CGSize originalSize = _scrollView.bounds.size;
    CGSize contentSize = _scrollView.contentSize;
    CGFloat offsetX = originalSize.width > contentSize.width ? (originalSize.width - contentSize.width) / 2 : 0;
    CGFloat offsetY = originalSize.height > contentSize.height ? (originalSize.height - contentSize.height) / 2 : 0;
    self.placeHolderImageView.center = CGPointMake(contentSize.width / 2 + offsetX, contentSize.height / 2 + offsetY);
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)recongnizer
{
    UIGestureRecognizerState state = recongnizer.state;
    switch (state) {
        case UIGestureRecognizerStateBegan:
            break;
        case UIGestureRecognizerStateChanged:
            break;
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:
        {
            //以点击点为中心，放大图片
            CGPoint touchPoint = [recongnizer locationInView:recongnizer.view];
            BOOL zoomOut = self.scrollView.zoomScale == self.scrollView.minimumZoomScale;
            CGFloat scale = zoomOut?self.scrollView.maximumZoomScale:self.scrollView.minimumZoomScale;
            [UIView animateWithDuration:0.3 animations:^{
                self.scrollView.zoomScale = scale;
                if(zoomOut){
                    CGFloat x = touchPoint.x*scale - self.scrollView.bounds.size.width / 2;
                    CGFloat maxX = self.scrollView.contentSize.width-self.scrollView.bounds.size.width;
                    CGFloat minX = 0;
                    x = x > maxX ? maxX : x;
                    x = x < minX ? minX : x;
                    
                    CGFloat y = touchPoint.y * scale-self.scrollView.bounds.size.height / 2;
                    CGFloat maxY = self.scrollView.contentSize.height-self.scrollView.bounds.size.height;
                    CGFloat minY = 0;
                    y = y > maxY ? maxY : y;
                    y = y < minY ? minY : y;
                    self.scrollView.contentOffset = CGPointMake(x, y);
                }
            }];
            
        }
            break;
        default:break;
    }
}

- (void)setPlaceHolderImageViewFrame
{
    CGFloat width = self.placeHolderImageView.image.size.width;
    CGFloat height = self.placeHolderImageView.image.size.height;
    CGFloat maxHeight = self.scrollView.bounds.size.height;
    CGFloat maxWidth = self.scrollView.bounds.size.width;
    //如果图片尺寸大于view尺寸，按比例缩放
    if(width > maxWidth || height > width){
        CGFloat ratio = height / width;
        CGFloat maxRatio = maxHeight / maxWidth;
        if(ratio < maxRatio){
            width = maxWidth;
            height = width*ratio;
        }else{
            height = maxHeight;
            width = height / ratio;
        }
    }
    self.placeHolderImageView.frame = CGRectMake((maxWidth - width) / 2, (maxHeight - height) / 2, width, height);
}

- (void)setImageUrl:(NSString *)imageUrl {
    _imageUrl = imageUrl;
    __weak typeof(self) weakSelf = self;
    [self.placeHolderImageView setImageWithURLString:imageUrl placeholder:ZFPlayer_Image(@"YMPlayer_PlaceHoler_image") completion:^(UIImage *image) {
        [weakSelf setPlaceHolderImageViewFrame];
    }];
    [self setPlaceHolderImageViewFrame];
}

@end
